shader_type spatial;
render_mode specular_toon;

uniform float alpha = 0.6;
uniform float timeScale = 0.05;

uniform sampler2D noise;
uniform sampler2D noise2;

varying vec2 tex_position;

void vertex() {
	vec2 pos = VERTEX.xz;
	tex_position = pos;
}

void fragment() {
	vec2 pos = tex_position.xy / 50.0;
	
	METALLIC = 0.0;
	ROUGHNESS = 0.1;
	ALBEDO = vec3(0.01, 0.05, 0.4);
	
	float t = TIME * timeScale;
	
	const float kW = 0.015;
	const float kOffset = 0.5;
	
	vec3 waterColor0 = texture(noise, pos + vec2(sin(t*5.0)*0.1, t)).xyz * 2.0 - 1.0;
	vec3 waterColor1 = texture(noise2, pos + vec2(t, sin(t*5.0)*0.1)).xyz * 2.0 - 1.0;
	vec3 waterColor = waterColor0 + waterColor1;
	
	vec3 GlobalNormal = normalize(vec3(waterColor.x, abs(waterColor.y)*3.0, waterColor.z));
	
	float specular = dot(MODEL_NORMAL_MATRIX * GlobalNormal, normalize(vec3(0, 1, 1)));

	NORMAL = MODEL_NORMAL_MATRIX * GlobalNormal;
	ALBEDO += vec3(specular / 4.0);
	
	ALPHA = alpha;
}