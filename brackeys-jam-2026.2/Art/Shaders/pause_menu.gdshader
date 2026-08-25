shader_type canvas_item;

// Allows reading the rendered screen buffer behind this UI element
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
// Controls how strong the blur effect appears
uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;

void fragment() {
	// Sample the background screen texture using the specified blur mipmap level
	vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
	
	// Apply a slight dark tint over the blurred background for UI legibility
	COLOR = color * vec4(0.8, 0.8, 0.8, 1.0);
}