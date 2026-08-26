shader_type spatial;


void vertex() {
	VERTEX = NORMAL * (sin(TIME * 16.0 - 1.5) + 1.0) / 2.0 * float(bool((clamp(cos(TIME * 4.0), 0, 1)))) * (sin(TIME * 3.42123) + 2.0) / 20.0 + NORMAL * 0.5;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
