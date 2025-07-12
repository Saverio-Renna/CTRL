shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float saturation : hint_range(0.0, 1.0) = 1.0;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 screen_color = texture(screen_texture, uv);

    // Saturazione
    float gray = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
    screen_color.rgb = mix(vec3(gray), screen_color.rgb, saturation);

    // Vignetta più scura con potenza maggiore e moltiplicatore
    float dist = distance(uv, vec2(0.5));
    float vignette = 1.0 - vignette_strength * 4.0 * pow(dist, 1.7);
    vignette = clamp(vignette, 0.0, 1.0);
    
    screen_color.rgb *= vignette;

    COLOR = screen_color;
}
