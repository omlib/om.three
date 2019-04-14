package om.three.control;

import js.html.Element;
import three.core.EventDispatcher;
import three.math.Vector3;

@:native("THREE.MapControls")
extern class MapControls extends EventDispatcher {

	var enabled : Bool;
	var target : Vector3;

	var minDistance : Float;
	var maxDistance : Float;

	var minZoom : Float;
	var maxZoom : Float;
	
	var minPolarAngle : Float;
	var maxPolarAngle : Float;
	
	var minAzimuthAngle : Float;
	var maxAzimuthAngle : Float;

	var enableDamping : Bool;
	var dampingFactor : Float;
	
	var enableZoom : Bool;
	var zoomSpeed : Float;

	var enableRotate : Bool;
	var rotateSpeed : Float;

	var enablePan : Bool;
	var panSpeed : Float;
	var screenSpacePanning : Bool;
	var keyPanSpeed : Float;

	var autoRotate : Bool;
	var autoRotateSpeed : Float;

	var enableKeys : Bool;

	var keys : { LEFT:Int, UP:Int, RIGHT:Int, BOTTOM:Int };
	var mouseButtons : { LEFT:Int, MIDDLE:Int, RIGHT:Int };

	var target0 : Vector3;
	var position0 : Vector3;
	var zoom0 : Vector3;

	function new( object : Dynamic, domElement : Dynamic ) : Void;

	function getPolarAngle() : Float;
	function getAzimuthalAngle() : Float;
	function saveState() : Void;
	function reset() : Void;
	function update() : Void;
	function dispose() : Void;
}
