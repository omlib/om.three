package om.three.util;

import three.core.Face3;
import three.core.BufferGeometry;
import three.core.Geometry;
import three.math.Vector3;

@:native("THREE.ImageUtils")
extern class GeometryUtils {
	static function randomPointInTriangle( vectorA : Vector3, vectorB : Vector3, vectorC : Vector3 ) : Vector3;
	static function randomPointInFace( face : Face3, geometry : Geometry ) : Vector3;
	static function randomPointsInGeometry( geometry : Geometry, n : Int ) : Array<Vector3>;
	static function randomPointsInBufferGeometry( geometry : BufferGeometry, n : Int ) : Array<Vector3>;
	static function triangleArea( vectorA : Vector3, vectorB : Vector3, vectorC : Vector3 ) : Float;
}
