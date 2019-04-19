package om.three.exporter;

import haxe.extern.EitherType;
import js.lib.ArrayBuffer;
import three.scenes.Scene;

@:native("THREE.GLTFExporter")
extern class GLTFExporter {
	function new() : Void;
	function parse( input : EitherType<Scene,Array<Scene>>, onDone : ArrayBuffer->Void, options : Dynamic ) : Void;
}
