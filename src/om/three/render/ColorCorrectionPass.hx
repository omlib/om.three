package om.three.render;

import three.textures.Texture;
import three.math.Vector3;

private typedef ColorCorrectionShaderUniforms = {
	tDiffuse:   { type:String, value:Texture },
	powRGB: 	{ type:String, value:Vector3 },
	mulRGB:   	{ type:String, value:Vector3 }
};

class ColorCorrectionPass extends ShaderPass<ColorCorrectionShaderUniforms> {

	static final FS = '
uniform sampler2D tDiffuse;
uniform vec3 powRGB;
uniform vec3 mulRGB;
varying vec2 vUv;
void main() {
	gl_FragColor = texture2D( tDiffuse, vUv );
	gl_FragColor.rgb = mulRGB * pow( gl_FragColor.rgb, powRGB );
}';

	public var pow(get,set) : Vector3;
	inline function get_pow() : Vector3 return uniforms.powRGB.value;
	inline function set_pow(v:Vector3) : Vector3 return uniforms.powRGB.value = v;

	public var mul(get,set) : Vector3;
	inline function get_mul() : Vector3 return uniforms.mulRGB.value;
	inline function set_mul(v:Vector3) : Vector3 return uniforms.mulRGB.value = v;

	public function new( ?pow : Vector3, ?mul : Vector3 ) {
		if( pow == null ) pow = new Vector3(1,1,1);
		if( mul == null ) mul = new Vector3(1,1,1);
		super( new Shader( {
			tDiffuse: { type: "t",  value: null },
			powRGB :  { type: "v3", value: pow },
			mulRGB :  { type: "v3", value: mul }
		}, null, FS ) );
	}

}
