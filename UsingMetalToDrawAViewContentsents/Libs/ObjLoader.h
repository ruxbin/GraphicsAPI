//
//  ObjLoader.h
//  MetalKitAndRenderingSetup-iOS
//
//  Created by ruxpinjiang on 2021/10/29.
//  Copyright © 2021 Apple. All rights reserved.
//

#ifndef ObjLoader_h
#define ObjLoader_h

#if defined __cplusplus
extern "C"{

#endif

void LoadObj(const char * filepath);

unsigned long getVertexSize();

void * getRawVertexData();

#if defined __cplusplus
}
#endif

#endif /* ObjLoader_h */
