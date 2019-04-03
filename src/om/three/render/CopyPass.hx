package om.three.render;

import om.three.render.Shader;

typedef CopyShaderUniforms = {
	var tDiffuse   : { type : String, value : String };
	var opacity    : { type : String, value : Float };
}

class CopyPass extends ShaderPass<CopyShaderUniforms> {
	
	public static final FS = 'uniform float opacity;
uniform sampler2D tDiffuse;
varying vec2 vUv;
void main() {
	vec4 texel = texture2D( tDiffuse, vUv );
	gl_FragColor = opacity * texel;
}';

	public function new() {
		super( new Shader({
			tDiffuse: { type : texture, value : null },
			opacity: { type: float, value : 1.0 }
		}, null, FS ) );
	}
}
