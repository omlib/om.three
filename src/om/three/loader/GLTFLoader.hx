package om.three.loader;

import js.html.ErrorEvent;
import js.html.ProgressEvent;
import three.cameras.Camera;
import three.loaders.LoadingManager;
import three.objects.Group;
import three.scenes.Scene;

typedef GLTFParser = Dynamic;

typedef GLTF = {
	scene : Scene,
	scenes : Array<Scene>,
	cameras : Array<Camera>,
	animations: Array<Dynamic>, //TODO
	asset: {
		generator : String,
		version : String
	},
	parser: GLTFParser,
	userData: Dynamic
}

@:native("THREE.GLTFLoader")
extern class GLTFLoader {
	var crossOrigin(default,null) : String;
	function new( ?manager : LoadingManager ) : Void;
	function load( url : String, ?onLoad : GLTF->Void, ?onProgress : ProgressEvent->Void, ?onError : ErrorEvent->Void ) : Void;
	function setCrossOrigin( value : String ) : GLTFLoader;
	function setPath( path : String ) : GLTFLoader;
	function setResourcePath( value : String ) : GLTFLoader;
	function setDRACOLoader( dracoLoader : String ) : GLTFLoader;
	function parse( data : Dynamic, path : String, ?onLoad : GLTF->Void, ?onError : ErrorEvent->Void ) : Void;
}
