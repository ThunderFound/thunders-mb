#version 330 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;
uniform vec4 entityColor;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	vec4 baseColor = texture(gtexture, texcoord) * glcolor;
	baseColor.rgb = mix(baseColor.rgb, entityColor.rgb, entityColor.a);
	color = baseColor * texture(lightmap, lmcoord);
	if (color.a < alphaTestRef) {
		discard;
	}
}