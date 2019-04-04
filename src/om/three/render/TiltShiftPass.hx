package om.three.render;

import three.textures.Texture;

private typedef TiltShiftUniforms = {
	tDiffuse : { type: String, value: Texture },
	v :  { type: String, value: Float },
	r :   { type: String, value: Float }
}

class TiltShiftPass extends ShaderPass<TiltShiftUniforms> {

	public var v(get,set) : Float;
	inline function get_v() : Float return uniforms.v.value;
	inline function set_v(v:Float) : Float return uniforms.v.value = v;

	public var r(get,set) : Float;
	inline function get_r() : Float return uniforms.r.value;
	inline function set_r(v:Float) : Float return uniforms.r.value = v;

	function new( v : Float, r = 0.35, fragmentShader : String ) {
		super( new Shader( {
			tDiffuse : { type:"t", value: null },
			v :  { type: "f", value: v },
			r:   { type: "f", value: r }
		}, null, fragmentShader ) );
	}
}
