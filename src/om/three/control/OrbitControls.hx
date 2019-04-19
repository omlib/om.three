package om.three.control;

import js.html.Element;
import three.core.Object3D;
import three.math.Vector3;

@:native("THREE.OrbitControls")
extern class OrbitControls {

	var object : Object3D;
	
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

	var target0 : Object3D;
	var position0 : Vector3;
	var zoom0 : Float;

	function new( object : Object3D, ?domElement : Element ) : Void;

	function getPolarAngle() : Float;
	function getAzimuthalAngle() : Float;
	function saveState() : Void;
	function reset() : Void;
	function update() : Void;
	function dispose() : Void;

}