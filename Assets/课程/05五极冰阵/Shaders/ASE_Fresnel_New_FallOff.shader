// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SinVFX/ASE_Fresnel_New_FallOff"
{
	Properties
	{
		_NormalTex("NormalTex", 2D) = "bump" {}
		_NormalU("NormalU", Float) = 0
		_NormalV("NormalV", Float) = 0
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_Indensity("Indensity", Float) = 0
		_Power1("Power1", Float) = 5
		_Bias1("Bias1", Float) = 0
		_Scale1("Scale1", Float) = 1
		_Power2("Power2", Float) = 5
		_Bias2("Bias2", Float) = 0
		_Scale2("Scale2", Float) = 1
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskTexU("MaskTexU", Float) = 0
		_MaskTexV("MaskTexV", Float) = 0
		_DepthFadeIndensity("DepthFadeIndensity", Float) = 1
		[Toggle(_OFFSET_ON)] _Offset("Offset", Float) = 0
		_OffsetTex("OffsetTex", 2D) = "white" {}
		_OffsetU("OffsetU", Float) = 0
		_OffsetV("OffsetV", Float) = 0
		_OffsetIntensity("OffsetIntensity", Float) = 0
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One , One One
		BlendOp Add , Add
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature _OFFSET_ON


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
			};

			uniform float _OffsetIntensity;
			uniform sampler2D _OffsetTex;
			uniform float _OffsetU;
			uniform float _OffsetV;
			uniform sampler2D _NormalTex;
			uniform float _NormalU;
			uniform float _NormalV;
			uniform float4 _NormalTex_ST;
			uniform float _Bias1;
			uniform float _Scale1;
			uniform float _Power1;
			uniform float _Bias2;
			uniform float _Scale2;
			uniform float _Power2;
			uniform float _Indensity;
			uniform float4 _Color;
			uniform sampler2D _MaskTex;
			uniform float _MaskTexU;
			uniform float _MaskTexV;
			uniform float4 _MaskTex_ST;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _DepthFadeIndensity;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult38 = (float2(_OffsetU , _OffsetV));
				float2 uv040 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				#ifdef _OFFSET_ON
				float4 staticSwitch48 = ( _OffsetIntensity * ( tex2Dlod( _OffsetTex, float4( ( ( appendResult38 * _Time.y ) + uv040 ), 0, 0.0) ) * float4( v.ase_normal , 0.0 ) ) * v.color.a );
				#else
				float4 staticSwitch48 = float4( 0,0,0,0 );
				#endif
				
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = staticSwitch48.rgb;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float2 appendResult30 = (float2(_NormalU , _NormalV));
				float2 uv0_NormalTex = i.ase_texcoord1.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;
				float3 tex2DNode5 = UnpackNormal( tex2D( _NormalTex, ( ( appendResult30 * _Time.y ) + uv0_NormalTex ) ) );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal1 = tex2DNode5;
				float fresnelNdotV1 = dot( float3(dot(tanToWorld0,tanNormal1), dot(tanToWorld1,tanNormal1), dot(tanToWorld2,tanNormal1)), ase_worldViewDir );
				float fresnelNode1 = ( _Bias1 + _Scale1 * pow( 1.0 - fresnelNdotV1, _Power1 ) );
				float clampResult22 = clamp( fresnelNode1 , 0.0 , 1.0 );
				float3 tanNormal18 = tex2DNode5;
				float fresnelNdotV18 = dot( float3(dot(tanToWorld0,tanNormal18), dot(tanToWorld1,tanNormal18), dot(tanToWorld2,tanNormal18)), ase_worldViewDir );
				float fresnelNode18 = ( _Bias2 + _Scale2 * pow( 1.0 - fresnelNdotV18, _Power2 ) );
				float clampResult21 = clamp( ( 1.0 - fresnelNode18 ) , 0.0 , 1.0 );
				float2 appendResult52 = (float2(_MaskTexU , _MaskTexV));
				float2 uv0_MaskTex = i.ase_texcoord1.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 screenPos = i.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth24 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth24 = abs( ( screenDepth24 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeIndensity ) );
				float clampResult25 = clamp( distanceDepth24 , 0.0 , 1.0 );
				
				
				finalColor = ( ( ( ( clampResult22 * clampResult21 ) * _Indensity * _Color ) * tex2D( _MaskTex, ( ( appendResult52 * _Time.y ) + uv0_MaskTex ) ) ) * clampResult25 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17000
0;0;1920;1029;2378.096;-164.8814;1.710107;True;True
Node;AmplifyShaderEditor.RangedFloatNode;28;-2791.042,-96.34895;Float;False;Property;_NormalV;NormalV;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2794.042,-173.3493;Float;False;Property;_NormalU;NormalU;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2620.042,-153.3493;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-2654.504,-47.94186;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2573.603,22.35794;Float;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-2457.042,-155.3493;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;34;-1125.097,1197.294;Float;False;1859.316;500.0784;顶点偏移;14;48;47;46;45;44;43;42;41;40;39;38;37;36;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-2298.78,-158.9263;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1075.097,1365.337;Float;False;Property;_OffsetU;OffsetU;17;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1072.098,1442.336;Float;False;Property;_OffsetV;OffsetV;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2044.061,572.593;Float;False;Property;_Scale2;Scale2;10;0;Create;True;0;0;False;0;1;0.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2031.997,501.5477;Float;False;Property;_Bias2;Bias2;9;0;Create;True;0;0;False;0;0;-0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2033.248,648.1889;Float;False;Property;_Power2;Power2;8;0;Create;True;0;0;False;0;5;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-2108.767,-119.5766;Float;True;Property;_NormalTex;NormalTex;0;0;Create;True;0;0;False;0;9a4a55d8d2e54394d97426434477cdcf;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1830.418,104.2834;Float;False;Property;_Bias1;Bias1;6;0;Create;True;0;0;False;0;0;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1523.86,829.788;Float;False;Property;_MaskTexU;MaskTexU;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1831.669,250.9248;Float;False;Property;_Power1;Power1;5;0;Create;True;0;0;False;0;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1520.861,906.7878;Float;False;Property;_MaskTexV;MaskTexV;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1842.482,175.3289;Float;False;Property;_Scale1;Scale1;7;0;Create;True;0;0;False;0;1;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-859.9787,1360.811;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;37;-862.4427,1453.417;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;18;-1710.86,523.996;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-1509.281,126.7317;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-863.7416,1524.917;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-696.9792,1358.811;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1369.499,508.9883;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-1349.86,819.3879;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-1352.323,911.9949;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-1353.623,983.4948;Float;False;0;14;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1186.86,817.3879;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-560.2124,1359.391;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;22;-1206.459,-30.97308;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;21;-1148.607,577.3597;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-405.0023,806.6126;Float;False;Property;_DepthFadeIndensity;DepthFadeIndensity;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-749.4163,476.7579;Float;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1160.878,170.636;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1032.741,830.9822;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;43;-218.6462,1325.913;Float;True;Property;_OffsetTex;OffsetTex;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;42;-113.5822,1518.372;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-810.8347,377.6508;Float;False;Property;_Indensity;Indensity;4;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-796.7127,708.8973;Float;True;Property;_MaskTex;MaskTex;11;0;Create;True;0;0;False;0;None;1b1d745d288cfc74ba139775d88b2515;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-562.8062,170.0885;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;46;104.8807,1477.31;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;93.30571,1330.413;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-10.10028,1247.294;Float;False;Property;_OffsetIntensity;OffsetIntensity;19;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;24;-142.2173,793.2085;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-272.5993,330.7618;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;25;120.2747,784.4182;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;293.4827,1299.707;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;48;433.2198,1270.547;Float;False;Property;_Offset;Offset;15;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;85.59033,400.2946;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;12;155.4956,58.98108;Float;False;True;2;Float;ASEMaterialInspector;0;1;SinVFX/ASE_Fresnel_New_FallOff;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;30;0;27;0
WireConnection;30;1;28;0
WireConnection;32;0;30;0
WireConnection;32;1;29;0
WireConnection;33;0;32;0
WireConnection;33;1;31;0
WireConnection;5;1;33;0
WireConnection;38;0;35;0
WireConnection;38;1;36;0
WireConnection;18;0;5;0
WireConnection;18;1;15;0
WireConnection;18;2;16;0
WireConnection;18;3;17;0
WireConnection;1;0;5;0
WireConnection;1;1;8;0
WireConnection;1;2;7;0
WireConnection;1;3;4;0
WireConnection;39;0;38;0
WireConnection;39;1;37;0
WireConnection;19;0;18;0
WireConnection;52;0;50;0
WireConnection;52;1;49;0
WireConnection;54;0;52;0
WireConnection;54;1;51;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;22;0;1;0
WireConnection;21;0;19;0
WireConnection;20;0;22;0
WireConnection;20;1;21;0
WireConnection;55;0;54;0
WireConnection;55;1;53;0
WireConnection;43;1;41;0
WireConnection;14;1;55;0
WireConnection;9;0;20;0
WireConnection;9;1;10;0
WireConnection;9;2;11;0
WireConnection;45;0;43;0
WireConnection;45;1;42;0
WireConnection;24;0;23;0
WireConnection;13;0;9;0
WireConnection;13;1;14;0
WireConnection;25;0;24;0
WireConnection;47;0;44;0
WireConnection;47;1;45;0
WireConnection;47;2;46;4
WireConnection;48;0;47;0
WireConnection;26;0;13;0
WireConnection;26;1;25;0
WireConnection;12;0;26;0
WireConnection;12;1;48;0
ASEEND*/
//CHKSM=52B00F2BDEDB3716B48466512581654C0D71890A