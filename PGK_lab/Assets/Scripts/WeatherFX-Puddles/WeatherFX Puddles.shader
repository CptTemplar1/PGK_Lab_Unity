Shader "Untitled Games/WeatherFX/Puddles" 
{
	Properties 
	{
		_MainTex("Albedo", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_MetallicGlossMap("Metallic", 2D) = "black" {}
		_ParallaxMap("Height Map", 2D) = "grey" {}
		_OcclusionMap("Occlusion", 2D) = "white" {}

		_WaterLevel("Water Level", Range(0, 1)) = 0
		_WaterColor("Water Color", Color) = (1,1,1,1)
		_WaterBumpMap1("Water Normal Map 1", 2D) = "bump" {}
		_WaterBumpMap2("Water Normal Map 2", 2D) = "bump" {}
		_HeightmapBlending("Heightmap Blending", Float) = 0.05

		_Refraction("Water Refraction", Range(0, 1)) = 0.1

		_CausticMap("Caustic", 3D) = "grey" {}
		_CausticLevel("Caustic Level", Range(0, 1)) = 0.1
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 4.6
		#include "heightblend.cginc"

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _MetallicGlossMap;
		sampler2D _ParallaxMap;
		sampler2D _OcclusionMap;

		float _WaterLevel;
		float4 _WaterColor;
		sampler2D _WaterBumpMap1;
		sampler2D _WaterBumpMap2;

		float _Refraction;

		sampler3D _CausticMap;
		float _CausticLevel;

		struct Input
		{
			float2 uv_MainTex;
			float3 worldPos;
		};

		void surf (Input input, inout SurfaceOutputStandard output)
		{
			float2 uv = input.uv_MainTex;
			float height = tex2D(_ParallaxMap, uv).r;

			// Create the water surface effect. This combines two water normal maps to create an animated surface effect.
			float2 waterUV1 = (input.worldPos.xz * 5) + (_Time.x * 0.8);
			float3 waterNormal1 = UnpackNormal(tex2D(_WaterBumpMap1, waterUV1));

			float2 waterUV2 = (input.worldPos.xz * 3) + float2(_Time.x * -0.6, _Time.x * 0.5);
			float3 waterNormal2 = UnpackNormal(tex2D(_WaterBumpMap2, waterUV2));

			float waterNormal1Level = (sin(_Time.y * 0.6) + 1.0) / 2.0;
			waterNormal1.z = 3.0 + (waterNormal1Level * 5.0);
			waterNormal1 = normalize(waterNormal1);

			float waterNormal2Level = (cos(_Time.y * 0.8) + 1.0) / 2.0;
			waterNormal2.z = 3.0 + (waterNormal2Level * 7.0);
			waterNormal2 = normalize(waterNormal2);

			float2 waterUV3 = input.worldPos.xz;
			float waterLerp = UnpackNormal(tex2D(_WaterBumpMap1, waterUV3)).z * 36;
			waterLerp = (sin(waterLerp + _Time.y) + 1.0) / 2.0;
			waterLerp = 0.2 + (waterLerp * 0.6);
			float3 waterNormal = lerp(waterNormal1, waterNormal2, waterLerp);

			float2 uvDistorted = float2(uv.x + (waterNormal.x * _Refraction * 0.2), uv.y + (waterNormal.y * _Refraction * 0.2));
			uv = heightblend(uv, height, uvDistorted, _WaterLevel);

			// Caustics
			float3 causticUV = float3(input.worldPos.x, input.worldPos.z, _Time.x * 4.2);
			float caustic = tex3D(_CausticMap, causticUV).a;

			// Get the main PBR material
			float4 diffuse = tex2D (_MainTex, uv);
			float3 albedo = diffuse.rgb;
			float4 metallicGloss = tex2D(_MetallicGlossMap, uv);
			float3 normal = UnpackNormal(tex2D(_BumpMap, uv));
			float metallic = metallicGloss.r;
			float smoothness = metallicGloss.a;
			float occlusion = tex2D(_OcclusionMap, uv).r;

			float3 wetAlbedo = (albedo * _WaterColor.rgb) + (caustic * _CausticLevel);
			albedo = heightblend(albedo, height, wetAlbedo, _WaterLevel);

			normal = heightblend(normal, height, waterNormal, _WaterLevel);
			metallic = heightblend(metallic, height, 0, _WaterLevel);
			smoothness = heightblend(smoothness, height, 0.8, _WaterLevel);
			occlusion = heightblend(occlusion, height, 1, _WaterLevel);

			// Update the height to reflect the water place
			height = max(height, _WaterLevel);

			output.Albedo = albedo;
			output.Normal = normal;
			output.Metallic = metallic;
			output.Smoothness = smoothness;
			output.Occlusion = occlusion;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
