package om.three.render;

import om.three.shader.CopyShader;

class CopyPass extends ShaderPass<CopyUniforms> {

	public function new( opacity = 1.0 ) {
		super( new CopyShader( opacity ) );
	}
}
