package om.three.render;

import three.math.Color;
import three.textures.Texture;

private typedef ColorifyUniforms = {
	tDiffuse: 	{ type:String, value:Texture },
	color: 		{ type:String, value:Color }
}

class ColorifyPass extends ShaderPass<ColorifyUniforms> {

	static final FS = '
uniform vec3 color;
uniform sampler2D tDiffuse;
varying vec2 vUv;
void main() {
	vec4 texel = texture2D( tDiffuse, vUv );
	vec3 luma = vec3( 0.299, 0.587, 0.114 );
	float v = dot( texel.xyz, luma );
	gl_FragColor = vec4( v * color, texel.w );
}';

	public var color(get,set) : Color;
	inline function get_color() : Color return uniforms.color.value;
	inline function set_color(v:Color) : Color return uniforms.color.value = v;

	public function new( color : Int ) {
		super( new Shader( {
			tDiffuse : { type: "t", value: null },
			color :    { type: "c", value: new Color( color ) }
		}, null, FS ) );
	}
}

