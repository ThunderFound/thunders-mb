#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

in vec2 texcoord;
layout(location = 0) out vec4 fragColor;

#define MOTION_BLUR_INTENSITY 1.0 // [0.2 0.5 0.8 1.0 1.5 2.0]
#define MOTION_BLUR_SAMPLES 12     // [4 8 12 16 20 32]
#define BLUR_MAX_VELOCITY 0.05    // [0.01 0.03 0.05 0.10 0.15]
#define NOISE_AMOUNT 0.5          // [0.0 0.1 0.3 0.5 0.8 1.0]
#define DISABLE_HAND_BLUR 1       // [0 1]

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    float depth = texture(depthtex0, texcoord).r;
    vec3 color = texture(colortex0, texcoord).rgb;

    vec4 ndc = vec4(texcoord * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    vec4 eye = gbufferProjectionInverse * ndc;
    eye /= eye.w;
    
    vec4 world = gbufferModelViewInverse * eye;
    
    world.xyz += cameraPosition - previousCameraPosition;
    
    vec4 prevEye = gbufferPreviousModelView * world;
    vec4 prevNdc = gbufferPreviousProjection * prevEye;
    prevNdc /= prevNdc.w;
    
    vec2 prevTexcoord = prevNdc.xy * 0.5 + 0.5;
    
    vec2 velocity = (texcoord - prevTexcoord) * MOTION_BLUR_INTENSITY;

    #if DISABLE_HAND_BLUR == 1
    if (depth < 0.56) {
        velocity *= 0.05; 
    }
    #endif

    if (length(velocity) > BLUR_MAX_VELOCITY) {
        velocity = normalize(velocity) * BLUR_MAX_VELOCITY;
    }

    if (length(velocity) > 0.0001) {
        float dither = (rand(texcoord) - 0.5) * NOISE_AMOUNT;

        vec3 blurColor = vec3(0.0);
        float weightSum = 0.0;
        
        for (int i = 0; i < MOTION_BLUR_SAMPLES; ++i) {
            float offset = (float(i) + dither) / float(MOTION_BLUR_SAMPLES - 1) - 0.5;
            vec2 sampleCoord = texcoord + velocity * offset;
            
            if (sampleCoord.x >= 0.0 && sampleCoord.x <= 1.0 && 
                sampleCoord.y >= 0.0 && sampleCoord.y <= 1.0) {
                
                blurColor += texture(colortex0, sampleCoord).rgb;
                weightSum += 1.0;
            }
        }
        
        if (weightSum > 0.0) {
            color = blurColor / weightSum;
        }
    }

    fragColor = vec4(color, 1.0);
}