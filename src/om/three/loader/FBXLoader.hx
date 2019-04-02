package om.three.loader;

import three.core.Geometry;
import three.materials.Material;

@:native("THREE.FBXLoader")
extern class FBXLoader {

	var withCredentials : Bool;

	function new( ?manager : three.loaders.LoadingManager ) : Void;

	function load( url : String, onLoad : Dynamic->Void, ?onProgress : Dynamic->Void, ?onError: Dynamic->Void ) : Void;
	function setTexturePath( value : String ) : Void;
	function parse( json : Dynamic, ?texturePath : String ) : { geometry: Geometry, materials: Array<Material> };
}
