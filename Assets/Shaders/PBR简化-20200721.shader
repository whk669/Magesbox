// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SinCourse/PBR简化"
{
	Properties
	{
		[Toggle(_ALBEDOOFF_ON)] _AlbedoOFF("AlbedoOFF", Float) = 0
		[Toggle(_EMISSIONSWITCH_ON)] _EmissionSwitch("EmissionSwitch", Float) = 0
		_AO("AO", Float) = 1
		_Gloss("Gloss", Float) = 1
		_Metallic("Metallic", Float) = 1
		[HDR]_AllColor("AllColor", Color) = (1,1,1,1)
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexU("MainTexU", Float) = 0
		_MainTexV("MainTexV", Float) = 0
		_NormalTex("NormalTex", 2D) = "bump" {}
		_NormalTexU("NormalTexU", Float) = 0
		_NormalTexV("NormalTexV", Float) = 0
		_NormalIntensity("NormalIntensity", Float) = 1
		_SecTex("SecTex", 2D) = "white" {}
		_SecTexU("SecTexU", Float) = 0
		_SecTexV("SecTexV", Float) = 0
		_CubeMapTex("CubeMapTex", CUBE) = "white" {}
		_CubeMapIntensity("CubeMapIntensity", Float) = 0
		_OffsetTex("OffsetTex", 2D) = "white" {}
		_OffsetTexU("OffsetTexU", Float) = 0
		_OffsetTexV("OffsetTexV", Float) = 0
		_VertexOffsetIntensity("VertexOffsetIntensity", Float) = 0
		_OffsetMaskTex("OffsetMaskTex", 2D) = "white" {}
		_OffsetMaskTexU("OffsetMaskTexU", Float) = 0
		_OffsetMaskTexV("OffsetMaskTexV", Float) = 0
		[Toggle]_OpacityMaskTexSwitch("OpacityMaskTexSwitch", Float) = 1
		_OpacityMaskTex("OpacityMaskTex", 2D) = "white" {}
		_OpacityMaskTexU("OpacityMaskTexU", Float) = 0
		_OpacityMaskTexV("OpacityMaskTexV", Float) = 0
		[Toggle]_OffsetMaskTexFrequencyToOpacityMaskTex("OffsetMaskTexFrequencyToOpacityMaskTex", Float) = 0
		[Toggle]_DitherSwitch("DitherSwitch", Float) = 0
		_DitherBias("DitherBias", Float) = 0
		_MaskAddBias("MaskAddBias", Float) = 0
		_AlphaTex1("AlphaTex1", 2D) = "white" {}
		_AlphaTex1U("AlphaTex1U", Float) = 0
		_AlphaTex1V("AlphaTex1V", Float) = 0
		_DistortionTex("DistortionTex", 2D) = "white" {}
		_DistortionU("DistortionU", Float) = 0
		_DistortionV("DistortionV", Float) = 0
		_DistortionIntensity("DistortionIntensity", Float) = 0
		[Toggle]_Distortion2UV("Distortion2UV", Float) = 0
		[Toggle]_NormalTexDistortionUV("NormalTexDistortionUV", Float) = 0
		[Toggle]_SecTexDistortionUV("SecTexDistortionUV", Float) = 0
		[Toggle]_OffsetTexDistortionUV("OffsetTexDistortionUV", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _ALBEDOOFF_ON
		#pragma shader_feature _EMISSIONSWITCH_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			half3 worldRefl;
			INTERNAL_DATA
			float4 screenPosition;
		};

		uniform sampler2D _OffsetTex;
		uniform half _OffsetTexDistortionUV;
		uniform float4 _OffsetTex_ST;
		uniform float _OffsetTexU;
		uniform float _OffsetTexV;
		uniform sampler2D _DistortionTex;
		uniform half _Distortion2UV;
		uniform float4 _DistortionTex_ST;
		uniform float _DistortionU;
		uniform float _DistortionV;
		uniform float _DistortionIntensity;
		uniform sampler2D _OffsetMaskTex;
		uniform float4 _OffsetMaskTex_ST;
		uniform float _OffsetMaskTexU;
		uniform float _OffsetMaskTexV;
		uniform float _VertexOffsetIntensity;
		uniform sampler2D _NormalTex;
		uniform half _NormalTexDistortionUV;
		uniform float4 _NormalTex_ST;
		uniform float _NormalTexU;
		uniform float _NormalTexV;
		uniform float _NormalIntensity;
		uniform float _CubeMapIntensity;
		uniform samplerCUBE _CubeMapTex;
		uniform float4 _MainColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _MainTexU;
		uniform float _MainTexV;
		uniform float4 _AllColor;
		uniform sampler2D _SecTex;
		uniform half _SecTexDistortionUV;
		uniform float4 _SecTex_ST;
		uniform float _SecTexU;
		uniform float _SecTexV;
		uniform float _Metallic;
		uniform float _Gloss;
		uniform float _AO;
		uniform half _DitherSwitch;
		uniform float _MaskAddBias;
		uniform half _OpacityMaskTexSwitch;
		uniform sampler2D _OpacityMaskTex;
		uniform half _OffsetMaskTexFrequencyToOpacityMaskTex;
		uniform float4 _OpacityMaskTex_ST;
		uniform float _OpacityMaskTexU;
		uniform float _OpacityMaskTexV;
		uniform sampler2D _AlphaTex1;
		uniform float4 _AlphaTex1_ST;
		uniform float _AlphaTex1U;
		uniform float _AlphaTex1V;
		uniform float _DitherBias;
		uniform float _Cutoff = 0.5;


		inline float Dither4x4Bayer( int x, int y )
		{
			const float dither[ 16 ] = {
				 1,  9,  3, 11,
				13,  5, 15,  7,
				 4, 12,  2, 10,
				16,  8, 14,  6 };
			int r = y * 4 + x;
			return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv0_OffsetTex = v.texcoord.xy * _OffsetTex_ST.xy + _OffsetTex_ST.zw;
			half2 appendResult88 = (half2(( _OffsetTexU * _Time.y ) , ( _Time.y * _OffsetTexV )));
			half2 temp_output_96_0 = ( uv0_OffsetTex + appendResult88 );
			float2 uv0_DistortionTex = v.texcoord.xy * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
			float2 uv1_DistortionTex = v.texcoord1.xy * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
			half2 appendResult25 = (half2(_DistortionU , _DistortionV));
			half3 desaturateInitialColor32 = tex2Dlod( _DistortionTex, float4( ( (( _Distortion2UV )?( uv1_DistortionTex ):( uv0_DistortionTex )) + ( appendResult25 * _Time.y ) ), 0, 0.0) ).rgb;
			half desaturateDot32 = dot( desaturateInitialColor32, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar32 = lerp( desaturateInitialColor32, desaturateDot32.xxx, 1.0 );
			half3 DistortionUV34 = desaturateVar32;
			half DistortionIndeisty35 = _DistortionIntensity;
			half3 lerpResult103 = lerp( half3( temp_output_96_0 ,  0.0 ) , DistortionUV34 , DistortionIndeisty35);
			float2 uv0_OffsetMaskTex = v.texcoord.xy * _OffsetMaskTex_ST.xy + _OffsetMaskTex_ST.zw;
			half2 appendResult99 = (half2(( _OffsetMaskTexU * _Time.y ) , ( _Time.y * _OffsetMaskTexV )));
			half4 temp_output_116_0 = ( tex2Dlod( _OffsetTex, float4( (( _OffsetTexDistortionUV )?( lerpResult103 ):( half3( temp_output_96_0 ,  0.0 ) )).xy, 0, 0.0) ) * tex2Dlod( _OffsetMaskTex, float4( ( uv0_OffsetMaskTex + appendResult99 ), 0, 0.0) ) );
			half3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( temp_output_116_0 * half4( ase_vertexNormal , 0.0 ) * _VertexOffsetIntensity ).rgb;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			half2 appendResult66 = (half2(( _NormalTexU * _Time.y ) , ( _Time.y * _NormalTexV )));
			half2 temp_output_68_0 = ( uv0_NormalTex + appendResult66 );
			float2 uv0_DistortionTex = i.uv_texcoord * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
			float2 uv1_DistortionTex = i.uv2_texcoord2 * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
			half2 appendResult25 = (half2(_DistortionU , _DistortionV));
			half3 desaturateInitialColor32 = tex2D( _DistortionTex, ( (( _Distortion2UV )?( uv1_DistortionTex ):( uv0_DistortionTex )) + ( appendResult25 * _Time.y ) ) ).rgb;
			half desaturateDot32 = dot( desaturateInitialColor32, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar32 = lerp( desaturateInitialColor32, desaturateDot32.xxx, 1.0 );
			half3 DistortionUV34 = desaturateVar32;
			half DistortionIndeisty35 = _DistortionIntensity;
			half3 lerpResult71 = lerp( half3( temp_output_68_0 ,  0.0 ) , DistortionUV34 , DistortionIndeisty35);
			half3 tex2DNode74 = UnpackScaleNormal( tex2D( _NormalTex, (( _NormalTexDistortionUV )?( lerpResult71 ):( half3( temp_output_68_0 ,  0.0 ) )).xy ), _NormalIntensity );
			o.Normal = tex2DNode74;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half2 appendResult55 = (half2(( _MainTexU * _Time.y ) , ( _Time.y * _MainTexV )));
			half4 temp_output_48_0 = ( ( ( _CubeMapIntensity * texCUBE( _CubeMapTex, normalize( WorldReflectionVector( i , tex2DNode74 ) ) ) ) + ( _MainColor * tex2D( _MainTex, ( uv0_MainTex + appendResult55 ) ) ) ) * _AllColor );
			#ifdef _ALBEDOOFF_ON
				float4 staticSwitch59 = float4( 0,0,0,0 );
			#else
				float4 staticSwitch59 = temp_output_48_0;
			#endif
			o.Albedo = staticSwitch59.rgb;
			#ifdef _EMISSIONSWITCH_ON
				float4 staticSwitch58 = temp_output_48_0;
			#else
				float4 staticSwitch58 = float4( 0,0,0,0 );
			#endif
			o.Emission = staticSwitch58.rgb;
			float2 uv0_SecTex = i.uv_texcoord * _SecTex_ST.xy + _SecTex_ST.zw;
			half2 appendResult18 = (half2(( _SecTexU * _Time.y ) , ( _Time.y * _SecTexV )));
			half2 temp_output_19_0 = ( uv0_SecTex + appendResult18 );
			half3 lerpResult143 = lerp( half3( temp_output_19_0 ,  0.0 ) , DistortionUV34 , DistortionIndeisty35);
			half4 tex2DNode4 = tex2D( _SecTex, (( _SecTexDistortionUV )?( lerpResult143 ):( half3( temp_output_19_0 ,  0.0 ) )).xy );
			half3 temp_cast_9 = (( tex2DNode4.b * _Metallic )).xxx;
			o.Specular = temp_cast_9;
			o.Smoothness = ( tex2DNode4.g * _Gloss );
			o.Occlusion = ( tex2DNode4.r * _AO );
			o.Alpha = 1;
			float2 uv0_OffsetTex = i.uv_texcoord * _OffsetTex_ST.xy + _OffsetTex_ST.zw;
			half2 appendResult88 = (half2(( _OffsetTexU * _Time.y ) , ( _Time.y * _OffsetTexV )));
			half2 temp_output_96_0 = ( uv0_OffsetTex + appendResult88 );
			half3 lerpResult103 = lerp( half3( temp_output_96_0 ,  0.0 ) , DistortionUV34 , DistortionIndeisty35);
			float2 uv0_OffsetMaskTex = i.uv_texcoord * _OffsetMaskTex_ST.xy + _OffsetMaskTex_ST.zw;
			half2 appendResult99 = (half2(( _OffsetMaskTexU * _Time.y ) , ( _Time.y * _OffsetMaskTexV )));
			half4 temp_output_116_0 = ( tex2D( _OffsetTex, (( _OffsetTexDistortionUV )?( lerpResult103 ):( half3( temp_output_96_0 ,  0.0 ) )).xy ) * tex2D( _OffsetMaskTex, ( uv0_OffsetMaskTex + appendResult99 ) ) );
			half3 desaturateInitialColor136 = temp_output_116_0.rgb;
			half desaturateDot136 = dot( desaturateInitialColor136, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar136 = lerp( desaturateInitialColor136, desaturateDot136.xxx, 1.0 );
			float2 uv0_OpacityMaskTex = i.uv_texcoord * _OpacityMaskTex_ST.xy + _OpacityMaskTex_ST.zw;
			half2 appendResult100 = (half2(( _OpacityMaskTexU * _Time.y ) , ( _Time.y * _OpacityMaskTexV )));
			half3 desaturateInitialColor118 = tex2D( _OpacityMaskTex, (( _OffsetMaskTexFrequencyToOpacityMaskTex )?( ( appendResult99 + uv0_OpacityMaskTex ) ):( ( uv0_OpacityMaskTex + appendResult100 ) )) ).rgb;
			half desaturateDot118 = dot( desaturateInitialColor118, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar118 = lerp( desaturateInitialColor118, desaturateDot118.xxx, 1.0 );
			float2 uv0_AlphaTex1 = i.uv_texcoord * _AlphaTex1_ST.xy + _AlphaTex1_ST.zw;
			half2 appendResult113 = (half2(( _AlphaTex1U * _Time.y ) , ( _Time.y * _AlphaTex1V )));
			half3 desaturateInitialColor120 = tex2D( _AlphaTex1, ( uv0_AlphaTex1 + appendResult113 ) ).rgb;
			half desaturateDot120 = dot( desaturateInitialColor120, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar120 = lerp( desaturateInitialColor120, desaturateDot120.xxx, 1.0 );
			half clampResult141 = clamp( ( _MaskAddBias + ( (( _OpacityMaskTexSwitch )?( (desaturateVar118).x ):( (desaturateVar136).x )) * (desaturateVar120).x ) ) , 0.0 , 1.0 );
			half temp_output_128_0 = (0.0 + (clampResult141 - 0.0) * (2.0 - 0.0) / (1.0 - 0.0));
			float4 ase_screenPos = i.screenPosition;
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half2 clipScreen131 = ase_screenPosNorm.xy * _ScreenParams.xy;
			half dither131 = Dither4x4Bayer( fmod(clipScreen131.x, 4), fmod(clipScreen131.y, 4) );
			dither131 = step( dither131, ( temp_output_128_0 + _DitherBias ) );
			clip( (( _DitherSwitch )?( dither131 ):( temp_output_128_0 )) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.customPack2.xyzw = customInputData.screenPosition;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				surfIN.screenPosition = IN.customPack2.xyzw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18300
1920;0;1920;1029;4089.07;1958.182;2.144257;True;False
Node;AmplifyShaderEditor.CommentaryNode;20;-5817.467,-1463.062;Inherit;False;1207;533.7722;UV扭曲贴图;11;32;31;30;29;27;26;25;24;23;22;159;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-5746.467,-1166.062;Float;False;Property;_DistortionU;DistortionU;38;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-5746.467,-1086.062;Float;False;Property;_DistortionV;DistortionV;39;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-5764.631,-1295.391;Inherit;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-5767.467,-1413.062;Inherit;False;1;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;26;-5596.001,-1039.957;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-5570.467,-1150.062;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;159;-5506.039,-1352.018;Half;False;Property;_Distortion2UV;Distortion2UV;41;0;Create;True;0;0;False;0;False;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-5410.467,-1150.062;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;75;-3416.452,-438.9502;Inherit;False;695.9;444.1667;贴图流动;8;96;88;85;82;79;78;77;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-5258.467,-1207.062;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-5106.468,-1246.062;Inherit;True;Property;_DistortionTex;DistortionTex;37;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-4923.149,-1641.517;Inherit;False;312.6667;165.6667;UV扭曲强度;1;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-3338.454,-110.4501;Float;False;Property;_OffsetTexV;OffsetTexV;21;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-3341.454,-262.4501;Float;False;Property;_OffsetTexU;OffsetTexU;20;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;76;-3366.454,-178.4501;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-3177.452,-259.4501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-3176.452,-161.4501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;80;-3450.488,16.89719;Inherit;False;730.9009;442.1664;贴图流动;8;110;102;99;92;91;89;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-4873.149,-1592.574;Float;False;Property;_DistortionIntensity;DistortionIntensity;40;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-3453.267,475.143;Inherit;False;730.9009;442.1664;贴图流动;8;109;101;100;98;94;90;84;83;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;32;-4818.466,-1239.062;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;-3365.488,277.396;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-3397.488,343.3958;Float;False;Property;_OffsetMaskTexV;OffsetMaskTexV;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-3403.267,649.6441;Float;False;Property;_OpacityMaskTexU;OpacityMaskTexU;28;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-3400.267,801.6432;Float;False;Property;_OpacityMaskTexV;OpacityMaskTexV;29;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-3269.352,-388.9502;Inherit;False;0;112;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;88;-3016.153,-227.5502;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-3400.488,191.397;Float;False;Property;_OffsetMaskTexU;OffsetMaskTexU;24;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-4587.308,-1589.817;Half;False;DistortionIndeisty;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-4568.35,-1245.851;Half;False;DistortionUV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;90;-3368.267,735.6431;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-2876.553,-275.2502;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-2703.314,-19.29763;Inherit;False;35;DistortionIndeisty;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3179.267,654.6441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-3178.267,752.6431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-3175.488,294.396;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-3447.309,932.4252;Inherit;False;730.9009;442.1664;贴图流动;8;115;114;113;111;107;106;105;104;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-2677.76,-91.45352;Inherit;False;34;DistortionUV;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-3176.488,196.397;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-3271.168,525.143;Inherit;False;0;138;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;103;-2487.326,-142.3384;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-3394.309,1258.928;Float;False;Property;_AlphaTex1V;AlphaTex1V;36;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-3397.309,1106.925;Float;False;Property;_AlphaTex1U;AlphaTex1U;35;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;99;-3015.187,228.296;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-3268.387,66.89719;Inherit;False;0;133;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;104;-3362.309,1192.928;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;100;-3017.968,686.5432;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-2602.688,453.096;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-3173.309,1111.926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-3172.309,1209.928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;153;-2337.742,-198.9007;Half;False;Property;_OffsetTexDistortionUV;OffsetTexDistortionUV;44;0;Create;True;0;0;False;0;False;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-2878.367,638.8441;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-2875.588,180.5972;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;114;-3265.21,982.4254;Inherit;False;0;117;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;112;-2102.668,-228.976;Inherit;True;Property;_OffsetTex;OffsetTex;19;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;133;-2646.929,157.9551;Inherit;True;Property;_OffsetMaskTex;OffsetMaskTex;23;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;147;-2452.781,481.9211;Half;False;Property;_OffsetMaskTexFrequencyToOpacityMaskTex;OffsetMaskTexFrequencyToOpacityMaskTex;30;0;Create;True;0;0;False;0;False;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-3012.01,1143.826;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-1796.689,-101.6032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-2877.61,992.1243;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;60;-3623.824,-1978.076;Inherit;False;695.9;444.1667;贴图流动;8;68;67;66;65;64;63;62;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;138;-2150.536,458.7066;Inherit;True;Property;_OpacityMaskTex;OpacityMaskTex;27;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-3548.824,-1801.576;Float;False;Property;_NormalTexU;NormalTexU;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-3545.824,-1649.576;Float;False;Property;_NormalTexV;NormalTexV;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;118;-1837.224,463.7951;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DesaturateOpNode;136;-1587.279,2.204672;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;62;-3573.824,-1717.575;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;-2656.558,959.2703;Inherit;True;Property;_AlphaTex1;AlphaTex1;34;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;119;-1663.35,462.3652;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;120;-2365.469,962.8633;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-3383.824,-1700.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;135;-1389.267,31.81093;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-3384.824,-1798.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;122;-2194.594,957.4332;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-3476.724,-1928.076;Inherit;False;0;74;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;66;-3223.525,-1766.676;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;152;-1132.488,273.386;Half;False;Property;_OpacityMaskTexSwitch;OpacityMaskTexSwitch;26;0;Create;True;0;0;False;0;False;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;121;-703.012,201.6739;Inherit;False;718.0901;261.9537;Mask阈值加强;4;141;140;139;128;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-3124.368,-1453.094;Inherit;False;35;DistortionIndeisty;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2449.72,-1428.517;Inherit;False;695.9;444.1667;贴图流动;8;57;56;55;54;53;52;51;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-852.4344,280.8999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-3083.924,-1814.376;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-3097.819,-1525.082;Inherit;False;34;DistortionUV;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-653.0117,251.6738;Float;False;Property;_MaskAddBias;MaskAddBias;33;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-2862.031,-1605.153;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2376.048,-1253.346;Float;False;Property;_MainTexU;MainTexU;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;11;-3515.446,-912.4743;Inherit;False;695.9;444.1667;贴图流动;8;19;18;17;16;15;14;13;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;-463.5852,256.8763;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;52;-2399.72,-1168.016;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2371.72,-1100.016;Float;False;Property;_MainTexV;MainTexV;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3437.446,-583.9744;Float;False;Property;_SecTexV;SecTexV;16;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-3465.446,-651.9742;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;141;-346.4585,257.6785;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2210.719,-1249.017;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;125;67.79946,348.8331;Inherit;False;579.7141;189.3333;抖动控制;3;131;130;129;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;149;-2684.168,-1695.298;Half;False;Property;_NormalTexDistortionUV;NormalTexDistortionUV;42;0;Create;True;0;0;False;0;False;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3440.446,-735.9744;Float;False;Property;_SecTexU;SecTexU;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2599.608,-1570.444;Float;False;Property;_NormalIntensity;NormalIntensity;13;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-2209.719,-1151.016;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-2401.038,-1699.411;Inherit;True;Property;_NormalTex;NormalTex;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3276.446,-732.9744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3275.446,-634.9744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;80.09978,423.9059;Float;False;Property;_DitherBias;DitherBias;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;128;-200.9225,258.2939;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1977.835,-1918.262;Inherit;False;692.9723;355.0887;CubeMap;4;43;42;41;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-2302.62,-1378.517;Inherit;False;0;39;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;55;-2049.419,-1217.117;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldReflectionVector;37;-1939.018,-1759.825;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-1909.818,-1264.817;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;267.6003,402.4529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1735.056,-1560.01;Inherit;False;455.9125;260.3333;贴图颜色叠加;2;44;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-3115.146,-701.0745;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-3368.345,-862.4743;Inherit;False;0;4;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;154;-2788.969,-909.1312;Inherit;False;1048.899;490.2294;Comment;5;143;148;144;145;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-2738.969,-534.9019;Inherit;False;35;DistortionIndeisty;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-2975.547,-748.7744;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-2705.139,-604.0247;Inherit;False;34;DistortionUV;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;40;-1685.056,-1510.01;Float;False;Property;_MainColor;MainColor;6;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DitheringNode;131;404.1789,385.5333;Inherit;False;0;False;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-1738.777,-1793.174;Inherit;True;Property;_CubeMapTex;CubeMapTex;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-1670.531,-1869.262;Float;False;Property;_CubeMapIntensity;CubeMapIntensity;18;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-1741.342,-1290.156;Inherit;True;Property;_MainTex;MainTex;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1454.477,-1503.712;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1453.863,-1859.14;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;155;-1705.542,-1087.37;Inherit;False;514.3335;694.1713;Comment;3;3;2;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;143;-2514.705,-638.9096;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1087.871,-1700.57;Inherit;False;474.3093;260.3334;总颜色叠加;2;48;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;151;670.4992,235.1905;Half;False;Property;_DitherSwitch;DitherSwitch;31;0;Create;True;0;0;False;0;False;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-1655.542,-804.1986;Inherit;False;414.3335;210.6666;粗糙度;2;8;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;158;813.9567,-0.8956838;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2;-1653.9,-1037.37;Inherit;False;409.3331;225.6667;AO;2;9;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;148;-2311.582,-836.7287;Half;False;Property;_SecTexDistortionUV;SecTexDistortionUV;43;0;Create;True;0;0;False;0;False;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;3;-1654.542,-586.1987;Inherit;False;413.3335;192.6667;金属度;2;10;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-1232.519,-1661.256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;-1037.871,-1650.57;Float;False;Property;_AllColor;AllColor;5;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;157;-324.4893,-410.4491;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1603.9,-927.3701;Float;False;Property;_AO;AO;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;142;-1564.578,-226.7854;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1605.542,-709.1987;Float;False;Property;_Gloss;Gloss;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1604.542,-509.1987;Float;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1598.951,-88.06525;Float;False;Property;_VertexOffsetIntensity;VertexOffsetIntensity;22;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-788.8943,-1644.485;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-2060.071,-859.1312;Inherit;True;Property;_SecTex;SecTex;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1357.056,-275.9584;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1416.542,-754.1987;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;58;-575.2932,-1561.087;Float;False;Property;_EmissionSwitch;EmissionSwitch;1;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;59;-577.5464,-1654.643;Float;False;Property;_AlbedoOFF;AlbedoOFF;0;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;156;-456.1555,-859.1178;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1419.901,-987.3699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1416.542,-536.1987;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-163.5847,-1443.218;Half;False;True;-1;6;ASEMaterialInspector;0;0;StandardSpecular;SinCourse/PBR简化;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;45;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;22;0
WireConnection;25;1;23;0
WireConnection;159;0;27;0
WireConnection;159;1;24;0
WireConnection;29;0;25;0
WireConnection;29;1;26;0
WireConnection;30;0;159;0
WireConnection;30;1;29;0
WireConnection;31;1;30;0
WireConnection;82;0;77;0
WireConnection;82;1;76;0
WireConnection;79;0;76;0
WireConnection;79;1;78;0
WireConnection;32;0;31;0
WireConnection;88;0;82;0
WireConnection;88;1;79;0
WireConnection;35;0;33;0
WireConnection;34;0;32;0
WireConnection;96;0;85;0
WireConnection;96;1;88;0
WireConnection;98;0;84;0
WireConnection;98;1;90;0
WireConnection;94;0;90;0
WireConnection;94;1;83;0
WireConnection;91;0;86;0
WireConnection;91;1;89;0
WireConnection;92;0;87;0
WireConnection;92;1;86;0
WireConnection;103;0;96;0
WireConnection;103;1;95;0
WireConnection;103;2;93;0
WireConnection;99;0;92;0
WireConnection;99;1;91;0
WireConnection;100;0;98;0
WireConnection;100;1;94;0
WireConnection;134;0;99;0
WireConnection;134;1;101;0
WireConnection;107;0;105;0
WireConnection;107;1;104;0
WireConnection;111;0;104;0
WireConnection;111;1;106;0
WireConnection;153;0;96;0
WireConnection;153;1;103;0
WireConnection;109;0;101;0
WireConnection;109;1;100;0
WireConnection;110;0;102;0
WireConnection;110;1;99;0
WireConnection;112;1;153;0
WireConnection;133;1;110;0
WireConnection;147;0;109;0
WireConnection;147;1;134;0
WireConnection;113;0;107;0
WireConnection;113;1;111;0
WireConnection;116;0;112;0
WireConnection;116;1;133;0
WireConnection;115;0;114;0
WireConnection;115;1;113;0
WireConnection;138;1;147;0
WireConnection;118;0;138;0
WireConnection;136;0;116;0
WireConnection;117;1;115;0
WireConnection;119;0;118;0
WireConnection;120;0;117;0
WireConnection;64;0;62;0
WireConnection;64;1;61;0
WireConnection;135;0;136;0
WireConnection;65;0;63;0
WireConnection;65;1;62;0
WireConnection;122;0;120;0
WireConnection;66;0;65;0
WireConnection;66;1;64;0
WireConnection;152;0;135;0
WireConnection;152;1;119;0
WireConnection;124;0;152;0
WireConnection;124;1;122;0
WireConnection;68;0;67;0
WireConnection;68;1;66;0
WireConnection;71;0;68;0
WireConnection;71;1;70;0
WireConnection;71;2;69;0
WireConnection;140;0;139;0
WireConnection;140;1;124;0
WireConnection;141;0;140;0
WireConnection;54;0;51;0
WireConnection;54;1;52;0
WireConnection;149;0;68;0
WireConnection;149;1;71;0
WireConnection;53;0;52;0
WireConnection;53;1;50;0
WireConnection;74;1;149;0
WireConnection;74;5;73;0
WireConnection;15;0;12;0
WireConnection;15;1;14;0
WireConnection;16;0;14;0
WireConnection;16;1;13;0
WireConnection;128;0;141;0
WireConnection;55;0;54;0
WireConnection;55;1;53;0
WireConnection;37;0;74;0
WireConnection;57;0;56;0
WireConnection;57;1;55;0
WireConnection;130;0;128;0
WireConnection;130;1;129;0
WireConnection;18;0;15;0
WireConnection;18;1;16;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;131;0;130;0
WireConnection;42;1;37;0
WireConnection;39;1;57;0
WireConnection;44;0;40;0
WireConnection;44;1;39;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;143;0;19;0
WireConnection;143;1;144;0
WireConnection;143;2;145;0
WireConnection;151;0;128;0
WireConnection;151;1;131;0
WireConnection;158;0;151;0
WireConnection;148;0;19;0
WireConnection;148;1;143;0
WireConnection;47;0;43;0
WireConnection;47;1;44;0
WireConnection;157;0;158;0
WireConnection;48;0;47;0
WireConnection;48;1;46;0
WireConnection;4;1;148;0
WireConnection;127;0;116;0
WireConnection;127;1;142;0
WireConnection;127;2;126;0
WireConnection;8;0;4;2
WireConnection;8;1;6;0
WireConnection;58;0;48;0
WireConnection;59;1;48;0
WireConnection;156;0;157;0
WireConnection;9;0;4;1
WireConnection;9;1;5;0
WireConnection;10;0;4;3
WireConnection;10;1;7;0
WireConnection;0;0;59;0
WireConnection;0;1;74;0
WireConnection;0;2;58;0
WireConnection;0;3;10;0
WireConnection;0;4;8;0
WireConnection;0;5;9;0
WireConnection;0;10;156;0
WireConnection;0;11;127;0
ASEEND*/
//CHKSM=7B0FA806912A10264E295EFCC56FBAF7D0613E46