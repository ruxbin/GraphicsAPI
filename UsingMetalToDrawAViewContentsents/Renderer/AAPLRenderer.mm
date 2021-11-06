/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of a platform independent renderer class, which performs Metal setup and per frame rendering
*/

@import simd;
@import MetalKit;

#import "AAPLRenderer.h"

#include "ObjLoader.h"

// Main class performing the rendering
@implementation AAPLRenderer
{
    id<MTLDevice> _device;

    // The command queue used to pass commands to the device.
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLBuffer> _vertexBuffer;
    
    id<MTLRenderPipelineState> _pipelineState;
    
}


- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    NSError* error = nil;
    if(self)
    {
        _device = mtkView.device;

        // Create the command queue
        _commandQueue = [_device newCommandQueue];
        
        // Create all sorts of resource here
        _vertexBuffer = [_device newBufferWithBytes:getRawVertexData() length:getVertexSize() options:MTLResourceStorageModeShared];
        MTLVertexDescriptor * vd = [MTLVertexDescriptor vertexDescriptor];
        vd.attributes[0].format = MTLVertexFormatFloat3;
        vd.attributes[0].offset = 0;
        vd.attributes[0].bufferIndex = 0;
        
        vd.attributes[1].format = MTLVertexFormatFloat3;
        vd.attributes[1].offset = sizeof(float)*3;
        vd.attributes[1].bufferIndex = 0;
        
        vd.attributes[1].format = MTLVertexFormatFloat2;
        vd.attributes[1].offset = sizeof(float)*3*2;
        vd.attributes[1].bufferIndex = 0;
        
        vd.layouts[0].stepFunction =  MTLVertexStepFunctionPerVertex;//default
        vd.layouts[0].stepRate = 1;//default
        vd.layouts[0].stride = sizeof(float)*3*2+sizeof(float)*2;
        ///
        MTLRenderPipelineDescriptor* pipeDesc = [[MTLRenderPipelineDescriptor alloc] init];
        //pipeDesc.vertexFunction =;
        //pipeDesc.fragmentFunction =;
        pipeDesc.vertexDescriptor = vd;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipeDesc error:&error];
        
    }

    return self;
}


/// Called whenever the view needs to render a frame.
- (void)drawInMTKView:(nonnull MTKView *)view
{
    // The render pass descriptor references the texture into which Metal should draw
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor == nil)
    {
        return;
    }

    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // Create a render pass and immediately end encoding, causing the drawable to be cleared
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    //[commandEncoder setRenderPipelineState:<#(nonnull id<MTLRenderPipelineState>)#>]
    
    [commandEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    
    
    [commandEncoder endEncoding];
    
    // Get the drawable that will be presented at the end of the frame

    id<MTLDrawable> drawable = view.currentDrawable;

    // Request that the drawable texture be presented by the windowing system once drawing is done
    [commandBuffer presentDrawable:drawable];
    
    [commandBuffer commit];
}


/// Called whenever view changes orientation or is resized
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
}

@end
