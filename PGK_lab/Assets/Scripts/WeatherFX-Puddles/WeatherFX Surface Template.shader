Shader "Untitled Games/WeatherFX Template"
{
	Properties
	{
		_MainTex("Albedo", 2D) = "white" {}
		_BumpMap("Normal Map", 2D) = "bump" {}
		_MetallicGlossMap("Metallic", 2D) = "black" {}
		_ParallaxMap("Height Map", 2D) = "grey" {}
		_OcclusionMap("Occlusion", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _MetallicGlossMap;
		sampler2D _ParallaxMap;
		sampler2D _OcclusionMap;

		struct Input
		{
			float2 uv_MainTex;
			float3 worldPos;
		};

		void surf(Input input, inout SurfaceOutputStandard output)
		{
			float2 uv = input.uv_MainTex;

			// Get the main PBR material
			float4 diffuse = tex2D(_MainTex, uv);
			float3 albedo = diffuse.rgb;
			float4 metallicGloss = tex2D(_MetallicGlossMap, uv);
			float3 normal = UnpackNormal(tex2D(_BumpMap, uv));
			float metallic = metallicGloss.r;
			float smoothness = metallicGloss.a;
			float occlusion = tex2D(_OcclusionMap, uv).r;

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
