package om.three.render;

import three.math.Vector2;
import three.materials.ShaderMaterial;

typedef FilmUniforms = {
	var tDiffuse : 	 { type : String, value : String };
	var time :  	 { type : String, value : Float };
	var nIntensity : { type : String, value : Float };
	var sIntensity : { type : String, value : Float };
	var sCount :  	 { type : String, value : Float };
	var grayscale :  { type : String, value : Int };
}

class FilmPass extends ShaderPass<FilmUniforms> {

	static var VS = 'varying vec2 vUv;
		void main() {
			vUv = uv;
			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
		}';

	static var FS = '#include <common>
		
		// control parameter
		uniform float time;
		uniform bool grayscale;

		// noise effect intensity value (0 = no effect, 1 = full effect)
		uniform float nIntensity;

		// scanlines effect intensity value (0 = no effect, 1 = full effect)
		uniform float sIntensity;

		// scanlines effect count value (0 = no effect, 4096 = full effect)
		uniform float sCount;

		uniform sampler2D tDiffuse;

		varying vec2 vUv;

		void main() {

			// sample the source
			vec4 cTextureScreen = texture2D( tDiffuse, vUv );

			// make some noise
			float dx = rand( vUv + time );

			// add noise
			vec3 cResult = cTextureScreen.rgb + cTextureScreen.rgb * clamp( 0.1 + dx, 0.0, 1.0 );

			// get us a sine and cosine
			vec2 sc = vec2( sin( vUv.y * sCount ), cos( vUv.y * sCount ) );

			// add scanlines
			cResult += cTextureScreen.rgb * vec3( sc.x, sc.y, sc.x ) * sIntensity;

			// interpolate between source and result by intensity
			cResult = cTextureScreen.rgb + clamp( nIntensity, 0.0,1.0 ) * ( cResult - cTextureScreen.rgb );

			// convert to grayscale if desired
			if( grayscale ) {
				cResult = vec3( cResult.r * 0.3 + cResult.g * 0.59 + cResult.b * 0.11 );
			}

			gl_FragColor =  vec4( cResult, cTextureScreen.a );

		}';

	public var time(get,set) : Float;
	inline function get_time() : Float return uniforms.time.value;
	inline function set_time(v:Float) : Float return uniforms.time.value = v;
	
	public var nIntensity(get,set) : Float;
	inline function get_nIntensity() : Float return uniforms.nIntensity.value;
	inline function set_nIntensity(v:Float) : Float return uniforms.nIntensity.value = v;

	public var sIntensity(get,set) : Float;
	inline function get_sIntensity() : Float return uniforms.sIntensity.value;
	inline function set_sIntensity(v:Float) : Float return uniforms.sIntensity.value = v;

	public var sCount(get,set) : Float;
	inline function get_sCount() : Float return uniforms.sCount.value;
	inline function set_sCount(v:Float) : Float return uniforms.sCount.value = v;

	public var grayscale(get,set) : Bool;
	inline function get_grayscale() : Bool return uniforms.grayscale.value == 0;
	inline function set_grayscale(v:Bool) : Bool {
		uniforms.grayscale.value = v ? 0 : 1;
		return v;
	}

	public function new( nIntensity = 0.5, sIntensity = 0.05, sCount = 4096.0, grayscale = false ) {
		super( new Shader({
			tDiffuse : { type: "t", value: null },
			time :     { type: "f", value: 0.0 },
			nIntensity :  { type: "f", value: nIntensity },
			sIntensity :    { type: "f", value: sIntensity },
			sCount :     { type: "f", value: sCount },
			grayscale :    { type: "f", value: grayscale ? 0 : 1 },
		}, null, FS ) );
	}

}
