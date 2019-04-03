package om.three.render;

import three.renderers.WebGLRenderTarget;
import three.renderers.WebGLRenderer;

class Pass implements IPass {

    public var enabled = true;
    public var needsSwap = true;
	public var renderToScreen = false;
    public var clear = false;

	function new() {}

	public function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) {
		js.Browser.console.warn( 'abstract method' );
	}

	public function setSize( width : Float, height : Float ) {
	}
}

