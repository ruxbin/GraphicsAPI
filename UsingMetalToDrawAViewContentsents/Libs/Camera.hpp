//
//  Camera.hpp
//  MetalKitAndRenderingSetup-iOS
//
//  Created by ruxpinjiang on 2021/11/6.
//  Copyright © 2021 Apple. All rights reserved.
//

#ifndef Camera_hpp
#define Camera_hpp

#include <stdio.h>
#include "Matrix.h"

class Camera
{
private:
    mat4 _projectionMatrix;
    mat4 _objectToCameraMatrix;
    Camera();
public:
    Camera(float fov,float n ,float f, vec3 origin,float aspect);
    void * getProjectionMatrixData();
    void * getObjectToCameraData();
    mat4 & getObjectToCamera();
};

#endif /* Camera_hpp */
