#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D colortex4;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

in vec2 texcoord;
layout(location = 0) out vec4 fragColor;

#define INFO 0 // [0]
#define MOTION_BLUR_INTENSITY 1.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define MOTION_BLUR_SAMPLES 12    // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]
#define BLUR_MAX_VELOCITY 0.05    // [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30]

#define DISABLE_HAND_BLUR 1       // [0 1]
#define DITHER_MODE 2             // [0 1 2]
#define USE_DEPTH_DILATION 1      // [0 1]

#define USE_DYNAMIC_SAMPLING 1    // [0 1]
#define MIN_SAMPLES 4             // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]
#define MAX_SAMPLES 24            // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32]

float ign(vec2 p) {
    return fract(52.9829189 * fract(0.06711056 * p.x + 0.00583715 * p.y));
}

float blueNoise() {
    ivec2 texelCoords = ivec2(gl_FragCoord.xy) & 255;
    return texelFetch(colortex4, texelCoords, 0).r;
}

void main() {
    float depth = texture(depthtex0, texcoord).r;
    vec3 color = texture(colortex0, texcoord).rgb;

    #if DISABLE_HAND_BLUR == 1
    if (depth < 0.56) {
        fragColor = vec4(color, 1.0);
        return;
    }
    #endif

    float dilatedDepth = depth;
    #if USE_DEPTH_DILATION == 1
    ivec2 texel = ivec2(gl_FragCoord.xy);
    dilatedDepth = min(dilatedDepth, texelFetch(depthtex0, texel + ivec2( 1,  0), 0).r);
    dilatedDepth = min(dilatedDepth, texelFetch(depthtex0, texel + ivec2(-1,  0), 0).r);
    dilatedDepth = min(dilatedDepth, texelFetch(depthtex0, texel + ivec2( 0,  1), 0).r);
    dilatedDepth = min(dilatedDepth, texelFetch(depthtex0, texel + ivec2( 0, -1), 0).r);
    #endif

    vec4 ndc = vec4(texcoord * 2.0 - 1.0, dilatedDepth * 2.0 - 1.0, 1.0);
    vec4 eye = gbufferProjectionInverse * ndc;
    eye /= eye.w;
    
    vec4 world = gbufferModelViewInverse * eye;
    
    world.xyz += cameraPosition - previousCameraPosition;
    
    vec4 prevEye = gbufferPreviousModelView * world;
    vec4 prevNdc = gbufferPreviousProjection * prevEye;
    prevNdc /= prevNdc.w;
    
    vec2 prevTexcoord = prevNdc.xy * 0.5 + 0.5;
    
    vec2 velocity = (texcoord - prevTexcoord) * MOTION_BLUR_INTENSITY;

    float velLength = length(velocity);
    if (velLength > BLUR_MAX_VELOCITY) {
        velocity *= (BLUR_MAX_VELOCITY / velLength);
        velLength = BLUR_MAX_VELOCITY;
    }

    if (velLength > 0.0001) {
        vec3 blurColor = vec3(0.0);
        float weightSum = 0.0;

        float jitter = 0.0;
        #if DITHER_MODE == 1
            jitter = ign(gl_FragCoord.xy);
        #elif DITHER_MODE == 2
            jitter = blueNoise();
        #endif

        int numSamples;
        #if USE_DYNAMIC_SAMPLING == 1
            float normalizedSpeed = velLength / BLUR_MAX_VELOCITY;
            numSamples = clamp(int(ceil(normalizedSpeed * float(MAX_SAMPLES))), MIN_SAMPLES, MAX_SAMPLES);
        #else
            numSamples = MOTION_BLUR_SAMPLES;
        #endif

        for (int i = 0; i < numSamples; ++i) {
            float t = (float(i) + jitter) / float(numSamples);
            float offset = t - 0.5;

            vec2 sampleCoord = clamp(texcoord + velocity * offset, 0.0, 1.0);

            if (sampleCoord.x < 0.0 || sampleCoord.x > 1.0 || sampleCoord.y < 0.0 || sampleCoord.y > 1.0) {
                continue; 
            }

            float w = 1.0 - abs(offset) * 2.0;
            w = max(w, 0.0);
            vec3 sampleColor = texture(colortex0, sampleCoord).rgb;

            //blurColor += sampleColor * w;
            //weightSum += w;
            blurColor += (sampleColor * sampleColor) * w; 
            weightSum += w;
        }

        if (weightSum > 0.0) {
            //color = blurColor / weightSum;
            color = sqrt(blurColor / weightSum);
        }
    }

    fragColor = vec4(color, 1.0);
}