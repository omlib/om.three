package om.three.shader;

import om.three.shader.Shader;
import three.math.Color;
import three.textures.Texture;

typedef CopyUniforms = {
	var tDiffuse : { type : String, value : Texture };
	var opacity  : { type : String, value : Float };
}

class CopyShader extends Shader<CopyUniforms> {

	/*
	static final FS = '
uniform float opacity;
uniform sampler2D tDiffuse;
varying vec2 vUv;
void main() {
	vec4 texel = texture2D( tDiffuse, vUv );
	gl_FragColor = opacity * texel;
}';
*/

	public function new( opacity = 1.0 ) {
		super({
			tDiffuse: { type : texture, value : null },
			opacity: { type: float, value : opacity }
		}, null, FS );
	}
}
