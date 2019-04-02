package om.three.postprocessing;

import three.math.Vector2;
import three.materials.ShaderMaterial;

typedef DotScreenUniforms = {
	var tDiffuse: { type:String, value:String };
	var tSize: { type:String, value:Vector2 };
	var center: { type:String, value:Vector2 };
	var angle: { type:String, value:Float };
	var scale: { type:String, value:Float };
}

class DotScreenPass extends ShaderPass<DotScreenUniforms> {

	static inline var FS = 'uniform vec2 center;
	uniform float angle;
	uniform float scale;
	uniform vec2 tSize;

	uniform sampler2D tDiffuse;

	varying vec2 vUv;

	float pattern() {
		float s = sin( angle ), c = cos( angle );
		vec2 tex = vUv * tSize - center;
		vec2 point = vec2( c * tex.x - s * tex.y, s * tex.x + c * tex.y ) * scale;
		return ( sin( point.x ) * sin( point.y ) ) * 4.0;
	}

	void main() {
		vec4 color = texture2D( tDiffuse, vUv );
		float average = ( color.r + color.g + color.b ) / 3.0;
		gl_FragColor = vec4( vec3( average * 10.0 - 5.0 + pattern() ), color.a );
	}';

	public var tSize(get,set) : Vector2;
	inline function get_tSize() : Vector2 return uniforms.tSize.value;
	inline function set_tSize(v:Vector2) : Vector2 return uniforms.tSize.value = v;

	public var center(get,set) : Vector2;
	inline function get_center() : Vector2 return uniforms.center.value;
	inline function set_center(v:Vector2) : Vector2 return uniforms.center.value = v;

	public var angle(get,set) : Float;
	inline function get_angle() : Float return uniforms.angle.value;
	inline function set_angle(v:Float) : Float return uniforms.angle.value = v;

	public var scale(get,set) : Float;
	inline function get_scale() : Float return uniforms.scale.value;
	inline function set_scale(v:Float) : Float return uniforms.scale.value = v;

	public function new( ?center : Vector2, angle = 1.57, scale = 1.0 ) {
		if( center == null ) center = new Vector2( 0.5, 0.5 );
		super( new Shader({
			tDiffuse : { type: "t", value: null },
			tSize :    { type: "v2", value: new Vector2( 256, 256 ) },
			center:    { type: "v2", value: center },
			angle:     { type: "f", value: angle },
			scale:     { type: "f", value: scale }
		}, null, FS ) );
	}

}
