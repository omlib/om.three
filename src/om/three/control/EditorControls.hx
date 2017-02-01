package om.three.control;

import js.Browser.document;
import js.html.CanvasElement;
import js.html.MouseEvent;
import js.html.TouchEvent;
import three.core.Object3D;
import three.Lib;
import three.math.*;

private enum State {
	None;
	Rotate;
	Zoom;
	Pan;
}

class EditorControls {

	//public dynamic function onClick( x : Int, y : Int ) {}
	public dynamic function onChange() {}

	public var enabled(default,set) = false;
	public var state(default,null) : State;

	var canvas : CanvasElement;
	var camera : Object3D;
	var center = new Vector3();
	var vector = new Vector3();
	var normalMatrix = new Matrix3();
	var pointer = new Vector2();
	var pointerOld = new Vector2();

	var touches = [for(i in 0...3) new Vector3()];
	var prevTouches = [for(i in 0...3) new Vector3()];
	var prevDistance = 0.0;

	public function new( canvas : CanvasElement, camera : Object3D, enable = true ) {
		this.canvas = canvas;
		this.camera = camera;
		set_enabled( enable );
	}

	function set_enabled(v:Bool) : Bool {
		if( v == enabled )
			return v;
		if( enabled = v ) {
			canvas.addEventListener( 'contextmenu', onContextMenu, false );
			canvas.addEventListener( 'mousedown', onMouseDown, false );
			canvas.addEventListener( 'mousewheel', onMouseWheel, false );
			canvas.addEventListener( 'DOMMouseScroll', onMouseWheel, false ); // firefox
			canvas.addEventListener( 'touchstart', onTouchStart, false );
			canvas.addEventListener( 'touchmove', onTouchMove, false );
		} else {
			canvas.removeEventListener( 'contextmenu', onContextMenu );
			canvas.removeEventListener( 'mousedown', onMouseDown );
			canvas.removeEventListener( 'mousewheel', onMouseWheel );
			canvas.removeEventListener( 'DOMMouseScroll', onMouseWheel ); // firefox
			canvas.removeEventListener( 'touchstart', onTouchStart );
			canvas.removeEventListener( 'touchmove', onTouchMove );
		}
		return enabled;
	}

	public function focus( target : Object3D, frame : Bool ) {
		var scale = new Vector3();
		target.matrixWorld.decompose( center, new Quaternion(), scale );
		if( frame != null && Std.is( target, Mesh ) ) {
			var mesh : Mesh = cast target;
			if( mesh.geometry != null ) {
				var scale = ( scale.x + scale.y + scale.z ) / 3;
				//TODO
				untyped center.add( mesh.geometry.boundingSphere.center.clone().multiplyScalar( scale ) );
				var radius = mesh.geometry.boundingSphere.radius * scale;
				var pos = camera.position.clone().sub( center ).normalize().multiplyScalar( radius * 2 );
				camera.position.copy( center ).add( pos );
			}
		}
		camera.lookAt( center );
		onChange();
	}

	public function pan( delta : Vector3 ) {
		var distance = camera.position.distanceTo( center );
		delta.multiplyScalar( distance * 0.001 );
		delta.applyMatrix3( normalMatrix.getNormalMatrix( camera.matrix ) );
		camera.position.add( delta );
		center.add( delta );
		onChange();
	}

	public function zoom( delta : Vector3 ) {
		var distance = camera.position.distanceTo( center );
		delta.multiplyScalar( distance * 0.001 );
		if( delta.length() > distance )
			return;
		delta.applyMatrix3( normalMatrix.getNormalMatrix( camera.matrix ) );
		camera.position.add( delta );
		onChange();
	}

	public function rotate( delta : Vector3 ) {
		vector.copy( camera.position ).sub( center );
		var theta = Math.atan2( vector.x, vector.z );
		var phi = Math.atan2( Math.sqrt( vector.x * vector.x + vector.z * vector.z ), vector.y );
		theta += delta.x;
		phi += delta.y;
		var EPS = 0.000001;
		phi = Math.max( EPS, Math.min( Math.PI - EPS, phi ) );
		var radius = vector.length();
		vector.x = radius * Math.sin( phi ) * Math.sin( theta );
		vector.y = radius * Math.cos( phi );
		vector.z = radius * Math.sin( phi ) * Math.cos( theta );
		camera.position.copy( center ).add( vector );
		camera.lookAt( center );
		onChange();
	}

