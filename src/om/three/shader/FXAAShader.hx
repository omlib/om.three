package om.three.shader;

import three.math.Vector2;
import om.three.shader.Shader;
import three.math.Color;
import three.textures.Texture;

typedef FXAAUniforms = {
	tDiffuse   : { type : String, value : Texture },
	resolution   : { type : String, value : Vector2 }
}

class FXAAShader extends Shader<FXAAUniforms> {

	public function new( ?resolution : Vector2 ) {
		super({
			tDiffuse: { type : "t", value : null },
			resolution: { type: "v2", value : (resolution != null) ? resolution : new Vector2( 1/1024, 1/512 ) }
		}, null, FS );
	}
}
