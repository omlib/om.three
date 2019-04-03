package om.three.render;

import js.html.webgl.RenderingContext;
import three.Lib;
import three.math.Vector2;
import three.renderers.WebGLRenderer;
import three.renderers.WebGLRenderTarget;
import om.three.render.MaskPass;
import om.three.render.RenderPass;
import om.three.render.ShaderPass;

class EffectComposer {

    var renderer : WebGLRenderer;
    var renderTarget1 : WebGLRenderTarget;
    var renderTarget2 : WebGLRenderTarget;
    var writeBuffer : WebGLRenderTarget;
    var readBuffer : WebGLRenderTarget;
	var renderToScreen : Bool;
    var passes : Array<IPass>;
	var copyPass : CopyPass;
	var _previousFrameTime : Float;

    public function new( renderer : WebGLRenderer, ?renderTarget : WebGLRenderTarget ) {

        this.renderer = renderer;

        if( renderTarget == null ) {
			var parameters = {
				minFilter: LinearFilter,
				magFilter: LinearFilter,
				format: RGBAFormat,
				stencilBuffer: false
			};
			var size = renderer.getDrawingBufferSize( new Vector2() );
			renderTarget = new WebGLRenderTarget( size.width, size.height, parameters );
			renderTarget.texture.name = 'EffectComposer.rt1';
        }

        renderTarget1 = renderTarget;
	    renderTarget2 = renderTarget.clone();
		renderTarget2.texture.name = 'EffectComposer.rt2';

        writeBuffer = renderTarget1;
    	readBuffer = renderTarget2;

		renderToScreen = true;

		passes = [];

		copyPass = new CopyPass();

		_previousFrameTime = Date.now().getTime();
    }

	public inline function swapBuffers() {
		var tmp = readBuffer;
		readBuffer = writeBuffer;
		writeBuffer = tmp;
    }

	public function addPass( pass : IPass ) {
        passes.push( pass );
		var size = renderer.getDrawingBufferSize( new Vector2() );
		pass.setSize( size.width, size.height );
    }

	public function insertPass( pass : IPass, index : Int ) {
		//TODO: passes.splice( index, 0, pass );
		//trace("insertPass");
		passes.splice( index, 0 );
	}

	public function isLastEnabledPass( passIndex : Int ) : Bool {
		for( i in (passIndex+1)...passes.length )
			if( passes[i].enabled )
				return false;
		return true;
	}

	public function render( ?delta : Float ) {
		if( delta == null ) delta = (Date.now().getTime() - _previousFrameTime) * 0.001;
		_previousFrameTime = Date.now().getTime();
		var currentRenderTarget = renderer.getRenderTarget();
		var maskActive = false;
		var pass : IPass;
		var il = passes.length;
		for( i in 0...il ) {
			pass = this.passes[i];
			if( !pass.enabled ) continue;
			pass.renderToScreen = ( this.renderToScreen && this.isLastEnabledPass( i ) );
			pass.render( this.renderer, this.writeBuffer, this.readBuffer, delta, maskActive );
			if( pass.needsSwap ) {
				if( maskActive ) {
					var context = this.renderer.context;
					context.stencilFunc( RenderingContext.NOTEQUAL, 1, 0xffffffff );
					copyPass.render( renderer, writeBuffer, readBuffer, delta );
					context.stencilFunc( RenderingContext.EQUAL, 1, 0xffffffff );
				}
				this.swapBuffers();
			}
			if( Std.is( pass, MaskPass ) ) {
				maskActive = true;
			} else if( Std.is( pass, ClearMaskPass ) ) {
				maskActive = false;
			}
		}
		this.renderer.setRenderTarget( currentRenderTarget );
	}

	public function reset( renderTarget : WebGLRenderTarget ) {
		if( renderTarget == null ) {
			var size = renderer.getDrawingBufferSize( new Vector2() );
			renderTarget = renderTarget1.clone();
			renderTarget.setSize( size.width, size.height );
		}
		renderTarget1.dispose();
		renderTarget2.dispose();
		renderTarget1 = renderTarget;
		renderTarget2 = renderTarget.clone();
		writeBuffer = renderTarget1;
		readBuffer = renderTarget2;
	}

	public function setSize( width : Int, height : Int ) {
		renderTarget1.setSize( width, height );
		renderTarget2.setSize( width, height );
		for( pass in passes ) pass.setSize( width, height );
	}
}
