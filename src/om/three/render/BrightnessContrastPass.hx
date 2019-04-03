package om.three.render;

import three.textures.Texture;

private typedef BrightnessContrastShaderUniforms = {
	tDiffuse:   { type:String, value:Texture },
	brightness: { type:String, value:Float },
	contrast:   { type:String, value:Float }
};

class BrightnessContrastPass extends ShaderPass<BrightnessContrastShaderUniforms> {

	static final FS = '
varying vec2 vUv;

uniform sampler2D tDiffuse;
uniform float brightness;
uniform float contrast;

void main() {
	gl_FragColor = texture2D( tDiffuse, vUv );
	gl_FragColor.rgb += brightness;
	if (contrast > 0.0) {
		gl_FragColor.rgb = (gl_FragColor.rgb - 0.5) / (1.0 - contrast) + 0.5;
	} else {
		gl_FragColor.rgb = (gl_FragColor.rgb - 0.5) * (1.0 + contrast) + 0.5;
	}
}';

	public var brightness(get,set) : Float;
	inline function get_brightness() : Float return uniforms.brightness.value;
	inline function set_brightness(v:Float) : Float return uniforms.brightness.value = v;

	public var contrast(get,set) : Float;
	inline function get_contrast() : Float return uniforms.contrast.value;
	inline function set_contrast(v:Float) : Float return uniforms.contrast.value = v;

	public function new( brightness = 0.0, contrast = 0.0 ) {
		super( new Shader( {
			tDiffuse:   { type: "t", value: null },
			brightness: { type: "f", value: brightness },
			contrast:   { type: "f", value: contrast }
		}, null, FS ) );
	}

}
