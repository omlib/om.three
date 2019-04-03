package om.three.render;

import three.cameras.Camera;
import three.materials.Material;
import three.math.Color;
import three.renderers.WebGLRenderTarget;
import three.renderers.WebGLRenderer;
import three.scenes.Scene;

/*
@:native("THREE.RenderPass")
extern class RenderPass implements IPass {
	var enabled : Bool;
	var needsSwap : Bool;
	var clear : Bool;
	var renderToScreen : Bool;
	function new( scene : Scene, camera : Camera, ?overrideMaterial : Material, ?clearColor : Color, ?clearAlpha : Float ) : Void;
	function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) : Void;
	function setSize( width : Float, height : Float ) : Void;
}
*/

class RenderPass extends Pass {

	var scene : Scene;
	var camera : Camera;

	//var clear = true;
	var clearDepth = false;
	//var needsSwap = false;

	var overrideMaterial : Material;

	var clearColor : Color;
	var clearAlpha : Float;

	public function new( scene : Scene, camera : Camera, ?overrideMaterial : Material, ?clearColor : Color, clearAlpha = 0.0 ) {
		super();
		this.scene = scene;
		this.camera = camera;
		this.overrideMaterial = overrideMaterial;
		this.clearColor = clearColor;
		this.clearAlpha = clearAlpha;
		this.clear = true;
		this.needsSwap = false;
	}

	public override function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) {
		var oldAutoClear = renderer.autoClear;
		renderer.autoClear = false;
		scene.overrideMaterial = overrideMaterial;
		var oldClearColor : Int = null;
		var oldClearAlpha : Float = null;
		if( clearColor != null ) {
			oldClearColor = renderer.getClearColor().getHex();
			oldClearAlpha = renderer.getClearAlpha();
			renderer.setClearColor( clearColor, clearAlpha );
		}
		if( clearDepth ) renderer.clearDepth();
		renderer.setRenderTarget( renderToScreen ? null : readBuffer );
		if( clear ) renderer.clear( renderer.autoClearColor, renderer.autoClearDepth, renderer.autoClearStencil );
		renderer.render( scene, camera );
		if( clearColor != null ) renderer.setClearColor( oldClearColor, oldClearAlpha );
		scene.overrideMaterial = null;
		renderer.autoClear = oldAutoClear;
	}

}


