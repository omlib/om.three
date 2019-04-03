package om.three.render;

import three.textures.Texture;

private typedef HueSaturationUniforms = {
	tDiffuse: 	{ type:String, value:Texture },
	hue: 		{ type:String, value:Float },
	saturation: { type:String, value:Float }
}

class HueSaturationPass extends ShaderPass<HueSaturationUniforms> {

	static final FS = '
uniform sampler2D tDiffuse;
uniform float hue;
uniform float saturation;

varying vec2 vUv;

void main() {

	gl_FragColor = texture2D( tDiffuse, vUv );

	// hue
	float angle = hue * 3.14159265;
	float s = sin(angle), c = cos(angle);
	vec3 weights = (vec3(2.0 * c, -sqrt(3.0) * s - c, sqrt(3.0) * s - c) + 1.0) / 3.0;
	float len = length(gl_FragColor.rgb);
	gl_FragColor.rgb = vec3(
		dot(gl_FragColor.rgb, weights.xyz),
		dot(gl_FragColor.rgb, weights.zxy),
		dot(gl_FragColor.rgb, weights.yzx)
	);

	// saturation
	float average = (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) / 3.0;
	if (saturation > 0.0) {
		gl_FragColor.rgb += (average - gl_FragColor.rgb) * (1.0 - 1.0 / (1.001 - saturation));
	} else {
		gl_FragColor.rgb += (average - gl_FragColor.rgb) * (-saturation);
	}
}';

	public var hue(get,set) : Float;
	inline function get_hue() : Float return uniforms.hue.value;
	inline function set_hue(v:Float) : Float return uniforms.hue.value = v;

	public var saturation(get,set) : Float;
	inline function get_saturation() : Float return uniforms.saturation.value;
	inline function set_saturation(v:Float) : Float return uniforms.saturation.value = v;

	public function new( hue = 0.0, saturation = 0.0 ) {
		super( new Shader( {
			tDiffuse : { type: "t", value: null },
			hue:        { type: "f", value: hue },
			saturation: { type: "f", value: saturation }
		}, null, FS ) );
	}
}
