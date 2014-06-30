#extension GL_EXT_gpu_shader4 : enable

// Pass in the render target metrics as a uniform
uniform vec4 SMAA_RT_METRICS; // (1/w, 1/h, w, h)

#define SMAA_PRESET_ULTRA
#define SMAA_INCLUDE_VS 0
#define SMAA_GLSL // Custom compatibility profile, not available in original
#include "SMAA.h"

// Additional shader inputs
uniform sampler2D uEdgesTex;
uniform sampler2D uAreaTex;
uniform sampler2D uSearchTex;
varying float2    vPixcoord;
varying float4    vOffset[3];

void main()
{
	float2 texCoord = gl_TexCoord[0].st;
	float4 subsampleIndices = float4(0.0, 0.0, 0.0, 0.0);

	gl_FragColor = SMAABlendingWeightCalculationPS(texCoord, vPixcoord, vOffset, 
	   uEdgesTex, uAreaTex, uSearchTex, subsampleIndices);
}