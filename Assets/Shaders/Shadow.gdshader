shader_type canvas_item;

// Parameters
uniform vec4 shadow_color : source_color;
uniform vec2 shadow_offset = vec2(30, -30);
uniform bool shadow_only = false; // Display only the shadow
uniform float opacity : hint_range(0,1);

void fragment() {
    // Original alpha value of the sprite
    float alpha = texture(TEXTURE, UV).a;

    // Calculate normalized offset
    vec2 normalized_offset = shadow_offset / vec2(textureSize(TEXTURE, 0));

    // Shadow alpha value
    float shadow_alpha = texture(TEXTURE, UV + normalized_offset).a;
	vec4 shadow = vec4(shadow_color.rgb, shadow_alpha * shadow_color.a);

	if(shadow_only) {
		COLOR = opacity * shadow;
	} else {
		vec4 color = texture(TEXTURE, UV);
    	COLOR = mix(color, shadow_color, opacity * max(shadow_alpha - color.a, 0.0));
	}
}