shader_type canvas_item;

uniform bool hit_flash = false;
uniform bool shield = false;
uniform bool disintagrate = false;

uniform float white_progress : hint_range(0,1) = 0;

group_uniforms shield;
// The color that flashes when highlighting the sprite
uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Used to control the time between flashes
uniform float frequency : hint_range(0.0, 25.0) = 0.35;

// Speed of each flash
uniform float highlight_speed : hint_range(0.0, 25.0) = 6.0;

// How much area each flash covers (width)
uniform float highlight_width : hint_range(0.0, 50.0) = 15.0;

// Disintagrate
// --- Uniforms --- //
group_uniforms burn;
uniform float percentage: hint_range(0.0, 1.0, 0.01) = 1.0;

uniform sampler2D burn_texture;
group_uniforms layer_1;
uniform vec4 layer_1: source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform float size_1 = 0.05;
group_uniforms layer_2;
uniform vec4 layer_2: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float size_2 = 0.05;
group_uniforms layer_3;
uniform vec4 layer_3: source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float size_3 = 0.05;

vec3 interpolate_vec3(vec3 start, vec3 end, float delta){
	return start + (end - start) * delta;
}

void fragment(){
	vec4 input_color = texture(TEXTURE, UV);
	vec4 origin = input_color.rbga;
	COLOR = origin;
	
	if (hit_flash) {
		COLOR.rgb = interpolate_vec3(origin.rgb, vec3(1,1,1), white_progress);
		COLOR.a = origin.a;
	}
	if (shield) {
		float width = 0.001 * frequency * highlight_width / 2.0;
	
		// can play with + or - sign for each UV
		// to control which direction the highlight moves
		// ex. -UV.x - UV.y makes the highlight go from
		// top left to bottom right
		float value = floor(sin(frequency * ((UV.x - UV.y) + TIME * highlight_speed)) + width);
		
		// used to control when to use input color vs highlight color
		float highlight = value > 0.5? 1.0: 0.0;
		vec3 new_color = origin.rgb * (1.0 - highlight) + highlight_color.rgb * highlight;
		COLOR = vec4(new_color, origin.a);
	}
	if (disintagrate) {
		float noise = texture(burn_texture, UV).r * (1.0 - (size_1 + size_2 + size_3 + 0.01));
		
		COLOR.a -= step(percentage, noise);
		COLOR.rgb = mix(COLOR.rgb, layer_3.rgb, step(percentage, noise + size_1 + size_2 + size_3));
		COLOR.rgb = mix(COLOR.rgb, layer_2.rgb, step(percentage, noise + size_1 + size_2));
		COLOR.rgb = mix(COLOR.rgb, layer_1.rgb, step(percentage, noise + size_1));
	}
}