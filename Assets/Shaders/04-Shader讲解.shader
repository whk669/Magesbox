// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shader讲解"
{
	Properties
	{
		_GradientTex("GradientTex", 2D) = "white" {}
		_GradientTexU("GradientTexU", Float) = 0
		_GradientTexV("GradientTexV", Float) = 0
		[Toggle(_DISTORTIONTOGRADIENT_ON)] _DistortionToGradient("DistortionToGradient", Float) = 0
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_DepthFade("DepthFade", Float) = 0
		_Intensity("Intensity", Float) = 1
		_IntensityPower("IntensityPower", Float) = 1
		_Opacity("Opacity", Float) = 1
		_OpacityPower("OpacityPower", Float) = 1
		_DistortionTex("DistortionTex", 2D) = "white" {}
		[Toggle(_DISTORTIONTEX_2UV_ON)] _DistortionTex_2UV("DistortionTex_2UV", Float) = 0
		_DistortionTexU("DistortionTexU", Float) = 0
		_DistortionTexV("DistortionTexV", Float) = 0
		_DistortionIntensity("DistortionIntensity", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexU("MainTexU", Float) = 0
		_MainTexV("MainTexV", Float) = 0
		_AlphaTex("AlphaTex", 2D) = "white" {}
		[Toggle(_ALPHATEX_2UV_ON)] _AlphaTex_2UV("AlphaTex_2UV", Float) = 0
		_AlphaTexU("AlphaTexU", Float) = 0
		_AlphaTexV("AlphaTexV", Float) = 0
		[Toggle(_DISSOLVE_ON)] _Dissolve("Dissolve", Float) = 0
		_SoftDissolve("SoftDissolve", 2D) = "white" {}
		[Toggle(_DISTORTIONTOSOFTDISSOLVE_ON)] _DistortionToSoftDissolve("DistortionToSoftDissolve", Float) = 0
		_SoftDissolveU("SoftDissolveU", Float) = 0
		_SoftDissolveV("SoftDissolveV", Float) = 0
		_DissolveIntensity("DissolveIntensity", Range( 0 , 1.05)) = 0.5
		_DissolveSoft("DissolveSoft", Float) = 0.5
		_SoftDissolvePlusValue("SoftDissolvePlusValue", Float) = 0
		[Toggle(_VERTEXCOLORTODISSOLVE_ON)] _VertexColorToDissolve("VertexColorToDissolve", Float) = 0
		[Toggle(_CUSTOMDATATODISSOLVE_ON)] _CustomDataToDissolve("CustomDataToDissolve", Float) = 0
		_CustomDataIntensity("CustomDataIntensity", Float) = 1
		_LineWidth("LineWidth", Float) = 0
		_LineRange("LineRange", Float) = 0
		_AlphaTex2("AlphaTex2", 2D) = "white" {}
		_AlphaTex2U("AlphaTex2U", Float) = 0
		_AlphaTex2V("AlphaTex2V", Float) = 0
		_AlphaTex3("AlphaTex3", 2D) = "white" {}
		_AlphaTex3U("AlphaTex3U", Float) = 0
		_AlphaTex3V("AlphaTex3V", Float) = 0
		_AlphaTex4("AlphaTex4", 2D) = "white" {}
		_AlphaTex4U("AlphaTex4U", Float) = 0
		_AlphaTex4V("AlphaTex4V", Float) = 0
		_AlphaTex5("AlphaTex5", 2D) = "white" {}
		_AlphaTex5U("AlphaTex5U", Float) = 0
		_AlphaTex5V("AlphaTex5V", Float) = 0
		_OffsetTex("OffsetTex", 2D) = "white" {}
		_OffsetTexU("OffsetTexU", Float) = 0
		_OffsetTexV("OffsetTexV", Float) = 0
		_OffsetIntensity("OffsetIntensity", Float) = 0
		[Toggle(_DISTORTIONTOOFFSET_ON)] _DistortionToOffset("DistortionToOffset", Float) = 0
		[HDR]_LineColor("LineColor", Color) = (1,1,1,1)
		_LineIntensity("LineIntensity", Float) = 1
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _DISTORTIONTOOFFSET_ON
		#pragma shader_feature_local _DISTORTIONTEX_2UV_ON
		#pragma shader_feature_local _DISTORTIONTOSOFTDISSOLVE_ON
		#pragma shader_feature_local _VERTEXCOLORTODISSOLVE_ON
		#pragma shader_feature_local _CUSTOMDATATODISSOLVE_ON
		#pragma shader_feature_local _DISTORTIONTOGRADIENT_ON
		#pragma shader_feature_local _DISSOLVE_ON
		#pragma shader_feature_local _ALPHATEX_2UV_ON
		#pragma surface surf Lambert keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 uv_tex4coord;
			float2 uv2_texcoord2;
			float4 screenPos;
		};

		uniform sampler2D _OffsetTex;
		uniform float4 _OffsetTex_ST;
		uniform half _OffsetTexU;
		uniform half _OffsetTexV;
		uniform sampler2D _DistortionTex;
		uniform float4 _DistortionTex_ST;
		uniform half _DistortionTexU;
		uniform half _DistortionTexV;
		uniform half _DistortionIntensity;
		uniform half _OffsetIntensity;
		uniform half _DissolveSoft;
		uniform sampler2D _SoftDissolve;
		uniform float4 _SoftDissolve_ST;
		uniform half _SoftDissolveU;
		uniform half _SoftDissolveV;
		uniform half _SoftDissolvePlusValue;
		uniform half _CustomDataIntensity;
		uniform half _DissolveIntensity;
		uniform half _LineRange;
		uniform half _LineWidth;
		uniform half4 _LineColor;
		uniform half _LineIntensity;
		uniform sampler2D _GradientTex;
		uniform float4 _GradientTex_ST;
		uniform half _GradientTexU;
		uniform half _GradientTexV;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform half _MainTexU;
		uniform half _MainTexV;
		uniform half4 _Color;
		uniform half _IntensityPower;
		uniform half _Intensity;
		uniform sampler2D _AlphaTex;
		uniform float4 _AlphaTex_ST;
		uniform half _AlphaTexU;
		uniform half _AlphaTexV;
		uniform sampler2D _AlphaTex2;
		uniform float4 _AlphaTex2_ST;
		uniform half _AlphaTex2U;
		uniform half _AlphaTex2V;
		uniform sampler2D _AlphaTex3;
		uniform float4 _AlphaTex3_ST;
		uniform half _AlphaTex3U;
		uniform half _AlphaTex3V;
		uniform sampler2D _AlphaTex4;
		uniform float4 _AlphaTex4_ST;
		uniform half _AlphaTex4U;
		uniform half _AlphaTex4V;
		uniform sampler2D _AlphaTex5;
		uniform float4 _AlphaTex5_ST;
		uniform half _AlphaTex5U;
		uniform half _AlphaTex5V;
		uniform half _OpacityPower;
		uniform half _Opacity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _DepthFade;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv0_OffsetTex = v.texcoord.xy * _OffsetTex_ST.xy + _OffsetTex_ST.zw;
			half2 appendResult168 = (half2(_OffsetTexU , _OffsetTexV));
			half2 temp_output_172_0 = ( uv0_OffsetTex + ( appendResult168 * _Time.y ) );
			float2 uv0_DistortionTex = v.texcoord.xy * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
			#ifdef _DISTORTIONTEX_2UV_ON
				half2 staticSwitch117 = uv0_DistortionTex;
			#else
				half2 staticSwitch117 = uv0_DistortionTex;
			#endif
			half2 appendResult112 = (half2(_DistortionTexU , _DistortionTexV));
			half3 desaturateInitialColor106 = tex2Dlod( _DistortionTex, float4( ( staticSwitch117 + ( appendResult112 * _Time.y ) ), 0, 0.0) ).rgb;
			half desaturateDot106 = dot( desaturateInitialColor106, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar106 = lerp( desaturateInitialColor106, desaturateDot106.xxx, 1.0 );
			half3 Distortion139 = desaturateVar106;
			half DistortionIntensity140 = _DistortionIntensity;
			half3 lerpResult176 = lerp( half3( temp_output_172_0 ,  0.0 ) , Distortion139 , DistortionIntensity140);
			#ifdef _DISTORTIONTOOFFSET_ON
				half3 staticSwitch177 = lerpResult176;
			#else
				half3 staticSwitch177 = half3( temp_output_172_0 ,  0.0 );
			#endif
			half3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( tex2Dlod( _OffsetTex, float4( staticSwitch177.xy, 0, 0.0) ) * half4( ase_vertexNormal , 0.0 ) * _OffsetIntensity * v.color.a ).rgb;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_SoftDissolve = i.uv_texcoord * _SoftDissolve_ST.xy + _SoftDissolve_ST.zw;
			half2 appendResult215 = (half2(_SoftDissolveU , _SoftDissolveV));
			half2 temp_output_221_0 = ( uv0_SoftDissolve + ( appendResult215 * _Time.y ) );
			float2 uv0_DistortionTex = i.uv_texcoord * _DistortionTex_ST.xy + _DistortionTex_ST.zw;
			#ifdef _DISTORTIONTEX_2UV_ON
				half2 staticSwitch117 = uv0_DistortionTex;
			#else
				half2 staticSwitch117 = uv0_DistortionTex;
			#endif
			half2 appendResult112 = (half2(_DistortionTexU , _DistortionTexV));
			half3 desaturateInitialColor106 = tex2D( _DistortionTex, ( staticSwitch117 + ( appendResult112 * _Time.y ) ) ).rgb;
			half desaturateDot106 = dot( desaturateInitialColor106, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar106 = lerp( desaturateInitialColor106, desaturateDot106.xxx, 1.0 );
			half3 Distortion139 = desaturateVar106;
			half DistortionIntensity140 = _DistortionIntensity;
			half3 lerpResult226 = lerp( half3( temp_output_221_0 ,  0.0 ) , Distortion139 , DistortionIntensity140);
			#ifdef _DISTORTIONTOSOFTDISSOLVE_ON
				half3 staticSwitch227 = lerpResult226;
			#else
				half3 staticSwitch227 = half3( temp_output_221_0 ,  0.0 );
			#endif
			half3 desaturateInitialColor180 = tex2D( _SoftDissolve, staticSwitch227.xy ).rgb;
			half desaturateDot180 = dot( desaturateInitialColor180, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar180 = lerp( desaturateInitialColor180, desaturateDot180.xxx, 1.0 );
			#ifdef _VERTEXCOLORTODISSOLVE_ON
				half staticSwitch239 = i.vertexColor.a;
			#else
				half staticSwitch239 = 1.0;
			#endif
			#ifdef _CUSTOMDATATODISSOLVE_ON
				half staticSwitch246 = ( i.uv_tex4coord.z * _CustomDataIntensity );
			#else
				half staticSwitch246 = 1.0;
			#endif
			half clampResult186 = clamp( ( ( ( ( (desaturateVar180).x + _SoftDissolvePlusValue ) * staticSwitch239 ) * staticSwitch246 ) + 1.0 + ( _DissolveIntensity * -2.0 ) ) , 0.0 , 1.0 );
			half smoothstepResult193 = smoothstep( _DissolveSoft , ( 1.0 - _DissolveSoft ) , clampResult186);
			half Line208 = ( step( smoothstepResult193 , _LineRange ) - step( ( _LineWidth + smoothstepResult193 ) , _LineRange ) );
			float2 uv0_GradientTex = i.uv_texcoord * _GradientTex_ST.xy + _GradientTex_ST.zw;
			half2 appendResult131 = (half2(_GradientTexU , _GradientTexV));
			half2 temp_output_135_0 = ( uv0_GradientTex + ( appendResult131 * _Time.y ) );
			half3 lerpResult141 = lerp( half3( temp_output_135_0 ,  0.0 ) , Distortion139 , DistortionIntensity140);
			#ifdef _DISTORTIONTOGRADIENT_ON
				half3 staticSwitch146 = lerpResult141;
			#else
				half3 staticSwitch146 = half3( temp_output_135_0 ,  0.0 );
			#endif
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			half2 appendResult16 = (half2(_MainTexU , _MainTexV));
			half3 lerpResult121 = lerp( half3( ( uv0_MainTex + ( appendResult16 * _Time.y ) ) ,  0.0 ) , desaturateVar106 , _DistortionIntensity);
			half4 tex2DNode1 = tex2D( _MainTex, lerpResult121.xy );
			half3 temp_cast_10 = (_IntensityPower).xxx;
			o.Emission = ( ( ( Line208 * _LineColor * _LineIntensity ) + half4( pow( ( (tex2D( _GradientTex, staticSwitch146.xy )).rgb * ( (tex2DNode1).rgb * (_Color).rgb * (i.vertexColor).rgb ) ) , temp_cast_10 ) , 0.0 ) ) * _Intensity ).rgb;
			float2 uv0_AlphaTex = i.uv_texcoord * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
			float2 uv1_AlphaTex = i.uv2_texcoord2 * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
			#ifdef _ALPHATEX_2UV_ON
				half2 staticSwitch100 = uv1_AlphaTex;
			#else
				half2 staticSwitch100 = uv0_AlphaTex;
			#endif
			half2 appendResult62 = (half2(_AlphaTexU , _AlphaTexV));
			half3 desaturateInitialColor41 = tex2D( _AlphaTex, ( staticSwitch100 + ( appendResult62 * _Time.y ) ) ).rgb;
			half desaturateDot41 = dot( desaturateInitialColor41, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar41 = lerp( desaturateInitialColor41, desaturateDot41.xxx, 1.0 );
			float2 uv0_AlphaTex2 = i.uv_texcoord * _AlphaTex2_ST.xy + _AlphaTex2_ST.zw;
			half2 appendResult71 = (half2(_AlphaTex2U , _AlphaTex2V));
			half3 desaturateInitialColor48 = tex2D( _AlphaTex2, ( uv0_AlphaTex2 + ( appendResult71 * _Time.y ) ) ).rgb;
			half desaturateDot48 = dot( desaturateInitialColor48, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar48 = lerp( desaturateInitialColor48, desaturateDot48.xxx, 1.0 );
			float2 uv0_AlphaTex3 = i.uv_texcoord * _AlphaTex3_ST.xy + _AlphaTex3_ST.zw;
			half2 appendResult79 = (half2(_AlphaTex3U , _AlphaTex3V));
			half3 desaturateInitialColor50 = tex2D( _AlphaTex3, ( uv0_AlphaTex3 + ( appendResult79 * _Time.y ) ) ).rgb;
			half desaturateDot50 = dot( desaturateInitialColor50, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar50 = lerp( desaturateInitialColor50, desaturateDot50.xxx, 1.0 );
			float2 uv0_AlphaTex4 = i.uv_texcoord * _AlphaTex4_ST.xy + _AlphaTex4_ST.zw;
			half2 appendResult87 = (half2(_AlphaTex4U , _AlphaTex4V));
			half3 desaturateInitialColor53 = tex2D( _AlphaTex4, ( uv0_AlphaTex4 + ( appendResult87 * _Time.y ) ) ).rgb;
			half desaturateDot53 = dot( desaturateInitialColor53, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar53 = lerp( desaturateInitialColor53, desaturateDot53.xxx, 1.0 );
			float2 uv0_AlphaTex5 = i.uv_texcoord * _AlphaTex5_ST.xy + _AlphaTex5_ST.zw;
			half2 appendResult95 = (half2(_AlphaTex5U , _AlphaTex5V));
			half3 desaturateInitialColor56 = tex2D( _AlphaTex5, ( uv0_AlphaTex5 + ( appendResult95 * _Time.y ) ) ).rgb;
			half desaturateDot56 = dot( desaturateInitialColor56, float3( 0.299, 0.587, 0.114 ));
			half3 desaturateVar56 = lerp( desaturateInitialColor56, desaturateDot56.xxx, 1.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			half4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth156 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half distanceDepth156 = abs( ( screenDepth156 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			half clampResult158 = clamp( distanceDepth156 , 0.0 , 1.0 );
			half temp_output_157_0 = ( ( pow( ( tex2DNode1.a * _Color.a * i.vertexColor.a * ( (desaturateVar41).x * (desaturateVar48).x * (desaturateVar50).x * (desaturateVar53).x * (desaturateVar56).x ) ) , _OpacityPower ) * _Opacity ) * clampResult158 );
			#ifdef _DISSOLVE_ON
				half staticSwitch200 = ( temp_output_157_0 * smoothstepResult193 );
			#else
				half staticSwitch200 = temp_output_157_0;
			#endif
			o.Alpha = staticSwitch200;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1920;1029;8280.354;477.0359;4.863581;True;False
Node;AmplifyShaderEditor.CommentaryNode;120;-5434.59,-119.5232;Inherit;False;1322.521;659.2938;;3;119;106;105;UV扭曲;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;119;-5388.339,-69.52321;Inherit;False;714.3193;609.294;;9;111;112;113;110;109;115;117;114;116;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-5321.02,345.7707;Half;False;Property;_DistortionTexV;DistortionTexV;13;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-5321.02,273.7707;Half;False;Property;_DistortionTexU;DistortionTexU;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-5338.339,-19.52322;Inherit;False;0;105;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;111;-5320.02,421.7707;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;112;-5168.021,275.7707;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;114;-5324.02,156.771;Inherit;False;0;105;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-5038.02,286.7707;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;117;-5083.12,124.8983;Inherit;False;Property;_DistortionTex_2UV;DistortionTex_2UV;11;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;222;-5505.526,1911.194;Inherit;False;700.0039;432.9998;;7;213;214;215;217;219;221;218;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;115;-4828.016,228.7708;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-5452.526,2078.193;Half;False;Property;_SoftDissolveU;SoftDissolveU;26;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;124;-4012.644,837.503;Inherit;False;299;165;;1;122;UV扭曲强度;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;105;-4642.661,188.8621;Inherit;True;Property;_DistortionTex;DistortionTex;10;0;Create;True;0;0;False;0;-1;None;7ab44978b03a7494586f5a4d3766dd1f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;213;-5452.526,2150.193;Half;False;Property;_SoftDissolveV;SoftDissolveV;27;0;Create;True;0;0;False;0;0;-0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;215;-5299.527,2080.193;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-3962.644,887.503;Half;False;Property;_DistortionIntensity;DistortionIntensity;14;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;106;-4333.823,190.7565;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;217;-5451.526,2226.193;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;223;-4716.297,1871.818;Inherit;False;916.1825;405.3249;;4;227;226;225;224;扭曲影响叠加;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;218;-5455.526,1961.194;Inherit;False;0;179;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-5169.526,2091.193;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-4089.538,183.21;Half;False;Distortion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-3666.306,896.6782;Half;False;DistortionIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;225;-4600.125,2058.117;Inherit;False;139;Distortion;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;-4666.297,2128.368;Inherit;False;140;DistortionIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;221;-4959.522,2033.193;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;226;-4384.914,2024.143;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;227;-4148.115,1921.818;Inherit;False;Property;_DistortionToSoftDissolve;DistortionToSoftDissolve;25;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;233;-3735.728,1874.02;Inherit;False;799.5801;280.6121;;3;179;180;181;溶解图;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;179;-3685.728,1924.02;Inherit;True;Property;_SoftDissolve;SoftDissolve;24;0;Create;True;0;0;False;0;-1;None;7ab44978b03a7494586f5a4d3766dd1f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;236;-3536.095,2639.51;Inherit;False;323;165;;1;235;溶解图强度补充;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;249;-3514.128,3422.794;Inherit;False;838.4019;338.792;;5;245;242;243;247;246;自定义数据影响溶解;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-7902.16,495.9801;Inherit;False;2075.865;2496.433;;23;59;91;83;67;75;99;100;58;47;55;52;32;41;48;56;50;53;42;54;49;51;57;46;Alpha组;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;241;-3555.229,2933.732;Inherit;False;533;334;;3;240;238;239;顶点色/粒子透明度影响溶解;1,1,1,1;0;0
Node;AmplifyShaderEditor.DesaturateOpNode;180;-3380.246,1929.254;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;59;-7774.773,714.5095;Inherit;False;700;433;;7;66;65;64;63;62;61;60;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;181;-3208.148,1924.632;Inherit;True;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;91;-7719.825,2559.414;Inherit;False;700;433;;7;98;97;96;95;94;93;92;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;75;-7752.942,1640.967;Inherit;False;700;433;;7;82;81;80;79;78;77;76;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-7767.619,1188.39;Inherit;False;700;433;;7;74;73;72;71;70;69;68;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;245;-3464.128,3646.586;Half;False;Property;_CustomDataIntensity;CustomDataIntensity;33;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;238;-3505.229,3065.732;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;235;-3486.095,2689.51;Half;False;Property;_SoftDissolvePlusValue;SoftDissolvePlusValue;30;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;242;-3458.663,3490.283;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;240;-3474.229,2983.732;Half;False;Constant;_Float2;Float 2;54;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-7733.371,2115.56;Inherit;False;700;433;;7;85;84;89;88;87;86;90;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;250;-2066.317,2075.396;Inherit;False;1236.52;486.0388;;9;191;192;185;190;184;198;186;199;193;软溶解;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-7721.773,953.5106;Half;False;Property;_AlphaTexV;AlphaTexV;22;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-7714.619,1427.39;Half;False;Property;_AlphaTex2V;AlphaTex2V;38;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-7721.773,881.5095;Half;False;Property;_AlphaTexU;AlphaTexU;21;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-7666.824,2726.414;Half;False;Property;_AlphaTex5U;AlphaTex5U;46;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-7680.37,2282.56;Half;False;Property;_AlphaTex4U;AlphaTex4U;43;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-7714.619,1355.389;Half;False;Property;_AlphaTex2U;AlphaTex2U;37;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-7666.824,2798.414;Half;False;Property;_AlphaTex5V;AlphaTex5V;47;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;239;-3323.229,3050.732;Inherit;False;Property;_VertexColorToDissolve;VertexColorToDissolve;31;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;234;-2697.773,2124.012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-7699.941,1879.967;Half;False;Property;_AlphaTex3V;AlphaTex3V;41;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-3186.496,3555.864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-3200.706,3476.073;Half;False;Constant;_Float3;Float 3;56;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-7699.941,1807.967;Half;False;Property;_AlphaTex3U;AlphaTex3U;40;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-7680.37,2354.56;Half;False;Property;_AlphaTex4V;AlphaTex4V;44;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;71;-7561.618,1357.389;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;-7679.37,2430.56;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;118;-4809.205,569.5992;Inherit;False;701.9956;579.4825;;9;15;14;12;16;11;7;8;101;102;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;-2523.476,2128.291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;78;-7698.941,1955.967;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;94;-7665.824,2874.414;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;87;-7527.37,2284.56;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-7546.941,1809.967;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-7755.907,761.9155;Inherit;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;138;-3417.323,-1020.141;Inherit;False;700.0005;433.0001;;7;129;130;131;132;133;134;135;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;62;-7568.772,883.5095;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;95;-7513.824,2728.414;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-2016.317,2245.393;Half;False;Property;_DissolveIntensity;DissolveIntensity;28;0;Create;True;0;0;False;0;0.5;0.274;0;1.05;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-7720.773,1029.511;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1924.317,2315.394;Half;False;Constant;_Float1;Float 1;42;0;Create;True;0;0;False;0;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;99;-7852.16,545.9805;Inherit;False;1;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;70;-7713.619,1503.39;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;246;-3024.726,3472.794;Inherit;False;Property;_CustomDataToDissolve;CustomDataToDissolve;32;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-7702.942,1690.967;Inherit;False;0;52;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;129;-3364.323,-781.1405;Half;False;Property;_GradientTexV;GradientTexV;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-4754.208,883.082;Half;False;Property;_MainTexU;MainTexU;17;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-7416.941,1820.967;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;100;-7483.756,596.5705;Inherit;False;Property;_AlphaTex_2UV;AlphaTex_2UV;20;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-7397.37,2295.56;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-3365.323,-853.1406;Half;False;Property;_GradientTexU;GradientTexU;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-4754.208,955.0822;Half;False;Property;_MainTexV;MainTexV;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-7683.37,2165.56;Inherit;False;0;55;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-7431.618,1368.389;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-7438.772,894.5095;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;96;-7669.824,2609.414;Inherit;False;0;58;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-7383.823,2739.414;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-2276.26,2053.659;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-1757.317,2175.393;Half;False;Constant;_Float0;Float 0;42;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1751.317,2247.393;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-7717.619,1238.39;Inherit;False;0;47;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;131;-3211.323,-851.1406;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-4601.208,885.082;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-7221.618,1310.39;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-7187.37,2237.56;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-7228.772,836.5095;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-7173.823,2681.414;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-1319.982,2349.498;Half;False;Property;_DissolveSoft;DissolveSoft;29;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;184;-1577.609,2125.396;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-4753.208,1031.082;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;132;-3363.323,-705.1404;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-7206.941,1762.967;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;178;-1388.136,3060.22;Inherit;False;2378.933;723.2931;;7;165;173;160;163;164;162;161;顶点偏移;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;32;-6849.798,1424.924;Inherit;True;Property;_AlphaTex;AlphaTex;19;0;Create;True;0;0;False;0;-1;None;a59c1bb44671ce7498d181586afa90b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;133;-3367.323,-970.1406;Inherit;False;0;125;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-6838.079,2193.334;Inherit;True;Property;_AlphaTex5;AlphaTex5;45;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;209;-681.805,2162.318;Inherit;False;1288.558;529.48;;7;202;206;207;204;205;203;208;描边;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-4471.208,896.082;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;199;-1180.661,2451.435;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;186;-1365.317,2127.393;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;147;-2673.991,-924.7684;Inherit;False;916.1825;405.3249;;4;144;143;141;146;扭曲影响叠加;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-4757.208,766.0818;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-6841.079,2011.334;Inherit;True;Property;_AlphaTex4;AlphaTex4;42;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-6846.079,1822.336;Inherit;True;Property;_AlphaTex3;AlphaTex3;39;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;47;-6852.08,1632.335;Inherit;True;Property;_AlphaTex2;AlphaTex2;36;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-3081.323,-840.1405;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DesaturateOpNode;50;-6548.923,1827.574;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-2557.819,-738.4698;Inherit;False;139;Distortion;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-2623.991,-668.2186;Inherit;False;140;DistortionIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-631.805,2212.318;Half;False;Property;_LineWidth;LineWidth;34;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;53;-6543.923,2016.573;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-4261.208,838.082;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DesaturateOpNode;48;-6554.924,1637.573;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;165;-1338.136,3110.22;Inherit;False;700.0005;433.0001;;7;172;171;170;169;168;167;166;UV流动组件;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-2871.323,-898.1406;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DesaturateOpNode;41;-6552.642,1430.161;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;193;-1085.797,2170.408;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;56;-6540.923,2198.573;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-6379.923,1822.574;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;145;-2380.327,-52.64466;Inherit;False;578.663;280;;2;4;1;主贴图;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;54;-6374.923,2011.573;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-277.2471,2316.798;Half;False;Property;_LineRange;LineRange;35;0;Create;True;0;0;False;0;0;0.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;28;-2339.17,614.6566;Inherit;False;496.3021;257;;2;18;20;颜色;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;42;-6383.642,1425.161;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-1286.136,3277.22;Half;False;Property;_OffsetTexU;OffsetTexU;49;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;49;-6385.924,1632.573;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;57;-6371.923,2193.573;Inherit;False;True;False;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-1285.137,3349.22;Half;False;Property;_OffsetTexV;OffsetTexV;50;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-3731.381,480.6378;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;-462.6002,2217.767;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2311.411,879.1989;Inherit;False;465.1002;262.4002;;2;25;26;顶点颜色;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;141;-2342.608,-772.4436;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;146;-2105.809,-874.7684;Inherit;False;Property;_DistortionToGradient;DistortionToGradient;3;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;24;-848.0045,826.8493;Inherit;False;219;183;;1;3;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;168;-1132.137,3279.22;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;25;-2261.411,939.5992;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;148;-1736.236,-937.8627;Inherit;False;577.7374;280;;2;125;126;颜色叠加;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;204;-68.24715,2231.798;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2330.327,-2.644712;Inherit;True;Property;_MainTex;MainTex;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;169;-1284.137,3425.22;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-2289.17,664.6566;Half;False;Property;_Color;Color;4;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;155;-602.1651,949.1931;Inherit;False;428;215;;2;153;151;透明度Power;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;206;-69.24715,2438.798;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-6071.293,1607.65;Inherit;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;232;-259.5104,1248.193;Inherit;False;643.8986;211;;3;158;156;159;深度消隐;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-168.1671,846.5755;Inherit;False;375.6895;217.4422;;2;22;6;Opacity Control;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-1288.136,3160.22;Inherit;False;0;160;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;207;160.7529,2256.798;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;149;-1059.1,397.1389;Inherit;False;476.4081;303;;2;2;127;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-552.1651,1049.193;Half;False;Property;_OpacityPower;OpacityPower;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;173;-603.1384,3152.938;Inherit;False;916.1825;405.3249;;4;177;176;175;174;扭曲影响顶点偏移;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;125;-1686.236,-887.8627;Inherit;True;Property;_GradientTex;GradientTex;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;159;-209.5104,1325.862;Half;False;Property;_DepthFade;DepthFade;5;0;Create;True;0;0;False;0;0;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;4;-2038.664,0.9552631;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;26;-2083.311,929.1989;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;20;-2079.867,672.4565;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-1002.138,3290.22;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-798.0045,876.8493;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-118.1671,949.0177;Half;False;Property;_Opacity;Opacity;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;151;-354.1652,999.1931;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1009.1,519.7498;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;172;-792.1375,3232.22;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-486.9673,3339.235;Inherit;False;139;Distortion;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;154;-569.1651,527.2227;Inherit;False;431.2471;224.9703;;2;150;152;强度Power;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;208;363.7529,2250.798;Half;False;Line;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;156;-51.16566,1298.193;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;126;-1395.499,-884.7063;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;-553.1393,3409.487;Inherit;False;140;DistortionIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;231;-102.3438,382.7451;Inherit;False;613.4973;415.4436;;5;210;228;211;230;229;描边叠加;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;176;-271.7563,3305.262;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-817.692,447.1389;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-38.71758,432.7451;Inherit;False;208;Line;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-519.1651,637.1931;Half;False;Property;_IntensityPower;IntensityPower;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;229;-52.34375,519.1887;Inherit;False;Property;_LineColor;LineColor;54;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;38.52243,896.5755;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;158;209.3882,1303.193;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-33.34375,683.1887;Half;False;Property;_LineIntensity;LineIntensity;55;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;177;-34.95599,3202.938;Inherit;False;Property;_DistortionToOffset;DistortionToOffset;52;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;30;660.2076,604.034;Inherit;False;375.4209;262.1147;;2;21;5;Emission Control;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;201.6563,524.1887;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;431.0442,951.462;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;150;-317.9182,577.2227;Inherit;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;210;357.1536,616.5429;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;498.7956,3500.514;Inherit;False;Property;_OffsetIntensity;OffsetIntensity;51;0;Create;True;0;0;False;0;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;164;495.7956,3581.513;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;749.3206,1282.298;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;710.2075,751.1486;Half;False;Property;_Intensity;Intensity;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;163;501.7956,3361.514;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;160;395.7956,3176.513;Inherit;True;Property;_OffsetTex;OffsetTex;48;0;Create;True;0;0;False;0;-1;None;d7587323b7bbc084ab37898fd841d0fa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;821.7957,3183.513;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-4759.203,619.5991;Inherit;False;1;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;200;885.9921,1047.368;Inherit;False;Property;_Dissolve;Dissolve;23;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;866.6284,654.034;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;102;-4482.418,692.9567;Inherit;False;Property;_MainTex_2UV;MainTex_2UV;16;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1863.328,718.2582;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Shader讲解;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;53;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;112;0;110;0
WireConnection;112;1;109;0
WireConnection;113;0;112;0
WireConnection;113;1;111;0
WireConnection;117;1;114;0
WireConnection;117;0;116;0
WireConnection;115;0;117;0
WireConnection;115;1;113;0
WireConnection;105;1;115;0
WireConnection;215;0;214;0
WireConnection;215;1;213;0
WireConnection;106;0;105;0
WireConnection;219;0;215;0
WireConnection;219;1;217;0
WireConnection;139;0;106;0
WireConnection;140;0;122;0
WireConnection;221;0;218;0
WireConnection;221;1;219;0
WireConnection;226;0;221;0
WireConnection;226;1;225;0
WireConnection;226;2;224;0
WireConnection;227;1;221;0
WireConnection;227;0;226;0
WireConnection;179;1;227;0
WireConnection;180;0;179;0
WireConnection;181;0;180;0
WireConnection;239;1;240;0
WireConnection;239;0;238;4
WireConnection;234;0;181;0
WireConnection;234;1;235;0
WireConnection;243;0;242;3
WireConnection;243;1;245;0
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;237;0;234;0
WireConnection;237;1;239;0
WireConnection;87;0;84;0
WireConnection;87;1;85;0
WireConnection;79;0;76;0
WireConnection;79;1;77;0
WireConnection;62;0;60;0
WireConnection;62;1;61;0
WireConnection;95;0;92;0
WireConnection;95;1;93;0
WireConnection;246;1;247;0
WireConnection;246;0;243;0
WireConnection;81;0;79;0
WireConnection;81;1;78;0
WireConnection;100;1;65;0
WireConnection;100;0;99;0
WireConnection;89;0;87;0
WireConnection;89;1;86;0
WireConnection;73;0;71;0
WireConnection;73;1;70;0
WireConnection;64;0;62;0
WireConnection;64;1;63;0
WireConnection;97;0;95;0
WireConnection;97;1;94;0
WireConnection;248;0;237;0
WireConnection;248;1;246;0
WireConnection;190;0;192;0
WireConnection;190;1;191;0
WireConnection;131;0;130;0
WireConnection;131;1;129;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;66;0;100;0
WireConnection;66;1;64;0
WireConnection;98;0;96;0
WireConnection;98;1;97;0
WireConnection;184;0;248;0
WireConnection;184;1;185;0
WireConnection;184;2;190;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;32;1;66;0
WireConnection;58;1;98;0
WireConnection;11;0;16;0
WireConnection;11;1;12;0
WireConnection;199;0;198;0
WireConnection;186;0;184;0
WireConnection;55;1;90;0
WireConnection;52;1;82;0
WireConnection;47;1;74;0
WireConnection;134;0;131;0
WireConnection;134;1;132;0
WireConnection;50;0;52;0
WireConnection;53;0;55;0
WireConnection;8;0;7;0
WireConnection;8;1;11;0
WireConnection;48;0;47;0
WireConnection;135;0;133;0
WireConnection;135;1;134;0
WireConnection;41;0;32;0
WireConnection;193;0;186;0
WireConnection;193;1;198;0
WireConnection;193;2;199;0
WireConnection;56;0;58;0
WireConnection;51;0;50;0
WireConnection;54;0;53;0
WireConnection;42;0;41;0
WireConnection;49;0;48;0
WireConnection;57;0;56;0
WireConnection;121;0;8;0
WireConnection;121;1;106;0
WireConnection;121;2;122;0
WireConnection;202;0;203;0
WireConnection;202;1;193;0
WireConnection;141;0;135;0
WireConnection;141;1;143;0
WireConnection;141;2;144;0
WireConnection;146;1;135;0
WireConnection;146;0;141;0
WireConnection;168;0;166;0
WireConnection;168;1;167;0
WireConnection;204;0;202;0
WireConnection;204;1;205;0
WireConnection;1;1;121;0
WireConnection;206;0;193;0
WireConnection;206;1;205;0
WireConnection;46;0;42;0
WireConnection;46;1;49;0
WireConnection;46;2;51;0
WireConnection;46;3;54;0
WireConnection;46;4;57;0
WireConnection;207;0;206;0
WireConnection;207;1;204;0
WireConnection;125;1;146;0
WireConnection;4;0;1;0
WireConnection;26;0;25;0
WireConnection;20;0;18;0
WireConnection;171;0;168;0
WireConnection;171;1;169;0
WireConnection;3;0;1;4
WireConnection;3;1;18;4
WireConnection;3;2;25;4
WireConnection;3;3;46;0
WireConnection;151;0;3;0
WireConnection;151;1;153;0
WireConnection;2;0;4;0
WireConnection;2;1;20;0
WireConnection;2;2;26;0
WireConnection;172;0;170;0
WireConnection;172;1;171;0
WireConnection;208;0;207;0
WireConnection;156;0;159;0
WireConnection;126;0;125;0
WireConnection;176;0;172;0
WireConnection;176;1;175;0
WireConnection;176;2;174;0
WireConnection;127;0;126;0
WireConnection;127;1;2;0
WireConnection;22;0;151;0
WireConnection;22;1;6;0
WireConnection;158;0;156;0
WireConnection;177;1;172;0
WireConnection;177;0;176;0
WireConnection;228;0;211;0
WireConnection;228;1;229;0
WireConnection;228;2;230;0
WireConnection;157;0;22;0
WireConnection;157;1;158;0
WireConnection;150;0;127;0
WireConnection;150;1;152;0
WireConnection;210;0;228;0
WireConnection;210;1;150;0
WireConnection;201;0;157;0
WireConnection;201;1;193;0
WireConnection;160;1;177;0
WireConnection;161;0;160;0
WireConnection;161;1;163;0
WireConnection;161;2;162;0
WireConnection;161;3;164;4
WireConnection;200;1;157;0
WireConnection;200;0;201;0
WireConnection;21;0;210;0
WireConnection;21;1;5;0
WireConnection;102;1;7;0
WireConnection;102;0;101;0
WireConnection;0;2;21;0
WireConnection;0;9;200;0
WireConnection;0;11;161;0
ASEEND*/
//CHKSM=5D70F6EDF9460BC8615347C6DB58F9A6C58A9662