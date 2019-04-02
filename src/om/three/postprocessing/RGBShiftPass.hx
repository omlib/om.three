package om.three.postprocessing;

import three.textures.Texture;

private typedef RGBShiftUniforms = {
	tDiffuse : { type:String, value:Texture },
	amount:    { type:String, value:Float },
	angle:     { type:String, value:Float }
}

class RGBShiftPass extends ShaderPass<RGBShiftUniforms> {

	static inline var FS = '
uniform sampler2D tDiffuse;
uniform float amount;
uniform float angle;
varying vec2 vUv;
void main() {
	vec2 offset = amount * vec2( cos(angle), sin(angle));
	vec4 cr = texture2D(tDiffuse, vUv + offset);
	vec4 cga = texture2D(tDiffuse, vUv);
	vec4 cb = texture2D(tDiffuse, vUv - offset);
	gl_FragColor = vec4(cr.r, cga.g, cb.b, cga.a);
}';

	public var amount(get,set) : Float;
	inline function get_amount() : Float return uniforms.amount.value;
	inline function set_amount(v:Float) : Float return uniforms.amount.value = v;
	
	public var angle(get,set) : Float;
	inline function get_angle() : Float return uniforms.angle.value;
	inline function set_angle(v:Float) : Float return uniforms.angle.value = v;

	public function new( amount = 0.005, angle = 0.0 ) {
		super( new Shader( {
			tDiffuse : { type: "t", value: null },
			amount:    { type: "f", value: amount },
			angle:     { type: "f", value: angle }
		}, null, FS ) );
	}

}
