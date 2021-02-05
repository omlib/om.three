package om.three.control;

import js.html.Element;
import three.cameras.Camera;
import three.core.EventDispatcher;
import three.core.Object3D;

@:native("THREE.DragControls")
extern class DragControls extends EventDispatcher {
	var enabled : Bool;
	var transformGroup : Bool;
    function new( objects : Array<Object3D>, camera : Camera, domElement : Element ) : Void;
	function activate() : Void;
	function deactivate() : Void;
	function dispose() : Void;
	function getObjects() : Array<Object3D>;
}
