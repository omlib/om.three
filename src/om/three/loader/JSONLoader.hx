package om.three.loader;

import three.core.Geometry;
import three.materials.Material;
import three.loaders.LoadingManager;

@:native("THREE.JSONLoader")
extern class JSONLoader {

	var withCredentials : Bool;

	function new( ?manager : LoadingManager ) : Void;

	function load( url : String, onLoad : Geometry->Material->Void, ?onProgress : Dynamic->Void, ?onError: Dynamic->Void ) : Void;
	function setTexturePath( value : String ) : Void;
	function parse( json : Dynamic, ?texturePath : String ) : { geometry: Geometry, materials: Array<Material> };
}
