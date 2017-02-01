package om.three.effect;

import three.cameras.Camera;
import three.cameras.StereoCamera;
import three.scenes.Scene;
import three.renderers.WebGLRenderer;

class StereoEffect {

    var renderer : WebGLRenderer;
    var stereo : StereoCamera;

    public function new( renderer : WebGLRenderer, aspect = 0.5 ) {

        this.renderer = renderer;

        stereo = new three.cameras.StereoCamera();
	    stereo.aspect = aspect;
    }

    public inline function setSize( width : Int, height: Int ) {
        renderer.setSize( width, height );
    }

    public inline function setEyeSeparation( eyeSep : Float ) {
        stereo.eyeSep = eyeSep;
    }

    public function render( scene : Scene, camera : Camera ) {

        scene.updateMatrixWorld();

        if( camera.parent == null ) camera.updateMatrixWorld();

        stereo.update( camera );

		var size = renderer.getSize();

//TODO
		if ( renderer.autoClear ) renderer.clear();
		untyped renderer.setScissorTest( true );

		renderer.setScissor( 0, 0, size.width / 2, size.height );
		renderer.setViewport( 0, 0, size.width / 2, size.height );
		renderer.render( scene, stereo.cameraL );

		renderer.setScissor( size.width / 2, 0, size.width / 2, size.height );
		renderer.setViewport( size.width / 2, 0, size.width / 2, size.height );
		renderer.render( scene, stereo.cameraR );

		untyped renderer.setScissorTest( false );
    }
}
