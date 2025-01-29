Shader "Unlit/Shader1"
{
    Properties
    {
        _WaveAmp ("Wave Amplitude", Range(0,0.2) ) = 0.1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque" 
           }

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718            
            float _WaveAmp;
            
            sampler2D _Texture;
            struct MeshData{
                float4 vertex : POSITION; // vertex position
                float3 normals : NORMAL;
                float2 uv0 : TEXCOORD0; // uv coordinates
            };

            struct Interpolators{
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            float GetWave( float2 uv ) {
                
                float xOffset = cos( uv.x * TAU * 8 ) * 0.01;                
                float t = cos( (uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                t *= 1-uv.y;
                //float wave = cos((uv.y-_Time.y*0.1) * TAU * 5);
                return t;
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                v.vertex.y = GetWave( v.uv0 ) * _WaveAmp/100.0;



                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                //o.normal = v.normals;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target{
                return GetWave( i.uv );
            }
            ENDCG
        }
    }
}
