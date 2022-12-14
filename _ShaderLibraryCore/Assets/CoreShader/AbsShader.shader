Shader "Unlit/AbsShader"
{
    Properties // ownDefined inputData    
    {
        _ColorStart ("ColorStart", Range(0,1)) = 0
        _ColorEnd ("ColorEnd", Range(0,1)) = 1
    }
    SubShader 
    {
        Tags { "RenderType"="Opaque" }
          
        Pass 
        {
            Cull Off
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
           
           float4 _ColorA;
           float4 _ColorB;

           float _ColorStart;
           float _ColorEnd;

            // automatically filled out by unity
            struct MeshData  // perVertex meshData     
            {  
                float4 vertex : POSITION; // vertexPosition   
                float3 normals : NORMAL; // normalDirection of a vertex     
                float4 uv0 : TEXCOORD0; // uv0 coordinates -> diffuse/normal map textures         
            };

            struct Interpolaters // v2f     
            {       
                float4 vertex : SV_POSITION; // clipSpacePosition of the vertex   
                float3 normal : TEXCOORD0;      
                float2 uv : TEXCOORD1; 
            };   

                                  

            Interpolaters vert (MeshData v)                                                          
            {
                Interpolaters o;
                o.vertex = UnityObjectToClipPos(v.vertex); // localSpace to clipSpace  
                o.normal = UnityObjectToWorldNormal(v.normals); // show normals of the object -> visualize normalDirections             
                o.uv = v.uv0; // passTrough;  
                return o;  
            }

            // define own function
            float InverseLerp(float a, float b, float v)
            {
                return(v-a)/(b-a);
            }

            // actual fragmentShader 
            float4 frag (Interpolaters i) : SV_Target
            {
                // blend between 2 colors based on the X UV coordinates with lerp 

                float t = abs(frac(i.uv.x * 5) * 2 - 1 );
                return t;

                float4 outColor = lerp(_ColorA, _ColorB, t);
                return outColor;
            }
            ENDCG 
        }
    }
}


