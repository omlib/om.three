package om.three.control;

import js.Browser.window;
import js.html.DeviceOrientationEvent;
import three.core.Object3D;
import three.math.MathUtil;
import three.math.Quaternion;
import three.math.Vector3;
import three.math.Euler;

/**
    W3C Device Orientation control (http://w3c.github.io/deviceorientation/spec-source-orientation.html)
*/
class DeviceOrientationControls {

    public var enabled(default,null) : Bool;

    var object : Object3D;
    var deviceOrientation : Dynamic; //DeviceOrientationEvent;
    var screenOrientation : Int;

    public function new( object : Object3D ) {

        this.object = object;

        object.rotation.reorder( "YXZ" );

        enabled = true;
        deviceOrientation = {};
        screenOrientation = 0;
    }

    public function connect() {
        handleScreenOrientationChangeEvent();
        window.addEventListener( 'orientationchange', handleScreenOrientationChangeEvent, false );
		window.addEventListener( 'deviceorientation', handleDeviceOrientationChangeEvent, false );
        enabled = true;
    }

    public function disconnect() {
        window.removeEventListener( 'orientationchange', handleScreenOrientationChangeEvent, false );
		window.removeEventListener( 'deviceorientation', handleDeviceOrientationChangeEvent, false );
		enabled = false;
    }

    public function update() {
        if( !enabled )
            return;
		var alpha  = (deviceOrientation.alpha != null) ? MathUtil.degToRad( deviceOrientation.alpha ) : 0; // Z
		var beta   = (deviceOrientation.beta != null)  ? MathUtil.degToRad( deviceOrientation.beta  ) : 0; // X'
		var gamma  = (deviceOrientation.gamma != null) ? MathUtil.degToRad( deviceOrientation.gamma ) : 0; // Y''
		var orient = (screenOrientation != null)       ? MathUtil.degToRad( screenOrientation ) : 0; // O
		setObjectQuaternion( object.quaternion, alpha, beta, gamma, orient );
    }

    function setObjectQuaternion( quaternion : Quaternion, alpha : Float, beta : Float, gamma : Float, orient : Float ) {
        var zee = new Vector3( 0, 0, 1 );
		var euler = new Euler();
		var q0 = new Quaternion();
		var q1 = new Quaternion( - Math.sqrt( 0.5 ), 0, 0, Math.sqrt( 0.5 ) ); // - PI/2 around the x-axis
        euler.set( beta, alpha, - gamma, 'YXZ' );                       // 'ZXY' for the device, but 'YXZ' for us
        quaternion.setFromEuler( euler );                               // orient the device
        quaternion.multiply( q1 );                                      // camera looks out the back of the device, not the top
        quaternion.multiply( q0.setFromAxisAngle( zee, - orient ) );    // adjust for screen orientation
    }

    function handleScreenOrientationChangeEvent(?e) {
        screenOrientation = window.orientation;
        if( screenOrientation == null ) screenOrientation = 0;
    }

    function handleDeviceOrientationChangeEvent( e : DeviceOrientationEvent ) {
        deviceOrientation = e;
    }

}
