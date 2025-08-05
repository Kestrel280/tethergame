shader_type canvas_item;

uniform float fillRatio : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR *= step(1.0 - fillRatio, pow(UV.y, 1.5));
	
	COLOR.rgb = step(0.999, fillRatio) * vec3((sin(TIME * 7.0) + 1.0) / 2.0, (cos(TIME * 6.4) + 1.0) / 2.0, 1.0)
	+ (1.0 - step(0.999, fillRatio)) * vec3(0.0, UV.y, 0.5);;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
