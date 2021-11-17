// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SinVFX/ASE_Fresnel_New_FallOff_DepthFadeRing"
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
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskU("MaskU", Float) = 0
		_MaskV("MaskV", Float) = 0
		_DepthFadeRingIndensity("DepthFadeRingIndensity", Float) = 1
		_DepthFadeIndensity("DepthFadeIndensity", Float) = 1
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
		Cull Off
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


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
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

			uniform sampler2D _NormalTex;
			uniform float _NormalU;
			uniform float _NormalV;
			uniform float4 _NormalTex_ST;
			uniform float _Bias1;
			uniform float _Scale1;
			uniform float _Power1;
			uniform float _Indensity;
			uniform float4 _Color;
			uniform sampler2D _MaskTex;
			uniform float _MaskU;
			uniform float _MaskV;
			uniform float4 _MaskTex_ST;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _DepthFadeRingIndensity;
			uniform float _DepthFadeIndensity;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

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
				vertexValue = vertexValue;
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
				float2 appendResult43 = (float2(_NormalU , _NormalV));
				float2 uv0_NormalTex = i.ase_texcoord1.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal1 = UnpackNormal( tex2D( _NormalTex, ( ( appendResult43 * _Time.y ) + uv0_NormalTex ) ) );
				float fresnelNdotV1 = dot( float3(dot(tanToWorld0,tanNormal1), dot(tanToWorld1,tanNormal1), dot(tanToWorld2,tanNormal1)), ase_worldViewDir );
				float fresnelNode1 = ( _Bias1 + _Scale1 * pow( 1.0 - fresnelNdotV1, _Power1 ) );
				float2 appendResult38 = (float2(_MaskU , _MaskV));
				float2 uv0_MaskTex = i.ase_texcoord1.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 screenPos = i.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth24 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth24 = abs( ( screenDepth24 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeRingIndensity ) );
				float clampResult25 = clamp( distanceDepth24 , 0.0 , 1.0 );
				float clampResult29 = clamp( ( 1.0 - clampResult25 ) , 0.0 , 1.0 );
				float screenDepth31 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth31 = abs( ( screenDepth31 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeIndensity ) );
				float clampResult32 = clamp( distanceDepth31 , 0.0 , 1.0 );
				
				
				finalColor = ( ( ( ( fresnelNode1 * _Indensity * _Color ) * tex2D( _MaskTex, ( ( appendResult38 * _Time.y ) + uv0_MaskTex ) ) ) * clampResult29 ) * clampResult32 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17000
0;64;1352;650;1412.124;21.07827;1.370405;True;False
Node;AmplifyShaderEditor.RangedFloatNode;48;-2817.797,-152.5907;Float;False;Property;_NormalU;NormalU;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2814.797,-75.59035;Float;False;Property;_NormalV;NormalV;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-2678.26,-27.18326;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-2643.797,-132.5907;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2597.359,43.11654;Float;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2480.797,-134.5907;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1470.723,816.2086;Float;False;Property;_MaskV;MaskV;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1473.723,739.2083;Float;False;Property;_MaskU;MaskU;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-2322.536,-138.1677;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;39;-1334.186,864.6157;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-1299.723,759.2083;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-405.0023,806.6126;Float;False;Property;_DepthFadeRingIndensity;DepthFadeRingIndensity;11;0;Create;True;0;0;False;0;1;2.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1136.723,757.2083;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-2108.767,-119.5766;Float;True;Property;_NormalTex;NormalTex;0;0;Create;True;0;0;False;0;9a4a55d8d2e54394d97426434477cdcf;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1842.482,175.3289;Float;False;Property;_Scale1;Scale1;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;24;-142.2173,793.2085;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1831.669,250.9248;Float;False;Property;_Power1;Power1;5;0;Create;True;0;0;False;0;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1830.418,104.2834;Float;False;Property;_Bias1;Bias1;6;0;Create;True;0;0;False;0;0;-0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1253.285,934.9155;Float;False;0;14;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;1;-1509.281,126.7317;Float;True;Standard;TangentNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-810.8347,377.6508;Float;False;Property;_Indensity;Indensity;4;0;Create;True;0;0;False;0;0;2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;25;120.2747,784.4182;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-749.4163,476.7579;Float;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-978.4623,753.6313;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-562.8062,170.0885;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-382.2099,1065.023;Float;False;Property;_DepthFadeIndensity;DepthFadeIndensity;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-796.7127,708.8973;Float;True;Property;_MaskTex;MaskTex;8;0;Create;True;0;0;False;0;None;c36309c849d51ec4ebca21ddd664e99e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;27;311.7427,808.7715;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;29;540.3878,620.8057;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;31;-80.85625,1046.359;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-272.5993,330.7618;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;686.0103,471.6559;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;32;181.6358,1037.569;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;923.3536,653.0569;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;12;1115.623,433.6888;Float;False;True;2;Float;ASEMaterialInspector;0;1;SinVFX/ASE_Fresnel_New_FallOff_DepthFadeRing;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;4;1;False;-1;1;False;-1;True;1;False;-1;1;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;43;0;48;0
WireConnection;43;1;49;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;40;0;38;0
WireConnection;40;1;39;0
WireConnection;5;1;46;0
WireConnection;24;0;23;0
WireConnection;1;0;5;0
WireConnection;1;1;8;0
WireConnection;1;2;7;0
WireConnection;1;3;4;0
WireConnection;25;0;24;0
WireConnection;42;0;40;0
WireConnection;42;1;41;0
WireConnection;9;0;1;0
WireConnection;9;1;10;0
WireConnection;9;2;11;0
WireConnection;14;1;42;0
WireConnection;27;0;25;0
WireConnection;29;0;27;0
WireConnection;31;0;34;0
WireConnection;13;0;9;0
WireConnection;13;1;14;0
WireConnection;26;0;13;0
WireConnection;26;1;29;0
WireConnection;32;0;31;0
WireConnection;35;0;26;0
WireConnection;35;1;32;0
WireConnection;12;0;35;0
ASEEND*/
//CHKSM=A4EAD9FFC49CA6341F3B0A96983E13874399BFFA