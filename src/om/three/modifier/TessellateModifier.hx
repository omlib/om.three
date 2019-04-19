package om.three.modifier;

import three.core.Geometry;

@:native("THREE.TessellateModifier")
extern class TessellateModifier {
	function new( maxEdgeLength : Float ) : Void;
	function modify( geometry : Geometry ) : Void;
}
