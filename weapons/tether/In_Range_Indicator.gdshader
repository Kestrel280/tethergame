shader_type canvas_item;

void vertex() {
	VERTEX -= 0.5 / TEXTURE_PIXEL_SIZE;
	VERTEX = mat2(vec2(cos(TIME), -sin(TIME)), vec2(sin(TIME), cos(TIME))) * VERTEX;
	VERTEX += 0.5 / TEXTURE_PIXEL_SIZE;
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.r = UV.x;
	COLOR.g = 1.0 - UV.x;
	COLOR.b = UV.y;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
