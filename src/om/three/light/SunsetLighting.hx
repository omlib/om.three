package om.three.light;

import three.*;

/**
*/
class SunsetLighting extends three.Group {

	public var ambient(default,null) : AmbientLight;
	public var blue(default,null) : DirectionalLight;
	public var red(default,null) : DirectionalLight;

	public function new( ambientColor = 0x080808,
						 blueColor = 0x191970, blueIntensity = 1.0,
						 redColor = 0x8B0000, redIntensity = 1.5 ) {

		super();

		ambient = new AmbientLight( ambientColor );
		ambient.name = 'ambient_light';
		add( ambient );

		blue = new DirectionalLight( blueColor, blueIntensity );
		blue.name = 'blue_light';
		blue.position.set( 5, 1, 0 );
		add( blue );

		red = new DirectionalLight( redColor, redIntensity );
		red.name = 'red_light';
		add( red );
	}

}
