Shader "IndirectUnlitBee"
{
    SubShader
    {
        Pass
        {
            ZWrite On
            ZTest LEqual

            // Double sided
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // #pragma enable_d3d11_debug_symbols

            #include "UnityCG.cginc"
            #define UNITY_INDIRECT_DRAW_ARGS IndirectDrawIndexedArgs
            #include "UnityIndirect.cginc"
            #include "Assets/Shaders/BeesCommon.hlsl"

            StructuredBuffer<PackedBeeData> _Bees;
            uint _StartInstance;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            struct VertexAttributes
            {
                float4 position : POSITION;
                float3 color : COLOR;
            };

            half3x3 lookAtPoint(half3 fwd)
            {
                half3 localUp = half3(0, 1, 0); 
                half3 right = normalize(cross(localUp, fwd));
                // Safeguard against degenerate cases (fwd == localUp or -fwd == localUp)
                if (any(isnan(right)))
                    return half3x3(1, 0, 0, 0, 1, 0, 0, 0, 1);
                half3 up = normalize(cross(fwd, right));

                return half3x3(fwd, up, right);
            }

            // We can still optimize the input assembly stage by using primitive indirect draw instead
            v2f vert(VertexAttributes v, uint instanceID : SV_InstanceID)
            {
                InitIndirectDrawArgs(0);
                PackedBeeData bee = _Bees[instanceID + _StartInstance];

                half3 beePosition;
                half3 beeVelocity;
                UnpackPositionAndVelocity(bee.packedBeeData.xyz, beePosition, beeVelocity);

                // affect size with velocity for nicer effect:
                half3 safeVelocity = any(abs(beeVelocity) > 0.001) ? normalize(beeVelocity) : half3(0, 0, 1);
                half halfV = abs(safeVelocity.x) * 0.5;
                half4 wpos = v.position * half4(1 + halfV, 1 - halfV, 1, 1);
                
                wpos = half4(mul(lookAtPoint(safeVelocity), wpos), 1); // rotate quad towards velocity
                wpos += half4(beePosition, 0);

                v2f o;
                o.pos = mul(UNITY_MATRIX_VP, float4(wpos));
                o.color = float4(v.color, 1);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }
    }
}