	function onMouseMove( e : MouseEvent ) {
		if( !enabled )
			return;
	//	e.preventDefault();
		pointer.set( e.clientX, e.clientY );
		var movX = pointer.x - pointerOld.x;
		var movY = pointer.y - pointerOld.y;
		switch state {
		case Rotate: rotate( new Vector3( - movX * 0.005, - movY * 0.005, 0 ) );
		case Zoom: zoom( new Vector3( 0, 0, movY ) );
		case Pan: pan( new Vector3( - movX, movY, 0 ) );
		case None:
		}
		pointerOld.set( e.clientX, e.clientY );
	}

	function onMouseDown( e : MouseEvent ) {
		if( !enabled )
			return;
//		e.preventDefault();
		switch e.button {
		case 0: state = Rotate;
		case 1: state = Zoom;
		case 2: state = Pan;
		}
		pointerOld.set( e.clientX, e.clientY );
		canvas.addEventListener( 'mousemove', onMouseMove, false );
		canvas.addEventListener( 'mouseup', onMouseUp, false );
		canvas.addEventListener( 'mouseout', onMouseUp, false );
		canvas.addEventListener( 'dblclick', onMouseUp, false );

		//onClick( e.clientX, e.clientY );
	}

	function onMouseUp( e : MouseEvent ) {
		canvas.removeEventListener( 'mousemove', onMouseMove );
		canvas.removeEventListener( 'mouseup', onMouseUp );
		canvas.removeEventListener( 'mouseout', onMouseUp );
		canvas.removeEventListener( 'dblclick', onMouseUp );
		state = None;
	}

	function onMouseWheel( e : MouseEvent ) {
	//	e.preventDefault();
		var delta = 0;
		if( untyped e.wheelDelta != null ) { // WebKit / Opera / Explorer 9
			delta = - untyped e.wheelDelta;
		} else if( e.detail != null ) { // Firefox
			delta = e.detail * 10;
		}
		zoom( new Vector3( 0, 0, delta ) );
	}

	function onTouchStart( e : TouchEvent ) {
		if( !enabled )
			return;
		switch e.touches.length {
		case 1:
			touches[ 0 ].set( e.touches[ 0 ].pageX, e.touches[ 0 ].pageY, 0 );
			touches[ 1 ].set( e.touches[ 0 ].pageX, e.touches[ 0 ].pageY, 0 );
		case 2:
			touches[ 0 ].set( e.touches[ 0 ].pageX, e.touches[ 0 ].pageY, 0 );
			touches[ 1 ].set( e.touches[ 1 ].pageX, e.touches[ 1 ].pageY, 0 );
			prevDistance = touches[ 0 ].distanceTo( touches[ 1 ] );
		}
		prevTouches[ 0 ].copy( touches[ 0 ] );
		prevTouches[ 1 ].copy( touches[ 1 ] );
	}

	function onTouchMove( e : TouchEvent ) {
		if( !enabled )
			return;
//		e.preventDefault();
//		e.stopPropagation();
		switch e.touches.length {
		case 1:
			touches[ 0 ].set( e.touches[ 0 ].pageX, e.touches[ 0 ].pageY, 0 );
			touches[ 1 ].set( e.touches[ 0 ].pageX, e.touches[ 0 ].pageY, 0 );
			rotate( touches[0].sub( getClosest( touches[0], prevTouches ) ).multiplyScalar( -0.005 ) );
		case 2:

			touches[ 0 ].set( e.touches[ 0 ].pageX, e.touches[ 0 ].pageY, 0 );
			touches[ 1 ].set( e.touches[ 1 ].pageX, e.touches[ 1 ].pageY, 0 );
			var distance = touches[ 0 ].distanceTo( touches[ 1 ] );
			zoom( new Vector3( 0, 0, prevDistance - distance ) );
			prevDistance = distance;

			var offset0 = touches[0].clone().sub( getClosest( touches[0] ,prevTouches ) );
			var offset1 = touches[1].clone().sub( getClosest( touches[1] ,prevTouches ) );
			offset0.x = -offset0.x;
			offset1.x = -offset1.x;
			pan( offset0.add( offset1 ).multiplyScalar( 0.05 ) );
		}

		prevTouches[ 0 ].copy( touches[ 0 ] );
		prevTouches[ 1 ].copy( touches[ 1 ] );
	}

	function onContextMenu(e) {
		e.preventDefault();
	}

	function getClosest( touch : Vector3, touches : Array<Vector3> ) : Vector3 {
		var closest = touches[0];
		for( touch in touches ) {
			if( closest.distanceTo(touch) > touch.distanceTo(touch) )
				closest = touch;
		}
		return closest;
	}
}
