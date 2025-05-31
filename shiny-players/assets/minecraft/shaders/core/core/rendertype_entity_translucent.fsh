#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
	vec4 ogColor = color;
    color *= vertexColor * ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= lightMapColor;
	//custom start
	if (texelFetch(Sampler0, ivec2(56, 7), 0) == vec4(186.0 / 255.0, 37.0 / 255.0, 255.0 / 255.0, 1.0)) { // BA25FF
		for (int i = 0; i < 63; i++) {
			int x = 63 - (i % 8);
			int y = i / 8;
			vec4 fetch = texelFetch(Sampler0, ivec2(x, y), 0);
			if(fetch.a > 0.0 && ogColor.rgb == fetch.rgb) {
				color = mix(color, ogColor, fetch.a);
				break;
			}
		}
	}
	//custom end
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
