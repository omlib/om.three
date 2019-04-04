package om.three.render;

import three.textures.Texture;

private typedef KaleidoUniforms = {
	tDiffuse: 	{ type:String, value:Texture },
	sides: 		{ type:String, value:Float },
	angle: { type:String, value:Float }
}

class KaleidoPass extends ShaderPass<KaleidoUniforms> {

	static final FS = '
varying vec2 vUv;
uniform sampler2D tDiffuse;
uniform float sides;
uniform float angle;
void main() {
	vec2 p = vUv - 0.5;
	float r = length(p);
	float a = atan( p.y, p.x ) + angle;
	float tau = 2. * 3.1416;
	a = mod( a, tau/sides );
	a = abs( a - tau/sides/2.0 );
	p = r * vec2( cos(a), sin(a) );
	vec4 color = texture2D( tDiffuse, p + 0.5 );
	gl_FragColor = color;
}';

	public var sides(get,set) : Float;
	inline function get_sides() : Float return uniforms.sides.value;
	inline function set_sides(v:Float) : Float return uniforms.sides.value = v;

	public var angle(get,set) : Float;
	inline function get_angle() : Float return uniforms.angle.value;
	inline function set_angle(v:Float) : Float return uniforms.angle.value = v;

	public function new( sides = 6.0, angle = 0.0 ) {
		super( new Shader( {
			tDiffuse : { type: "t", value: null },
			sides : { type: "f", value: sides },
			angle : { type: "f", value: angle }
		}, null, FS ) );
	}
}

