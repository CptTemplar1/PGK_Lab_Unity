Shader "Custom/InteractiveSnow/SnowHeightMapUpdate"
{
    Properties
    {
        _DrawPosition ("Drawpos", Vector) = (-1,-1,0,0)
        _DrawBrush("Brush", 2D) = "white" {}
        _Offset("Offset", float) = 0.05
    
    }

    SubShader
    {
        Lighting Off
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            sampler2D _DrawBrush;
            float4 _DrawPosition;
            float _DrawAngle;
            float _RestoreAmount;
            float _Offset;

            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                float4 previousColor = tex2D(_SelfTexture2D, IN.localTexcoord.xy);
                float2 pos = IN.localTexcoord.xy - _DrawPosition;

                float2x2 rot = float2x2(cos(_DrawAngle), -sin(_DrawAngle),
                                        sin(_DrawAngle), cos(_DrawAngle));
                pos = mul(rot, pos);
                pos /= _Offset;
                pos += float2(0.5, 0.5);

                float4 drawColor = tex2D(_DrawBrush, pos);

                return min(previousColor, drawColor);
            }
            ENDCG
        }
    }
}


//Shader "Custom/InteractiveSnow/SnowHeightMapUpdate"
//{
//    Properties
//    {
//    _DrawPosition("Drawpos", Vector) = (-1,-1,0,0)
//    _DrawBrush("Brush", 2D) = "white" {}
//    _Offset("Offset", float) = 0.05
//    _TimeToUpdate("Time to Update", Range(0.0, 60.0)) = 10.0
//    }
//
//        SubShader
//    {
//        Lighting Off
//        Blend One Zero
//
//        CustomRenderTexture _HeightMapTexture;
//        float _TimeSinceLastUpdate;
//        float _TimeToUpdate;
//
//        void Update()
//        {
//            _TimeSinceLastUpdate += Time.deltaTime;
//            if (_TimeSinceLastUpdate > _TimeToUpdate)
//            {
//                // Regenerate the heightmap texture
//                RenderTexture.active = _HeightMapTexture;
//                GL.Clear(true, true, Color.black);
//                RenderTexture.active = null;
//
//                _TimeSinceLastUpdate = 0.0f;
//            }
//        }
//
//        Pass
//        {
//            CGPROGRAM
//            #include "UnityCustomRenderTexture.cginc"
//            #pragma vertex CustomRenderTextureVertexShader
//            #pragma fragment frag
//            #pragma target 3.0
//
//            sampler2D _DrawBrush;
//            float4 _DrawPosition;
//            float _DrawAngle;
//            float _RestoreAmount;
//            float _Offset;
//
//            float4 frag(v2f_customrendertexture IN) : COLOR
//            {
//                float4 previousColor = tex2D(_SelfTexture2D, IN.localTexcoord.xy);
//                float2 pos = IN.localTexcoord.xy - _DrawPosition;
//
//                float2x2 rot = float2x2(cos(_DrawAngle), -sin(_DrawAngle),
//                                        sin(_DrawAngle), cos(_DrawAngle));
//                pos = mul(rot, pos);
//                pos /= _Offset;
//                pos += float2(0.5, 0.5);
//
//                float4 drawColor = tex2D(_DrawBrush, pos);
//
//                // Update the heightmap texture
//                float4 heightmapColor = tex2D(_HeightMapTexture, IN.localTexcoord.xy);
//                heightmapColor.r -= _RestoreAmount * Time.deltaTime;
//                heightmapColor.r = max(0.0, heightmapColor.r);
//                RenderTexture.active = _HeightMapTexture;
//                GL.Begin(GL.QUADS);
//                GL.Color(heightmapColor);
//                GL.Vertex(IN.rect.min);
//                GL.Vertex(new float2(IN.rect.xMax, IN.rect.yMin));
//                GL.Vertex(IN.rect.max);
//                GL.Vertex(new float2(IN.rect.xMin, IN.rect.yMax));
//                GL.End();
//                RenderTexture.active = null;
//
//                // Return the result
//                return min(previousColor, drawColor);
//            }
//            ENDCG
//        }
//    }
//
//}