shader_type canvas_item;
uniform float onoff : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 tex_colour = texture(TEXTURE, UV);
	
	// - gray
	float gray = dot(tex_colour.rgb, vec3(0.0, 0.0, 0.0));
	vec3 gray_color = vec3(gray);
	
	// Blend between original and grayscale
    vec3 final_color = mix(tex_colour.rgb, gray_color, onoff);

    COLOR = vec4(final_color, tex_colour.a);
}