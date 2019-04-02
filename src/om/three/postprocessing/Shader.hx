package om.three.postprocessing;

class Shader<T> {

	public static var defaultVertexShader = 'varying vec2 vUv;
void main() {
	vUv = uv;
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}';

	public var uniforms(default,null) : T;
	public var vertexShader(default,null) : String;
	public var fragmentShader(default,null) : String;

	public function new( uniforms : T, vertexShader : String, fragmentShader : String ) {
		this.uniforms = uniforms;
		this.vertexShader = (vertexShader != null) ? vertexShader : defaultVertexShader;
		this.fragmentShader = fragmentShader;
	}
}
