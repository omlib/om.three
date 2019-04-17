package om.three.render;

import om.three.shader.CopyShader;
import om.three.shader.Shader;
import three.textures.Texture;

class CopyPass extends ShaderPass<CopyShaderUniforms> {

	public function new() {
		super( new CopyShader() );
	}
}
