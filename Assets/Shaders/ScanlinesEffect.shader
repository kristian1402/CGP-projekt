Shader "Unlit/Scanlines" {
	//Shader properties defined at the start, used to change the values in the unity inspector
    Properties 
	{
         _MainTex("_Color", 2D) = "white" {}
         _LineWidth("Line Width", Float) = 4
         _Hardness("Hardness", Float) = 0.9
         _Speed("Speed", Range(0,1)) = 0.1
     }
	
     SubShader 
	 {
		//Tag Queue = Overlay specifies that this shader should be rendered as an overlay
         Tags {"Queue" = "Overlay"} 

         Pass {
         	Cull Off //Culling is turned off as the shader needs to be transparrent
         	ZWrite Off //Zwrite disabled as the shader needs to be transparrent
 
         CGPROGRAM
		//Defining the vertex and fragment functions 
 		 #pragma vertex vert
 		 #pragma fragment frag
		 //unityCG.cginc includes helpfull functions like UnityObjectToClipPos
 		 #include "UnityCG.cginc"
 
		//Vertex program outputs
	     struct v2f {
	         float4 pos      : POSITION;
	         float2 uv       : TEXCOORD0;
	         float4 scr_pos : TEXCOORD1;
	     };
	 	//Variables: Sampler2D is a color, floats are values defined in the properties
	     sampler2D _MainTex;
	     float _LineWidth;
	     float _Hardness;
	     float _Speed;
	 
	 	//Vertex program inputs
	     v2f vert(appdata_img v) {
	         v2f o;
	         o.pos = UnityObjectToClipPos(v.vertex);
	         o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
	         o.scr_pos = ComputeScreenPos(o.pos);
	         
	         return o;
	     }
	 	//Rendering 
	     half4 frag(v2f i) : COLOR {
	         half4 color = tex2D(_MainTex, i.uv);
	         fixed lineSize = _ScreenParams.y*0.005; //sets the size of the lines by taking the screens y value and multiplying it 
	         float displacement = ((_Time.y*1000)*_Speed)%_ScreenParams.y; //Moves the lines downward by using time and the variable speed
	         float ps = displacement+(i.scr_pos.y * _ScreenParams.y / i.scr_pos.w); //sets the shader at the center of the screen
			
			//Returns the shader
	         return ((int)(ps / floor(_LineWidth*lineSize)) % 2 == 0) ? color : color * float4(_Hardness,_Hardness,_Hardness,1);
	     }
	 
	     ENDCG
	     }
     }
 }