package om.three.modifier;

import haxe.extern.EitherType;
import three.core.BufferGeometry;
import three.core.Geometry;

@:native("THREE.SimplifyModifier")
extern class SimplifyModifier {
	function new() : Void;
	function modify( geometry : EitherType<Geometry,BufferGeometry>, count : Int ) : BufferGeometry;
}
