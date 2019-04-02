package om.three.postprocessing;

typedef CopyShaderUniforms = {
	var tDiffuse   : { type : String, value : String };
	var opacity    : { type : String, value : Float };
}

class CopyPass extends ShaderPass<CopyShaderUniforms> {
	
	public static var VS(default,null) = 'varying vec2 vUv;
	void main() {
		vUv = uv;
		gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

	}';

	public static var FS(default,null) = 'uniform float opacity;
uniform sampler2D tDiffuse;
varying vec2 vUv;
void main() {
	vec4 texel = texture2D( tDiffuse, vUv );
	gl_FragColor = opacity * texel;
}';

	public function new() {
		super( new Shader({
			tDiffuse: { type : "t", value : null },
			opacity: { type: "f", value : 1.0 }
		}, VS, FS ) );
	}
}
