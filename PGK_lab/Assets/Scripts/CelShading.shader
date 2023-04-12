Shader "Roystan/CelShading"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
	// �wiat�o otoczenia jest nak�adane r�wnomiernie na wszystkie powierzchnie obiektu
	[HDR]
	_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
	[HDR]
	_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		// Kontrola rozmiaru odbicia lustrzanego.
		_Glossiness("Glossiness", Float) = 32
		[HDR]
		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0, 1)) = 0.716
			// Kontroluje, jak p�ynnie kraw�d� si� zlewa, gdy zbli�a si� do nieo�wietlonych cz�ci powierzchni
			_RimThreshold("Rim Threshold", Range(0, 1)) = 0.1
	}
		SubShader
		{
			Pass
			{
				// Ustawienie Shader Pass na u�ycie  Forward renderingu, i odbieranie tylko
				// danych o g��wnym �wietle kierunkowym i �wietle otoczenia.
				Tags
				{
					"LightMode" = "ForwardBase"
					"PassFlags" = "OnlyDirectional"
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
			// Kompilacja wielu wersji tego shadera w zale�no�ci od ustawie� o�wietlenia.
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			// Pliki poni�ej zawieraj� makra i funkcje pomocnicze do o�wietlenia i cieni.
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
				// Makro znalezione w Autolight.cginc. Deklaruje wektor4 do semantyki TEXCOORD2 z zmienn� precyzj�
				// w zale�no�ci od docelowej platformy.
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
				// Zdefiniowane w Autolight.cginc. Przypisuje powy�sze koordynaty cienia
				// przez przetransformowanie wierzcho�ka z przestrzeni �wiata do przestrzeni mapy cieni.
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

				// O�wietlenie poni�ej jest obliczane z u�yciem modelu Blinn-Phonga,
				// z warto�ciami ograniczonymi, aby stworzy� "toonowy" wygl�d.
				// https://en.wikipedia.org/wiki/Blinn-Phong_shading_model

				// Oblicz o�wietlenie od �wiat�a kierunkowego.
				// _WorldSpaceLightPos0 to wektor skierowany w PRZECIWNYM
				// kierunku g��wnego �wiat�a kierunkowego.
				float NdotL = dot(_WorldSpaceLightPos0, normal);

				// Pobierz warto�� z cieniowanej mapy, zwracaj�c warto�� z zakresu 0...1,
				// gdzie 0 to cie�, a 1 to brak cienia.
				float shadow = SHADOW_ATTENUATION(i);
				// Podziel intensywno�� na jasne i ciemne, p�ynnie interpoluj�c
				// pomi�dzy nimi, aby unikn�� drastycznego skoku.
				float lightIntensity = smoothstep(0, 0.01, NdotL * shadow);
				// Pomn� przez intensywno�� i kolor g��wnego �wiat�a kierunkowego.
				float4 light = lightIntensity * _LightColor0;

				// Oblicz odbicie lustrzane.
				float3 halfVector = normalize(_WorldSpaceLightPos0 + viewDir);
				float NdotH = dot(normal, halfVector);
				// Pomn� przez _Glossiness, aby umo�liwi� artystom u�ycie mniejszych
				// warto�ci po�ysku w edytorze.
				float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
				float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
				float4 specular = specularIntensitySmooth * _SpecularColor;

				// Oblicz pod�wietlenie kraw�dzi.
				float rimDot = 1 - dot(viewDir, normal);
				// Chcemy, aby efekt o�wietleniowy na kraw�dziach by� widoczny tylko na o�wietlonej stronie powierzchni,
				// dlatego mno�ymy go przez NdotL podniesione do pot�gi, aby uzyska� p�ynne przej�cie.
				float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
				rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);
				float4 rim = rimIntensity * _RimColor;

				float4 sample = tex2D(_MainTex, i.uv);

				return (light + _AmbientColor + specular + rim) * _Color * sample;
			}
			ENDCG
		}

			// Obs�uga rzucania cieni.
			UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
		}
}