Shader "Unlit/GoldShader"
{
    Properties
    {
        _MainTex ("Texture", Cube) = "white" {}
        _Tint ("Tint Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 reflection : TEXCOORD1;
            };

            samplerCUBE _MainTex;
            float4 _Tint;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                // Direction of ray from camera
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldView = normalize(UnityWorldSpaceViewDir(worldPos));

                // Direction of the face of the object
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);

                o.reflection = reflect(-worldView, worldNormal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = texCUBE(_MainTex, i.reflection);
                return col * _Tint;
            }
            ENDCG
        }
    }
}
