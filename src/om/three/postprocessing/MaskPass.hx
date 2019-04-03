package om.three.postprocessing;

import js.html.webgl.RenderingContext;
import three.cameras.Camera;
import three.cameras.OrthographicCamera;
import three.math.Vector2;
import three.renderers.WebGLRenderTarget;
import three.renderers.WebGLRenderer;
import three.scenes.Scene;

class MaskPass extends Pass {

	public var inverse = false;
	
	var scene : Scene;
	var camera : Camera;
	
	public function new( scene : Scene, camera : Camera ) {
		super();
		this.scene = scene;
		this.camera = camera;
		clear = true;
		needsSwap = false;
	}

	public override function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) {
	
		var context = renderer.context;
		var state = renderer.state;
		
		state.buffers.color.setMask( false );
		state.buffers.depth.setMask( false );
		state.buffers.color.setLocked( true );
		state.buffers.depth.setLocked( true );
		
		var writeValue : Int;
		var clearValue : Int;
		
		if( inverse ) {
			writeValue = 0;
			clearValue = 1;
		} else {
			writeValue = 1;
			clearValue = 0;
		}

		state.buffers.stencil.setTest( true );
		state.buffers.stencil.setOp( RenderingContext.REPLACE, RenderingContext.REPLACE, RenderingContext.REPLACE );
		state.buffers.stencil.setFunc( RenderingContext.ALWAYS, writeValue, 0xffffffff );
		state.buffers.stencil.setClear( clearValue );

		renderer.setRenderTarget( readBuffer );
		if ( this.clear ) renderer.clear();
		renderer.render( this.scene, this.camera );

		renderer.setRenderTarget( writeBuffer );
		if ( this.clear ) renderer.clear();
		renderer.render( this.scene, this.camera );

		state.buffers.color.setLocked( false );
		state.buffers.depth.setLocked( false );

		state.buffers.stencil.setFunc( RenderingContext.EQUAL, 1, 0xffffffff ); // draw if == 1
		state.buffers.stencil.setOp( RenderingContext.KEEP, RenderingContext.KEEP, RenderingContext.KEEP );
	}
}

class ClearMaskPass extends Pass {

	public function new() {
		super();
		needsSwap = false;
	}

	public override function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) {
		renderer.state.buffers.stencil.setTest( false );
	}
}
