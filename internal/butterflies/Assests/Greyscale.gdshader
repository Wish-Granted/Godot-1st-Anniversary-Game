shader_type canvas_item;

void fragment() {
	vec4 tex_colour = texture(TEXTURE, UV);
	
	// - gray
	//float black = tex_colour.r * 0.299 + tex_colour.g * 0.587 + tex_colour.b * 0.114;
	// - black
	float black = tex_colour.r * 0.0 + tex_colour.g * 0.0 + tex_colour.b * 0.0;
	COLOR = vec4(vec3(black), tex_colour.a);
}