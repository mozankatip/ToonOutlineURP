Shader "mozan/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} 
        [Space(20)]

        [Header(OUTLINE SETTINGS)]
        [Space(10)]
        _OutColor ("Outline Color", Color) = (0,0,0,1)  
       
        [Space(10)]
        _OutThickness ("Outline Thickness", Range(0.0, 0.2)) = 0.1  
        _OutFade ("Outline Fade", Range(0.0, 1.0)) = 1.0   
       
        [Space(10)]
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0   
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Integer) = 1 
        
        [Space(20)]

        [Header(LIGHT SETTINGS)]
        [Space(10)]
        _Brightness("Brightness", Range(0.0, 1.0)) = 0.1
        _Strength("Tint Strength", Range(0.0, 1.0)) = 0.5
        _TintCol("Tint Color", Color) = (1,1,1,1)
        _Ramp("Ramp", Range(0.0, 1.0)) = 0.3
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalRenderPipeline"
            "Queue" = "Transparent"   // Tag specifying the rendering queue
        }
        
        // OUTLINE PASS
        // This pass is responsible for rendering the outline effect.

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha   // Blending mode for the outline pass
            ZWrite Off   // Disable depth writing for the outline pass
            Cull [_Cull]   // Set the cull mode based on the _Cull property
            
            ZTest [_ZTest]   // Set the ZTest mode based on the _ZTest property

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
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _OutColor;
            float _OutThickness;
            float _OutFade;

            // Vertex shader for the outline pass
            v2f vert(appdata v)
            {
                v2f o;
                float3 vertexPos = v.vertex.xyz;
                float3 surfaceNormal = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz);
                
                // Use a consistent normal for inflation
                float3 inflatedPos = vertexPos + _OutThickness * normalize(vertexPos - float3(0, 0, 0)); 

                o.vertex = UnityObjectToClipPos(float4(inflatedPos, 1));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = surfaceNormal;
                return o;
            }

            // Fragment shader for the outline pass
            fixed4 frag(v2f i) : SV_Target
            {
                // Calculate the outline color with fade
                fixed4 outlineColor = float4(_OutColor.rgb, _OutColor.a * _OutFade);
                return outlineColor;
            }
            ENDCG
        }

        // TEXTURE PASS
        // This pass renders the texture of the object without the outline effect.

        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"  // Tag specifying the light mode, and also it is workaround for using multi-pass in URP
            }

            Blend One Zero   // Blending mode for the texture pass
            ZWrite On   // Enable depth writing for the texture pass
            Cull Off   // Disable culling

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
                half3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Brightness;
            float _Strength;
            float4 _TintCol;
            float _Ramp;

            float Toon(float3 normal, float3 lightDir)
            {
                float NdotL = max(0.0,dot(normalize(normal), normalize(lightDir)));
                return floor(NdotL / _Ramp);
            }


            // Vertex shader for the texture pass
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            // Fragment shader for the texture pass
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                col *= Toon(i.worldNormal, _WorldSpaceLightPos0.xyz)*_Strength*_TintCol +_Brightness;
                return col;
            }
            ENDCG
        }

        // SHADOW PASS
   
        Pass
        {
            Tags 
            { 
                "LightMode" = "ShadowCaster" 
            }
    
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"
    
            struct v2f 
            { 
                V2F_SHADOW_CASTER;
            };
    
            v2f vert(appdata_base v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
    
            float4 frag(v2f i) : COLOR
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
