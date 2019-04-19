package om.three.exporter;

import js.lib.Uint8Array;
import three.core.Object3D;

@:native("THREE.ColladaExporter")
extern class ColladaExporter {
	function new() : Void;
	function parse(
		object : Object3D,
		onDone : {
			data : String,
			textures : {
				directory : String,
				name : String,
				ext : String,
				data : Uint8Array,
				original : Dynamic
			}
		}->Void,
		options : Dynamic
	) : Void;
}
