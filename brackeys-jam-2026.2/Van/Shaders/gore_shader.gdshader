shader_type spatial;
uniform float displacement;
uniform sampler2D noise;
uniform sampler2D normalmap;


void vertex() {
	VERTEX += NORMAL * ((sin(TIME / 3.0) + 2.0) / 1.0 * displacement) * texture(noise, UV + (sin(TIME/10.0)) / 2.0).xyz;
}

void fragment() {
	NORMAL_MAP = texture(normalmap, UV + (sin(TIME/10.0)*0.5)).xyz;
	ALBEDO = vec3(0.25, 0.0, 0.0);
	ROUGHNESS = texture(noise, UV + (sin(TIME/10.0)*0.5)).x;
}
