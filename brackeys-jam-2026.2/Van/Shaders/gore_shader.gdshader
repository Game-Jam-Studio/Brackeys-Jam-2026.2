shader_type spatial;
uniform float displacement;
uniform sampler2D displacementnoise;
uniform sampler2D roughnessnoise;
uniform sampler2D colornoise;
uniform sampler2D normalmap;


void vertex() {
	VERTEX += NORMAL * ((sin(TIME / 3.0) + 2.0) / 1.0 * displacement) * texture(displacementnoise, UV + (sin(TIME/10.0)) / 2.0).xyz;
}

void fragment() {
	NORMAL_MAP = texture(normalmap, UV + (sin(TIME/10.0)*0.5)).xyz;
	ALBEDO = texture(colornoise, UV + (sin(TIME/10.0)*0.5)).xyz;
	ROUGHNESS = texture(roughnessnoise, UV + (sin(TIME/10.0)*0.5)).x;
}
