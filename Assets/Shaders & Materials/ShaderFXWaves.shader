Shader "Unlit/Shader1"
{
    Properties
    {
        _ColorA ("Color A", Color ) = (1,1,1,1)
        _ColorB ("Color B", Color ) = (1,1,1,1)
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque" 
            "Queue" = "Transparent"
           }

        Pass
        {
            Cull Off
            ZWrite Off
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;

            #define TAU 6.28318530718
            
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

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                //o.normal = v.normals;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target{
                float xOffset = cos( i.uv.x * TAU * 8 ) * 0.01;                
                float t = cos( (i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                t *= 1-i.uv.y;

                float topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves = t * topBottomRemover;
                float4 gradient = lerp( _ColorA, _ColorB, i.uv.y );

                return gradient * waves;
            }
            ENDCG
        }
    }
}
