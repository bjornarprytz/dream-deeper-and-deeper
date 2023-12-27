shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D weave_noise;

// Adjust the scale factor to control the repetition of the noise
uniform float noise_scale : hint_range(1.0, 16.0) = 8.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 scaled_uv = uv * noise_scale;

    // Use fract to wrap UV coordinates within the [0, 1] range
    vec2 wrapped_uv = fract(scaled_uv);

    vec3 c = textureLod(screen_texture, uv, 0.0).rgb;
    float noise = texture(weave_noise, wrapped_uv).r * 0.1;

    COLOR.rgb = mix(c, vec3(1.0), noise);
}



