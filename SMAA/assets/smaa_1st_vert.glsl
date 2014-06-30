#extension GL_EXT_gpu_shader4 : enable

// Pass in the render target metrics as a uniform
uniform vec4 SMAA_RT_METRICS; // (1/w, 1/h, w, h)

#define SMAA_PRESET_ULTRA
#define SMAA_INCLUDE_PS 0
#define SMAA_GLSL // Custom compatibility profile, not available in original
#include "SMAA.h"

// Shader outputs
varying float4 vOffset[3];

void main()
{
	float2 texCoord = gl_MultiTexCoord0.st;
	
	// Somehow calling "SMAAEdgeDetectionVS(texCoord, vOffset);" did not work :(
	vOffset[0] = mad(SMAA_RT_METRICS.xyxy, float4(-1.0, 0.0, 0.0, -1.0), texCoord.xyxy);
	vOffset[1] = mad(SMAA_RT_METRICS.xyxy, float4( 1.0, 0.0, 0.0,  1.0), texCoord.xyxy);
	vOffset[2] = mad(SMAA_RT_METRICS.xyxy, float4(-2.0, 0.0, 0.0, -2.0), texCoord.xyxy);

	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();
}