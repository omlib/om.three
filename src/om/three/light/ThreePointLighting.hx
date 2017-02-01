package om.three.light;

import three.core.Object3D;
import three.lights.AmbientLight;
import three.lights.DirectionalLight;
import three.math.Color;

/**
	Classic three point lighting

	http://en.wikipedia.org/wiki/Three-point_lighting
*/
class ThreePointLighting extends Object3D {

	public var enabled(get,set) : Bool;
	public var ambient(default,null) : AmbientLight;
	public var back(default,null) : DirectionalLight;
	public var key(default,null) : DirectionalLight;
	public var fill(default,null) : DirectionalLight;

	var _enabled = true;

	public function new( ambientColor = 0x101010, color = 0xffffff ) {

		super();

		ambient = new AmbientLight( ambientColor );
		ambient.name = 'ambient_light';
		add( ambient );

		back = new DirectionalLight( color, 0.225 );
		back.name = 'back_light';
		back.position.set( 2.6, 1, 3 );
		add( back );

		key = new DirectionalLight( color, 0.375 );
		key.name = 'key_light';
		key.position.set( -2, -1, 0 );
		add( key );

		fill = new DirectionalLight( color, 0.75 );
		fill.name = 'fill_light';
		fill.position.set( 3, 3, 2 );
		add( fill );
	}

	inline function get_enabled() : Bool return _enabled;

	function set_enabled(v:Bool) : Bool {
		if( v && !_enabled ) {
			add( ambient );
			add( back );
			add( key );
			add( fill );
		} else if( !v && _enabled ) {
			remove( ambient );
			remove( back );
			remove( key );
			remove( fill );
		}
		return _enabled = v;
	}

	/**
		Applies given color to all three directional lights
	*/
	public inline function setColor( color : Int ) {
		back.color = key.color = fill.color = new Color( color );
	}

	//public function multiplyIntensitiy( factor : Float ) {}

}
