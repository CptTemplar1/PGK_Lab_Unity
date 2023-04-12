Shader "Roystan/CelShading"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
	// Œwiat³o otoczenia jest nak³adane równomiernie na wszystkie powierzchnie obiektu
	[HDR]
	_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
	[HDR]
	_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		// Kontrola rozmiaru odbicia lustrzanego.
		_Glossiness("Glossiness", Float) = 32
		[HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
			// Kontroluje, jak p³ynnie krawêdŸ siê zlewa, gdy zbli¿a siê do nieoœwietlonych czêœci powierzchni
			_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
	}
		SubShader
		{
			Pass
			{
				// Ustawienie Shader Pass na u¿ycie  Forward renderingu, i odbieranie tylko
				// danych o g³ównym œwietle kierunkowym i œwietle otoczenia.
				Tags
				{
					"LightMode" = "ForwardBase"
					"PassFlags" = "OnlyDirectional"
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
			// Kompilacja wielu wersji tego shadera w zale¿noœci od ustawieñ oœwietlenia.
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			// Pliki poni¿ej zawieraj¹ makra i funkcje pomocnicze do oœwietlenia i cieni.
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				// Makro znalezione w Autolight.cginc. Deklaruje wektor4 do semantyki TEXCOORD2 z zmienn¹ precyzj¹
				// w zale¿noœci od docelowej platformy.
				SHADOW_COORDS(2)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = WorldSpaceViewDir(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				// Zdefiniowane w Autolight.cginc. Przypisuje powy¿sze koordynaty cienia
				// przez przetransformowanie wierzcho³ka z przestrzeni œwiata do przestrzeni mapy cieni.
				TRANSFER_SHADOW(o)
				return o;
			}

			float4 _Color;

			float4 _AmbientColor;

			float4 _SpecularColor;
			float _Glossiness;

			float4 _RimColor;
			float _RimAmount;
			float _RimThreshold;

			float4 frag(v2f i) : SV_Target
			{
				float3 normal = normalize(i.worldNormal);
				float3 viewDir = normalize(i.viewDir);

				// Oœwietlenie poni¿ej jest obliczane z u¿yciem modelu Blinn-Phonga,
				// z wartoœciami ograniczonymi, aby stworzyæ "toonowy" wygl¹d.
				// https://en.wikipedia.org/wiki/Blinn-Phong_shading_model

				// Oblicz oœwietlenie od œwiat³a kierunkowego.
				// _WorldSpaceLightPos0 to wektor skierowany w PRZECIWNYM
				// kierunku g³ównego œwiat³a kierunkowego.
				float NdotL = dot(_WorldSpaceLightPos0, normal);

				// Pobierz wartoœæ z cieniowanej mapy, zwracaj¹c wartoœæ z zakresu 0...1,
				// gdzie 0 to cieñ, a 1 to brak cienia.
				float shadow = SHADOW_ATTENUATION(i);
				// Podziel intensywnoœæ na jasne i ciemne, p³ynnie interpoluj¹c
				// pomiêdzy nimi, aby unikn¹æ drastycznego skoku.
				float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
				// Pomnó¿ przez intensywnoœæ i kolor g³ównego œwiat³a kierunkowego.
				float4 light = lightIntensity * _LightColor0;

				// Oblicz odbicie lustrzane.
				float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
				float NdotH = dot(normal, halfVector);
				// Pomnó¿ przez _Glossiness, aby umo¿liwiæ artystom u¿ycie mniejszych
				// wartoœci po³ysku w edytorze.
				float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
				float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
				float4 specular = specularIntensitySmooth * _SpecularColor;

				// Oblicz podœwietlenie krawêdzi.
				float rimDot = 1 - dot(viewDir, normal);
				// Chcemy, aby efekt oœwietleniowy na krawêdziach by³ widoczny tylko na oœwietlonej stronie powierzchni,
				// dlatego mno¿ymy go przez NdotL podniesione do potêgi, aby uzyskaæ p³ynne przejœcie.
				float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
				rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
				float4 rim = rimIntensity * _RimColor;

				float4 sample = tex2D(_MainTex, i.uv);

				return (light + _AmbientColor + specular + rim) * _Color * sample;
			}
			ENDCG
		}

			// Obs³uga rzucania cieni.
			UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
		}
}