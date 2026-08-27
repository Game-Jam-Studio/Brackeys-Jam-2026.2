shader_type canvas_item;

// Health percentage from 0.0 (empty) to 1.0 (full)
uniform float fill_amount : hint_range(0.0, 1.0) = 0.75;

// Wave dynamics (taller crests, lower frequency, slow slosh)
uniform float wave_amplitude : hint_range(0.0, 0.1) = 0.038;
uniform float wave_frequency : hint_range(1.0, 10.0) = 2.8;
uniform float wave_speed : hint_range(0.1, 5.0) = 0.85;

// Colors
uniform vec4 crest_glow_color : source_color = vec4(0.92, 0.98, 0.65, 1.0); // Surface glow/rim
uniform vec4 body_color : source_color = vec4(0.62, 0.78, 0.22, 1.0);       // Mid liquid
uniform vec4 deep_color : source_color = vec4(0.32, 0.45, 0.08, 1.0);       // Bottom shadow
uniform vec4 back_wave_color : source_color = vec4(0.48, 0.65, 0.15, 0.75); // Deeper back layer

void fragment() {
	float water_line = 1.0 - fill_amount;
	
	// Primary wide, slow rolling foreground wave
	float front_wave = sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
	front_wave += sin(UV.x * (wave_frequency * 1.5) - TIME * (wave_speed * 0.7)) * (wave_amplitude * 0.4);
	float front_surface = water_line + front_wave;
	
	// Offset background wave for deep crest parallax
	float back_wave = cos((UV.x + 0.4) * (wave_frequency * 1.1) - TIME * (wave_speed * 0.5)) * (wave_amplitude * 0.85);
	float back_surface = water_line + back_wave - 0.015;

	vec4 final_color = vec4(0.0);
	
	// Draw back wave layer
	if (UV.y > back_surface) {
		final_color = back_wave_color;
	}
	
	// Draw front wave layer over top
	if (UV.y > front_surface) {
		float depth = UV.y - front_surface;
		float total_height = max(fill_amount, 0.001);
		float normalized_depth = clamp((UV.y - water_line) / total_height, 0.0, 1.0);
		
		// Vertical depth gradient
		vec4 base_mix = mix(body_color, deep_color, normalized_depth);
		
		// Soft glow along the peak crests
		float crest_intensity = exp(-depth * 40.0);
		
		// Interior lighting
		float center_glow = (1.0 - abs(UV.x - 0.5) * 1.4) * (1.0 - normalized_depth) * 0.25;
		
		final_color = mix(base_mix, crest_glow_color, clamp(crest_intensity + center_glow, 0.0, 1.0));
	}
	
	COLOR = final_color;
}