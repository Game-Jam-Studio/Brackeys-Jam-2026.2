shader_type spatial;
uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 Color;
	//NORMAL = texture(noise, UV * (texture(noise, UV).xy) * 10.0).xyz;
	Color.r = texture(noise, UV - TIME / 100.0).x + texture(noise, UV * 2.0 + TIME / 50.0).y - texture(noise, UV + 10.0).x * 1.0;
	Color.g = 0.0;
	Color.b = 0.0;
	ALBEDO = Color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
