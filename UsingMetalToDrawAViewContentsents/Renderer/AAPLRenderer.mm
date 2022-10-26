/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of a platform independent renderer class, which performs Metal setup and per frame rendering
*/

@import simd;
@import MetalKit;

#import "AAPLRenderer.h"

#include "ObjLoader.h"

#include "Camera.hpp"

// Main class performing the rendering
@implementation AAPLRenderer
{
    id<MTLDevice> _device;

    // The command queue used to pass commands to the device.
    id<MTLCommandQueue> _commandQueue;
    
    id<MTLBuffer> _vertexBuffer;
    id<MTLBuffer> _indexBuffer;
    
    id<MTLBuffer> _cameraBuffer;
    
    id<MTLRenderPipelineState> _pipelineState;
    
    Camera * _camera;
    
    MTLCaptureManager* _captureManager;
    
    bool _captured;
    
}


- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    NSError* error = nil;
    //Camera(float fov,float n ,float f, vec3 origin,float aspect)
    float aspectratio = mtkView.drawableSize.width/mtkView.drawableSize.height;
    _camera = new Camera(60*3.1414926f/180.f,0.1,20,vec3(0,0,-15),aspectratio);
    if(self)
    {
        _device = mtkView.device;
        
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];

        // Create the command queue
        _commandQueue = [_device newCommandQueue];
        
        // Create all sorts of resource here
        _vertexBuffer = [_device newBufferWithBytes:getRawVertexData() length:getVertexSize() options:MTLResourceStorageModeShared];
        _indexBuffer = [_device newBufferWithBytes:getRawIndexData() length:getIndexSize() options:MTLResourceStorageModeShared];
        _cameraBuffer = [_device newBufferWithLength:sizeof(Camera) options:MTLResourceStorageModeShared];
        MTLVertexDescriptor * vd = [MTLVertexDescriptor vertexDescriptor];
        vd.attributes[0].format = MTLVertexFormatFloat3;
        vd.attributes[0].offset = 0;
        vd.attributes[0].bufferIndex = 0;
        
        vd.attributes[1].format = MTLVertexFormatFloat3;
        vd.attributes[1].offset = sizeof(float)*3;
        vd.attributes[1].bufferIndex = 0;
        
        vd.attributes[2].format = MTLVertexFormatFloat2;
        vd.attributes[2].offset = sizeof(float)*3*2;
        vd.attributes[2].bufferIndex = 0;
        
        vd.layouts[0].stepFunction =  MTLVertexStepFunctionPerVertex;//default
        vd.layouts[0].stepRate = 1;//default
        vd.layouts[0].stride = sizeof(float)*3*2+sizeof(float)*2;
        ///
        MTLRenderPipelineDescriptor* pipeDesc = [[MTLRenderPipelineDescriptor alloc] init];
        pipeDesc.vertexFunction = [defaultLibrary newFunctionWithName:@"simpleVertexShader"];;
        pipeDesc.fragmentFunction = [defaultLibrary newFunctionWithName:@"simpleFragmentShader"];;
        pipeDesc.vertexDescriptor = vd;
        pipeDesc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipeDesc error:&error];
        
        _captureManager = [MTLCaptureManager sharedCaptureManager];
        
        if (![_captureManager supportsDestination: MTLCaptureDestinationGPUTraceDocument])
        {
            NSLog(@"Capture to a GPU trace file is not supported");
        }

        
        
        _captured = false;
        
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

   
    
    if(!_captured)
    {
        MTLCaptureDescriptor* captureDescriptor = [[MTLCaptureDescriptor alloc] init];
        captureDescriptor.captureObject = _device;
        captureDescriptor.destination = MTLCaptureDestinationGPUTraceDocument;
        captureDescriptor.outputURL = [NSURL URLWithString:@"capture.gputrace" relativeToURL:[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask ] lastObject]];
        NSError *error;
        if (![_captureManager startCaptureWithDescriptor: captureDescriptor error:&error])
        {
                NSLog(@"Failed to start capture, error %@", error);
        }
    }
    
    //set camera params
    memcpy([_cameraBuffer contents],_camera->getProjectionMatrixData(),sizeof(mat4));
    memcpy((char*)[_cameraBuffer contents]+sizeof(mat4),_camera->getObjectToCameraData(),sizeof(mat4));

    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // Create a render pass and immediately end encoding, causing the drawable to be cleared
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    [commandEncoder setRenderPipelineState:_pipelineState];
    [commandEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [commandEncoder setVertexBuffer:_cameraBuffer offset:0 atIndex:1];
    [commandEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:getIndexSize()/sizeof(unsigned short) indexType:MTLIndexTypeUInt16 indexBuffer:_indexBuffer indexBufferOffset:0];
    
    [commandEncoder endEncoding];
    
    // Get the drawable that will be presented at the end of the frame

    id<MTLDrawable> drawable = view.currentDrawable;

    // Request that the drawable texture be presented by the windowing system once drawing is done
    [commandBuffer presentDrawable:drawable];
    
    [commandBuffer commit];
    if(!_captured)
    {
        [_captureManager stopCapture];
        _captured = true;
    }
    
}


/// Called whenever view changes orientation or is resized
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
}

@end
