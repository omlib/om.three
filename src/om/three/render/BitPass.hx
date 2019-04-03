package om.three.render;

import three.textures.Texture;

private typedef BitUniforms = {
	tDiffuse:   { type:String, value: Texture },
	bit: 	{ type:String, value:Int }
};

class BitPass extends ShaderPass<BitUniforms> {

	static final FS = '
uniform int bit;
uniform sampler2D tDiffuse;
varying vec2 vUv;
void main() {
	vec4 texel = texture2D( tDiffuse, vUv );
	float n = pow(float(bit),2.0);
	float newR = floor(texel.r*n)/n;
	float newG = floor(texel.g*n)/n;
	float newB = floor(texel.b*n)/n;
	gl_FragColor = vec4( vec3(newR,newG,newB), 1.0);
}';

	//public var bit(get,set) : Int;
	//inline function get_bit() : Int return uniforms.bit.value;
	//inline function set_bit(v:Int) : Int return uniforms.bit.value = v;

	public function new( bit = 4 ) {
		super( new Shader( {
			tDiffuse: { type:"t",  value:null },
			bit :  { type: "i", value:bit }
		}, null, FS ) );
	}
}

