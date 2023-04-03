Shader "Custom/ColorThreshold" {
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _Threshold("Threshold", Range(0, 1)) = 0.5
        _SquareSize("Square Size", Range(1, 100)) = 100
    }

        SubShader{
            Tags { "Queue" = "Transparent" "RenderType" = "Opaque" }
            LOD 100

            Pass {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"

                struct appdata {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float _Threshold;
                float _SquareSize;

                v2f vert(appdata v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target {
                    float4 col = tex2D(_MainTex, i.uv);
                    float grayscale = dot(col.rgb, float3(0.299, 0.587, 0.114));
                    fixed4 squareColor = (grayscale >= _Threshold) ? fixed4(1, 1, 1, col.a) : fixed4(0, 0, 0, col.a);

                    // Calculate approximate color value for 100x100 pixel square
                    float2 squarePos = floor(i.uv * _SquareSize / 100) * 100;
                    float4 approxColor = tex2D(_MainTex, squarePos / _SquareSize);

                    return lerp(approxColor, squareColor, step(_Threshold, grayscale));
                }
                ENDCG
            }
        }
}