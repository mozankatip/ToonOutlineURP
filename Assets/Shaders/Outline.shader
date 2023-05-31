Shader "mozan/Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}   // Texture property for the main texture
        [Space(20)]

        _Color ("Object Color", Color) = (1, 1, 1, 1)   // Color property for the object color
        [Space(20)]
        _OutColor ("Outline Color", Color) = (0, 0, 0, 1)   // Color property for the outline color
       
        [Space(10)]
        _OutThickness ("Outline Thickness", Range(0.0, 0.2)) = 0.1   // Range property for the outline thickness
        _OutFade ("Outline Fade", Range(0.0, 1.0)) = 1.0   // Range property for the outline fade
       
        [Space(10)]
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0   // Enum property for the ZTest
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Integer) = 1  // Enum property for cull mode
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalRenderPipeline"   // Tag specifying the render pipeline
            "Queue" = "Transparent"   // Tag specifying the rendering queue
        }
        
        // ................OUTLINE PASS.................
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

        // ................TEXTURE PASS.................
        // This pass renders the texture of the object without the outline effect.

        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"   // Tag specifying the light mode
            }

            Blend One OneMinusSrcAlpha   // Blending mode for the texture pass
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;


            // Vertex shader for the texture pass
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            // Fragment shader for the texture pass
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                // Multiply the texture with the object color.
                col *= _Color;
                return col;
            }
            ENDCG
        }
    }
}
