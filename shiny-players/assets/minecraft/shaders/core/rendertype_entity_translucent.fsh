#version 150

#moj_import <minecraft:fog.glsl>

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
	if (texelFetch(Sampler0, ivec2(56, 7), 0) == vec4(186.0 / 255.0, 36.0 / 255.0, 255.0 / 255.0, 1.0)) {
		for (int i = 0; i < 48; i++) {
			int x = 63 - (i % 8);
			int y = 1 + i / 8 + int(step(24, i));
			int iy = (i / 24) * 4;
			int takeColor = (i / 8) % 3;
			if(ogColor == texelFetch(Sampler0, ivec2(x, y), 0)) {
				vec4 intensityWithAlpha = texelFetch(Sampler0, ivec2(x, iy), 0);
				if (intensityWithAlpha.a < 0.1) continue;
				vec3 intensity = texelFetch(Sampler0, ivec2(x, iy), 0).rgb;
				color = mix(color, ogColor, intensity[takeColor]);
				break;
			}
		}
	}
	//custom end
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
