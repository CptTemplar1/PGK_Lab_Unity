Shader "Custom/SquareGradient" {
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _Color1("Color 1", Color) = (1,1,1,1)
        _Color2("Color 2", Color) = (0,0,0,1)
    }

        SubShader{
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
                float4 _Color1;
                float4 _Color2;

                v2f vert(appdata v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target {
                    float2 position = i.uv * 16;
                    float2 squarePosition = floor(position) / 16;
                    float2 relativePosition = position - floor(position);
                    float t = length(relativePosition - 0.5);
                    float4 color = lerp(_Color1, _Color2, t);
                    return color * tex2D(_MainTex, squarePosition);
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}