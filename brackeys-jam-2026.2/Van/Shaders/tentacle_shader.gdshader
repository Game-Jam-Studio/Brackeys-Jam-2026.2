shader_type spatial;
render_mode unshaded;
uniform sampler2D tentacles : source_color;
uniform float intensity;

void vertex() {
	// Called for every vertex the material is visible on.
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 uv = UV;
	uv.x += sin(uv.y * (10.0) + sin(TIME) * (0.75)) *  intensity/10.0;
	uv.y += sin(uv.x * (5.0) - TIME * (0.75)) *  intensity/20.0;
	vec3 color;
	color.r = texture(tentacles, uv).x * clamp(intensity, 0 ,1);
	ALBEDO = color;
	ALPHA = color.r;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
