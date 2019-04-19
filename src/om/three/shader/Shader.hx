package om.three.shader;

enum abstract UniformType(String) to String {
	var color = "c";
	var float = "f";
	var texture = "t";
	var vector2 = "v2";
	var vector3 = "v3";
	var vector4 = "v4";
	//...
}

@:autoBuild(om.three.macro.BuildShader.build())
class Shader<T> {

	public static final DEFAULT_VS = 'varying vec2 vUv;
void main() {
	vUv = uv;
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}';

	public var defines : Dynamic;
	public var uniforms(default,null) : T;
	public var vertexShader(default,null) : String;
	public var fragmentShader(default,null) : String;
	//blending

	public function new( uniforms : T, ?vertexShader : String, fragmentShader : String ) {
		this.uniforms = uniforms;
		this.vertexShader = (vertexShader != null) ? vertexShader : DEFAULT_VS;
		this.fragmentShader = fragmentShader;
	}
}
