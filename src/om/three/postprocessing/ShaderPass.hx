package om.three.postprocessing;

import three.cameras.Camera;
import three.cameras.OrthographicCamera;
import three.materials.Material;
import three.materials.ShaderMaterial;
import three.math.Color;
import three.objects.Mesh;
import three.renderers.WebGLRenderTarget;
import three.renderers.WebGLRenderer;
import three.scenes.Scene;
import three.scenes.Scene;
import three.renderers.shaders.UniformsUtils;

class ShaderPass<T> extends Pass {

	public var textureID : String;
    public var uniforms : T;
    public var material : ShaderMaterial<T>;

	var camera : OrthographicCamera;
    var scene : Scene;
	var fsQuad : FullScreenQuad<T>;

	public function new( shader : Shader<T>, ?textureID = "tDiffuse" ) {
		super();
		this.textureID = textureID;
		//TODO: if ( shader instanceof THREE.ShaderMaterial ) {
		this.uniforms = UniformsUtils.clone( shader.uniforms );
		this.material = new ShaderMaterial( {
            //TODO
            //defines: shader.defines || {},
            defines: {},
            uniforms: this.uniforms,
            vertexShader: shader.vertexShader,
            fragmentShader: shader.fragmentShader
        });

		this.fsQuad = new FullScreenQuad( this.material );
	}

	//@:keep
	public override function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) {
		if( untyped uniforms[ textureID ] != null ) {
			untyped uniforms[textureID].value = readBuffer.texture;
		}
		this.fsQuad.material = this.material;
		if( renderToScreen ) {
			renderer.setRenderTarget( null );
			this.fsQuad.render( renderer );
		} else {
			renderer.setRenderTarget( writeBuffer );
			// TODO: Avoid using autoClear properties, see https://github.com/mrdoob/three.js/pull/15571#issuecomment-465669600
			if ( this.clear ) renderer.clear( renderer.autoClearColor, renderer.autoClearDepth, renderer.autoClearStencil );
			this.fsQuad.render( renderer );
		}
	}

	
	@:keep
	public override function setSize( width : Float, height : Float ) {
	}
	
}

