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

            #include "UnityCG.cginc"
            #define UNITY_INDIRECT_DRAW_ARGS IndirectDrawIndexedArgs
            #include "UnityIndirect.cginc"
            #include "Assets/Scripts/BeesGPUSystrem.cs.hlsl"

            StructuredBuffer<BeeData> _Bees;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
            };

            // We can still optimize the input assembly stage by using primitive indirect draw instead
            v2f vert(appdata_base v, uint svInstanceID : SV_InstanceID)
            {
                InitIndirectDrawArgs(0);
                BeeData bee = _Bees[svInstanceID];
                v2f o;
                uint cmdID = GetCommandID(0);
                uint instanceID = GetIndirectInstanceID(svInstanceID);
                // float4 wpos = v.vertex + float4(instanceID, cmdID, 0, 0);
                float4 wpos = v.vertex + float4(bee.position, 0);
                o.pos = mul(UNITY_MATRIX_VP, wpos);
                o.color = bee.teamIndex == 0 ? team0Color : team1Color; // TODO: team color
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
