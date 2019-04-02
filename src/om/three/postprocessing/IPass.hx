package om.three.postprocessing;

import three.renderers.WebGLRenderTarget;
import three.renderers.WebGLRenderer;

interface IPass {

	var enabled : Bool;
	var needsSwap : Bool;
	var clear : Bool;
	var renderToScreen : Bool;

	function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) : Void;
	function setSize( width : Float, height : Float ) : Void;
}
