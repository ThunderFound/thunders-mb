#version 330 compatibility

uniform sampler2D gtexture;
uniform vec4 entityColor;

in vec2 texcoord;
in vec4 glcolor;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture(gtexture, texcoord) * glcolor;

    if (color.a < 0.1) discard;
    color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);

    fragColor = color;
}