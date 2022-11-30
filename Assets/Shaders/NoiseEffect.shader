Shader "Unlit/NoiseEffect" {

    Properties
    {
        _MainTex ("Texture", 2D) = "White" {}
        _Hardness("Hardness", Float) = 0.9
        _speed("Speed", Range(0,1)) = 0.1
    }

    SubShader
    {
        Tags {"Queue" = "Overlay"}

        Pass
        {
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float4 scr_pos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float _Hardness;
	        float _Speed;

            v2f vert (appdata_img v)
            {
                v2f o;
	            o.pos = UnityObjectToClipPos(v.vertex);
	            o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
	            o.scr_pos = ComputeScreenPos(o.pos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 color = tex2D(_MainTex, i.uv);
                float displacement = ((_Time.y*1000)*_Speed)%_ScreenParams.y; //Moves the lines downward by using time and the variable speed
	            float ps = displacement+(i.scr_pos.y * _ScreenParams.y / i.scr_pos.w); //sets the shader at the center of the screen
                //return((int)(ps % 2 == 0) ? color : color * float4(_Hardness,_Hardness,_Hardness,1));
                return(color*ps);
            }
            ENDCG
        }
    }
}
