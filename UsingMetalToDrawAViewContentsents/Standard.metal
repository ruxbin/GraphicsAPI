//
//  Standard.metal
//  MetalKitAndRenderingSetup-iOS
//
//  Created by ruxpinjiang on 2021/10/29.
//  Copyright © 2021 Apple. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct VertexWithAttribute
{
    float3 pos [[attribute(0)]];
    float3 norml [[attribute(1)]];
    float2 uv [[attribute(2)]];
}VertexWithAttribute;

struct SimplePipelineRasterizerData
{
    float4 position [[position]];
    float4 color;
};

typedef struct CameraParam
{
    float4x4 projectionMatrix;
    float4x4 objectToCameraMatrix;
}CameraParam;


// Vertex shader which passes position and color through to rasterizer.
vertex SimplePipelineRasterizerData
simpleVertexShader( VertexWithAttribute vertexIn [[ stage_in ]],constant CameraParam& cam[[buffer(1)]])
{
    SimplePipelineRasterizerData out;

    //out.position.xyz = vertexIn.pos;
    //out.position.w = 1;

    float4x4 finalMatrix = cam.objectToCameraMatrix * cam.projectionMatrix;
    out.position = float4(vertexIn.pos,1) * finalMatrix;
    out.color = float4(1);

    return out;
}

// Fragment shader that just outputs color passed from rasterizer.
fragment float4 simpleFragmentShader(SimplePipelineRasterizerData in [[stage_in]])
{
    return in.color;
}
