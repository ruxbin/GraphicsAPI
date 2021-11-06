//
//  Camera.cpp
//  MetalKitAndRenderingSetup-iOS
//
//  Created by ruxpinjiang on 2021/11/6.
//  Copyright © 2021 Apple. All rights reserved.
//

#include "Camera.hpp"

void* Camera::getProjectionMatrixData()
{
    return _projectionMatrix.value_ptr();
}

void* Camera::getObjectToCameraData()
{
    return _objectToCameraMatrix.value_ptr();
}


Camera::Camera(float fov,float n ,float f, vec3 origin,float aspect)
{
    mat4 trans = translate(-origin.x,-origin.y,-origin.z);
    mat4 proj = perspective(fov, aspect, n, f);
}
