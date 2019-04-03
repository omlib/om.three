package om.three.render;

import three.textures.Texture;

private typedef NoiseUniforms = {
	tDiffuse:   { type:String, value: Texture },
	time: 	{ type:String, value:Float },
	nIntensity: 	{ type:String, value:Float },
	sIntensity: 	{ type:String, value:Float },
	sCount: 	{ type:String, value:Float },
	grayscale: 	{ type:String, value:Int },
};

class NoisePass extends ShaderPass<NoiseUniforms> {

	static final FS = '
uniform float time;
uniform bool grayscale;
uniform float nIntensity;
uniform float sIntensity;
uniform float sCount;
uniform sampler2D tDiffuse;

varying vec2 vUv;

void main() {

	vec4 cTextureScreen = texture2D( tDiffuse, vUv );

	float x = vUv.x * vUv.y * time *  1000.0;
	x = mod( x, 13.0 ) * mod( x, 123.0 );
	float dx = mod( x, 0.01 );

	vec3 cResult = cTextureScreen.rgb + cTextureScreen.rgb * clamp( 0.1 + dx * 100.0, 0.0, 1.0 );

	vec2 sc = vec2( sin( vUv.y * sCount ), cos( vUv.y * sCount ) );

	cResult += cTextureScreen.rgb * vec3( sc.x, sc.y, sc.x ) * sIntensity;

	cResult = cTextureScreen.rgb + clamp( nIntensity, 0.0,1.0 ) * ( cResult - cTextureScreen.rgb );

	if( grayscale ) {
		cResult = vec3( cResult.r * 0.3 + cResult.g * 0.59 + cResult.b * 0.11 );
	}

	gl_FragColor =  vec4( cResult, cTextureScreen.a );
}';

    public var time(null,set) : Float;
    inline function set_time(v:Float) : Float return uniforms.time.value = v;

    public var nIntensity(get,set) : Float;
    inline function get_nIntensity() : Float return uniforms.nIntensity.value;
    inline function set_nIntensity(v:Float) : Float return uniforms.nIntensity.value = v;

    public var sIntensity(get,set) : Float;
    inline function get_sIntensity() : Float return uniforms.sIntensity.value;
    inline function set_sIntensity(v:Float) : Float return uniforms.sIntensity.value = v;

    public var sCount(get,set) : Float;
    inline function get_sCount() : Float return uniforms.sIntensity.value;
    inline function set_sCount(v:Float) : Float return uniforms.sCount.value = v;

    public var grayscale(get,set) : Bool;
    inline function get_grayscale() : Bool return uniforms.grayscale.value == 1;
    inline function set_grayscale(v:Bool) : Bool {
		uniforms.grayscale.value = v?1:0;
		return v;
	}

    public function new( nIntensity = 0.5, sIntensity = 0.05, sCount = 4096.0, grayscale = false ) {
        super( new Shader({
			tDiffuse :  { type:"t", value:null },
			time:       { type:"f", value:0.0 },
			nIntensity: { type:"f", value: nIntensity },
			sIntensity: { type:"f", value: sIntensity },
			sCount:     { type:"f", value: sCount },
			grayscale:  { type:"i", value: grayscale?1:0 }
		},
		null, FS) );
    }
}
