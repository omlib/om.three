package om.three.loader;

import js.html.ErrorEvent;
import js.html.ProgressEvent;
import three.core.Geometry;
import three.loaders.LoadingManager;
import three.materials.Material;
import three.objects.Group;

@:native("THREE.FBXLoader")
extern class FBXLoader {
	var withCredentials : Bool;
	function new( ?manager : LoadingManager ) : Void;
	function load( url : String, onLoad : Group->Void, ?onProgress : ProgressEvent->Void, ?onError: ErrorEvent->Void ) : Void;
	function setPath( path : String ) : FBXLoader;
	function setResourcePath( value : String ) : FBXLoader;
	function setCrossOrigin( value : String ) : FBXLoader;
	function parse( json : Dynamic, ?texturePath : String ) : { geometry: Geometry, materials: Array<Material> };
	//function setTexturePath( value : String ) : Void;
}
