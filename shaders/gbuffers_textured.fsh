#version 330 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;
uniform vec4 entityColor;
uniform mat4 gbufferModelViewInverse; 

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;
in vec3 normal;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

#define USE_DIRECTIONAL_SHADING 1 // [0 1]

void main() {
    vec4 baseColor = texture(gtexture, texcoord) * glcolor;
    
    float directionalShading = 1.0;

    #if USE_DIRECTIONAL_SHADING == 1
    vec3 worldNormal = normalize(mat3(gbufferModelViewInverse) * normal);
    
    if (worldNormal.y > 0.5) {
        directionalShading = 1.0;
    } else if (worldNormal.y < -0.5) {
        directionalShading = 0.5;
    } else if (abs(worldNormal.z) > 0.5) {
        directionalShading = 0.8;
    } else if (abs(worldNormal.x) > 0.5) {
        directionalShading = 0.6;
    }
    #endif
    
    baseColor.rgb *= directionalShading;
    baseColor.rgb = mix(baseColor.rgb, entityColor.rgb, entityColor.a);
    color = baseColor * texture(lightmap, lmcoord);
    if (color.a < alphaTestRef) {
        discard;
    }
}