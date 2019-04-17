package om.three.render;

import om.three.shader.FXAAShader;
import three.math.Vector2;

class FXAAPass extends ShaderPass<FXAAUniforms> {

	public function new( ?resolution : Vector2 ) {
		super( new FXAAShader( resolution ) );
	}

}
