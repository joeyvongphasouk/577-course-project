shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform float viewmodel_fov = 50.0f;

uniform vec4 albedo : source_color = vec4(1.0f);
uniform sampler2D texture_albedo : source_color;
uniform float specular = 0.5f;
uniform float metallic = 1.0f;
uniform float roughness : hint_range(0,1) = 1.0f;
uniform sampler2D texture_metallic : hint_default_white;
uniform vec4 metallic_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform sampler2D texture_roughness : hint_default_white;
uniform vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform sampler2D texture_normal : hint_normal;
uniform float normal_scale : hint_range(-16,16) = 0.5f;
uniform vec3 uv1_scale = vec3(1.0f);
uniform vec3 uv1_offset = vec3(0.0f);

void vertex() {
    UV = UV * uv1_scale.xy + uv1_offset.xy;
    float fov_scale = 1.0 / tan(radians(viewmodel_fov) * 0.5);
    vec4 pos = MODELVIEW_MATRIX * vec4(VERTEX.xyz, 1.0);
    pos.xyz *= fov_scale;
    POSITION = PROJECTION_MATRIX * pos;
}

void fragment() {
	 vec4 clip_pos = PROJECTION_MATRIX * vec4(VERTEX, 10.0);
    DEPTH = clip_pos.z;
	
    vec2 base_uv = UV;
    vec4 albedo_tex = texture(texture_albedo, base_uv);
    albedo_tex *= COLOR;
    ALBEDO = albedo.rgb * albedo_tex.rgb;
    float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
    METALLIC = metallic_tex * metallic;
    float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
    ROUGHNESS = roughness_tex * roughness;
    SPECULAR = specular;
    NORMAL_MAP = texture(texture_normal, base_uv).rgb;
    NORMAL_MAP_DEPTH = normal_scale;
}