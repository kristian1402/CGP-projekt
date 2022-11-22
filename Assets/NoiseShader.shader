Shader "NoiseShader" {
    Properties {
        _MainColor ("background Color", Color) = (1,1,1,0) 
        _MaskTex ("Mask texture", 2D) = "white" {}
        _maskBlend ("Mask blending", Range(0.0, 1.0)) = 0.5
        _maskSize ("Mask Size", Range(1.0, 5.0)) = 1
    }
    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        
        ZWrite Off
        Lighting Off
        Fog { Mode Off }

        Blend SrcAlpha OneMinusSrcAlpha
         
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"
        
            uniform float4 _MainColor;
            uniform sampler2D _MaskTex;

            fixed _maskBlend;
            fixed _maskSize;
            fixed4 frag (v2f_img i) : COLOR {
                fixed4 base = _MainColor;
                fixed4 mask = tex2D(_MaskTex, i.uv * _maskSize);
                return lerp(base, mask, _maskBlend);
            }
            ENDCG
        }
    }
}