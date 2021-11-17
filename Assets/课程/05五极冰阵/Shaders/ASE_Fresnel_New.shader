// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SinVFX/ASE_Fresnel_New"
{
	Properties
	{
		[Normal]_NormalTex("NormalTex", 2D) = "bump" {}
		_NormalU("NormalU", Float) = 0
		_NormalV("NormalV", Float) = 0
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_Indensity("Indensity", Float) = 0
		_Power("Power", Float) = 5
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_MaskTex("MaskTex", 2D) = "white" {}
		[Toggle(_OFFSET_ON)] _Offset("Offset", Float) = 0
		_OffsetTex("OffsetTex", 2D) = "white" {}
		_OffsetU("OffsetU", Float) = 0
		_OffsetV("OffsetV", Float) = 0
		_OffsetIntensity("OffsetIntensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			};

			uniform float _OffsetIntensity;
			uniform sampler2D _OffsetTex;
			uniform float _OffsetU;
			uniform float _OffsetV;
			uniform sampler2D _NormalTex;
			uniform float _NormalU;
			uniform float _NormalV;
			uniform float4 _NormalTex_ST;
			uniform float _Bias;
			uniform float _Scale;
			uniform float _Power;
			uniform float _Indensity;
			uniform float4 _Color;
			uniform sampler2D _MaskTex;
			uniform float4 _MaskTex_ST;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 appendResult25 = (float2(_OffsetU , _OffsetV));
				float2 uv027 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				#ifdef _OFFSET_ON
				float4 staticSwitch41 = ( _OffsetIntensity * ( tex2Dlod( _OffsetTex, float4( ( ( appendResult25 * _Time.y ) + uv027 ), 0, 0.0) ) * float4( v.ase_normal , 0.0 ) ) * v.color.a );
				#else
				float4 staticSwitch41 = float4( 0,0,0,0 );
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
				vertexValue = staticSwitch41.rgb;
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
				float2 appendResult18 = (float2(_NormalU , _NormalV));
				float2 uv0_NormalTex = i.ase_texcoord1.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;
				float3 tex2DNode5 = UnpackNormal( tex2D( _NormalTex, ( ( appendResult18 * _Time.y ) + uv0_NormalTex ) ) );
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal1 = tex2DNode5;
				float fresnelNdotV1 = dot( float3(dot(tanToWorld0,tanNormal1), dot(tanToWorld1,tanNormal1), dot(tanToWorld2,tanNormal1)), ase_worldViewDir );
				float fresnelNode1 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV1, _Power ) );
				float2 uv_MaskTex = i.ase_texcoord1.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				
				
				finalColor = ( ( fresnelNode1 * _Indensity * _Color ) * tex2D( _MaskTex, uv_MaskTex ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17000
1920;0;1920;1029;2941.393;1076.403;2.055778;True;False
Node;AmplifyShaderEditor.CommentaryNode;22;-1421.253,1046.117;Float;False;1859.316;500.0784;顶点偏移;14;41;40;39;38;37;36;35;31;28;27;26;25;24;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2335.403,-46.14293;Float;False;Property;_NormalV;NormalV;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1371.253,1214.16;Float;False;Property;_OffsetU;OffsetU;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1368.254,1291.159;Float;False;Property;_OffsetV;OffsetV;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2338.403,-123.1433;Float;False;Property;_NormalU;NormalU;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2164.402,-103.1433;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1156.135,1209.634;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;26;-1158.599,1302.24;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-2198.865,2.264147;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1159.898,1373.74;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-993.1355,1207.634;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2001.402,-105.1433;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2117.964,72.56394;Float;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-856.3687,1208.214;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1843.141,-108.7203;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;35;-514.8025,1174.736;Float;True;Property;_OffsetTex;OffsetTex;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1403.907,268.4557;Float;False;Property;_Power;Power;5;0;Create;True;0;0;False;0;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1414.72,192.86;Float;False;Property;_Scale;Scale;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1402.656,121.8146;Float;False;Property;_Bias;Bias;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;36;-409.7385,1367.195;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1681.004,-102.0454;Float;True;Property;_NormalTex;NormalTex;0;1;[Normal];Create;True;0;0;False;0;9a4a55d8d2e54394d97426434477cdcf;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-306.2566,1096.117;Float;False;Property;_OffsetIntensity;OffsetIntensity;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-977.3813,393.4288;Float;False;Property;_Indensity;Indensity;4;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-915.9628,492.5359;Float;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.4481132,0.5499925,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-202.8506,1179.236;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;38;-191.2756,1326.133;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;1;-1081.519,144.2628;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-562.8062,170.0885;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;14;-796.7127,708.8973;Float;True;Property;_MaskTex;MaskTex;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2.673584,1148.53;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;41;137.0635,1119.37;Float;False;Property;_Offset;Offset;9;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;42;-1269.686,-66.48499;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-272.5993,330.7618;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;12;155.4956,58.98108;Float;False;True;2;Float;ASEMaterialInspector;0;1;SinVFX/ASE_Fresnel_New;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;18;0;15;0
WireConnection;18;1;16;0
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;31;0;28;0
WireConnection;31;1;27;0
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;35;1;31;0
WireConnection;5;1;21;0
WireConnection;37;0;35;0
WireConnection;37;1;36;0
WireConnection;1;0;5;0
WireConnection;1;1;8;0
WireConnection;1;2;7;0
WireConnection;1;3;4;0
WireConnection;9;0;1;0
WireConnection;9;1;10;0
WireConnection;9;2;11;0
WireConnection;40;0;39;0
WireConnection;40;1;37;0
WireConnection;40;2;38;4
WireConnection;41;0;40;0
WireConnection;42;0;5;0
WireConnection;13;0;9;0
WireConnection;13;1;14;0
WireConnection;12;0;13;0
WireConnection;12;1;41;0
ASEEND*/
//CHKSM=BF01EFE6C90B35EE61EF65BB9C64732FC55B3E7F