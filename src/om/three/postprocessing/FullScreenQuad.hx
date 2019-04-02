package om.three.postprocessing;

import three.renderers.WebGLRenderer;
import three.cameras.OrthographicCamera;
import three.geometries.PlaneBufferGeometry;
import three.materials.ShaderMaterial;
import three.objects.Mesh;

class FullScreenQuad<T> {

	public var material(get,set) : ShaderMaterial<T>;
	inline function get_material() : ShaderMaterial<T> return cast _mesh.material;
	function set_material( m : ShaderMaterial<T> ) {
		_mesh.material = m;
		return m;
	}

	var camera = new OrthographicCamera( -1, 1, 1, -1, 0, 1 );
	var geometry = new PlaneBufferGeometry( 2, 2 );
	var _mesh : Mesh;

	public function new( material : ShaderMaterial<T> ) {
		this._mesh = new Mesh( geometry, material );
	}

	public inline function render( renderer : WebGLRenderer ) {
		renderer.render( cast _mesh, camera );
	}
	
}
