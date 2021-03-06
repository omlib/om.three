package om.three.render;

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
import om.three.shader.Shader;

@:autoBuild(om.three.macro.BuildShaderPass.build())
class ShaderPass<T> extends Pass {

	public var textureID : String;
    public var uniforms : T;
    public var material : ShaderMaterial<T>;

	var camera : OrthographicCamera;
    var scene : Scene;
	var fsQuad : FullScreenQuad<T>;

	public function new( shader : Shader<T>, textureID = "tDiffuse" ) {
		super();
		this.textureID = textureID;
		//TODO: if ( shader instanceof THREE.ShaderMaterial ) {
		uniforms = UniformsUtils.clone( shader.uniforms );
		material = new ShaderMaterial( {
            //TODO
            //defines: shader.defines || {},
            defines: {},
            uniforms: uniforms,
            vertexShader: shader.vertexShader,
            fragmentShader: shader.fragmentShader
        });
		fsQuad = new FullScreenQuad( material );
	}

	//@:keep
	public override function render( renderer : WebGLRenderer, writeBuffer : WebGLRenderTarget, readBuffer : WebGLRenderTarget, delta : Float, ?maskActive : Bool ) {
		if( untyped uniforms[ textureID ] != null ) {
			untyped uniforms[textureID].value = readBuffer.texture;
		}
		fsQuad.material = material;
		if( renderToScreen ) {
			renderer.setRenderTarget( null );
			fsQuad.render( renderer );
		} else {
			renderer.setRenderTarget( writeBuffer );
			// TODO: Avoid using autoClear properties, see https://github.com/mrdoob/three.js/pull/15571#issuecomment-465669600
			if ( clear )
				renderer.clear( renderer.autoClearColor, renderer.autoClearDepth, renderer.autoClearStencil );
			fsQuad.render( renderer );
		}
	}
	
	@:keep
	public override function setSize( width : Float, height : Float ) {
	}
	
}

