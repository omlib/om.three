package om.three.loader;

import three.loaders.LoadingManager;

@:native("THREE.GLTFLoader")
extern class GLTFLoader {
	var crossOrigin(default,null) : String;
	function new( ?manager : LoadingManager ) : Void;
	function load( url : String, ?onLoad : Dynamic->Void, ?onProgress : Dynamic->Void, ?onError : Dynamic->Void ) : Void;
	function setCrossOrigin( value : String ) : GLTFLoader;
	function setPath( path : String ) : GLTFLoader;
	function setResourcePath( value : String ) : GLTFLoader;
	function setDRACOLoader( dracoLoader : String ) : GLTFLoader;
	function parse( data : Dynamic, path : String, ?onLoad : Dynamic->Void, ?onError : Dynamic->Void ) : Void;
}
