shader_type canvas_item;

uniform float star_timer : hint_range(0, 10); // Time since the star effect started
uniform float max_time = 10.0; // Total duration of star effect

void fragment() {
    vec4 original_color = texture(TEXTURE, UV); // Mario's normal color

    // If star effect is inactive, reset to original color
    if (star_timer <= 0.0) {
        COLOR = original_color;
    } else {
        // Define the rainbow colors
	    vec4 color_list[6] = vec4[](
	        vec4(1.0, 0.0, 0.0, 1.0),  // Red
	        vec4(1.0, 0.5, 0.0, 1.0),  // Orange
	        vec4(0.0, 1.0, 0.0, 1.0),  // Green
	        vec4(0.0, 0.0, 1.0, 1.0),  // Blue
	        vec4(0.3, 0.0, 0.5, 1.0),  // Indigo
	        vec4(0.6, 0.0, 0.6, 1.0)   // Violet
	    );
		//vec4(1.0, 1.0, 0.0, 1.0),  // Yellow
		
	    // Slow down effect **smoothly** using a logarithmic function
	    float progress = star_timer / max_time;
	    float slowdown_factor = log(1.0 + (progress * 9.0)) / log(10.0); // Smooth curve

	    float t = fract(TIME * (3.0 - (2.8 * slowdown_factor))); // Controls blink speed
	    int index = int(t * 6.0) % 6; // Ensure it stays in range

	    vec4 new_color = color_list[index]; // Get current rainbow color
	    COLOR = new_color * original_color; // Apply color effect
    }
}
