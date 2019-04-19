package om.three.modifier;

import haxe.extern.EitherType;
import three.core.BufferGeometry;
import three.core.Geometry;

@:native("THREE.SubdivisionModifier")
extern class SubdivisionModifier {
	function new( ?subdivisions : Int ) : Void;
	function modify( geometry : EitherType<Geometry,BufferGeometry> ) : Geometry;
	function smooth( geometry : Geometry ) : Void;
}
