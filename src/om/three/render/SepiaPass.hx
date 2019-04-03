package om.three.render;

import three.textures.Texture;

private typedef SepiaUniforms = {
	tDiffuse: 	{ type : String, value : Texture },
	amount: { type : String, value : Float }
}

class SepiaPass extends ShaderPass<SepiaUniforms> {

	static var FS = '
uniform float amount;
uniform sampler2D tDiffuse;
varying vec2 vUv;
void main() {
	vec4 color = texture2D( tDiffuse, vUv );
	vec3 c = color.rgb;
	color.r = dot( c, vec3( 1.0 - 0.607 * amount, 0.769 * amount, 0.189 * amount ) );
	color.g = dot( c, vec3( 0.349 * amount, 1.0 - 0.314 * amount, 0.168 * amount ) );
	color.b = dot( c, vec3( 0.272 * amount, 0.534 * amount, 1.0 - 0.869 * amount ) );
	gl_FragColor = vec4( min( vec3( 1.0 ), color.rgb ), color.a );
}';

	public var amount(get,set) : Float;
	inline function get_amount() : Float return uniforms.amount.value;
	inline function set_amount(v:Float) : Float return uniforms.amount.value = v;

	public function new( amount = 1.0 ) {
		super( new Shader( {
			tDiffuse : { type: "t", value: null },
			amount :   { type: "f", value: amount },
		}, null, FS ) );
	}
}

