shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float radius : hint_range(0, 10);
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain
uniform bool animate = false;
uniform float abberation : hint_range(0, 1, 0.001);

uniform bool blur = true;
uniform bool grain = true;
uniform bool chromatic_abberation = true;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 color = vec4(0.0);
	float total = 0.0;

	// Chromatic Abberation

	if (chromatic_abberation){
		vec2 abberation_vec = vec2(abberation, 0.0);
		vec4 red = texture(screen_texture, SCREEN_UV - abberation_vec);
		vec4 green = texture(screen_texture, SCREEN_UV + abberation_vec);
		vec4 blue = texture(screen_texture, SCREEN_UV);

		color = vec4(red.r, green.g, blue.b, blue.a) * 1.0;
		if (!blur){
			color = blue * 0.9 + color * 0.1;
		}
		total += 1.0;
	}

	// Blur

	if (blur){
		for (float x = -radius; x <= radius; x++) {
			for (float y = -radius; y <= radius; y++) {
				float weight = exp(-(x*x + y*y) / (2.0 * radius * radius));
				color += texture(screen_texture, uv + vec2(x, y) * SCREEN_PIXEL_SIZE) * weight;
				total += weight;
			}
		}
	}

	color /= total;

	// Film Grain

	if (grain){

		float noise = 0.0;

		if (animate) {
			// Generate random noise
			noise = (fract(sin(dot(UV * TIME, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
		} else {
			 noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
		}
		// Add noise to the original color
		color.rgb += noise * grain_amount * grain_size;

		// Clamp the final color to make sure it stays in the valid range
		color = clamp(color, 0.0, 1.0);
	}



	COLOR = color;
}