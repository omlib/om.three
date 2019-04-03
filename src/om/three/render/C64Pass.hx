package om.three.render;

import three.textures.Texture;

private typedef C64Uniforms = {
	tDiffuse:   { type:String, value:Texture }
};

class C64Pass extends ShaderPass<C64Uniforms> {

	static final FS = '
uniform sampler2D tDiffuse;

varying vec2 vUv;

void main() {

	vec3 c64col[16];

		/*
		c64col[0] = vec3(0.0,0.0,0.0);
		c64col[1] = vec3(62.0,49.0,162.0);
		c64col[2] = vec3(87.0,66.0,0.0);
		c64col[3] = vec3(140.0,62.0,52.0);
		c64col[4] = vec3(84.0,84.0,84.0);
		c64col[5] = vec3(141.0,71.0,179.0);
		c64col[6] = vec3(144.0,95.0,37.0);
		c64col[7] = vec3(124.0,112.0,218.0);
		c64col[8] = vec3(128.0,128.0,129.0);
		c64col[9] = vec3(104.0,169.0,65.0);
		c64col[10] = vec3(187.0,119.0,109.0);
		c64col[11] = vec3(122.0,191.0,199.0);
		c64col[12] = vec3(171.0,171.0,171.0);
		c64col[13] = vec3(208.0,220.0,113.0);
		c64col[14] = vec3(172.0,234.0,136.0);
		c64col[15] = vec3(255.0,255.0,255.0);
		*/

		// Another color scheme
		c64col[0] = vec3(157.0,157.0,157.0);
		c64col[1] = vec3(255.0,255.0,255.0);
		c64col[2] = vec3(190.0,38.0,51.0);
		c64col[3] = vec3(224.0,111.0,139.0);
		c64col[4] = vec3(73.0,60.0,43.0);
		c64col[5] = vec3(164.0,100.0,34.0);
		c64col[6] = vec3(235.0,137.0,49.0);
		c64col[7] = vec3(247.0,226.0,107.0);
		c64col[8] = vec3(47.0,72.0,78.0);
		c64col[9] = vec3(68.0,137.0,26.0);
		c64col[10] = vec3(163.0,206.0,39.0);
		c64col[11] = vec3(27.0,38.0,50.0);
		c64col[12] = vec3(0.0,87.0,132.0);
		c64col[13] = vec3(49.0,162.0,242.0);
		c64col[14] = vec3(178.0,220.0,239.0);
		c64col[15] = vec3(255.0,0.0,255.0);

		vec3 samp = texture2D(tDiffuse, vUv.xy).rgb;
		vec3 match = vec3(0.0,0.0,0.0);
		float best_dot = 8.0;

		for( int c=15; c >= 0; c-- ) {
			float this_dot = distance(c64col[c]/255.0,samp);
			if (this_dot<best_dot) {
				best_dot=this_dot;
				match=c64col[c];
			}
		}
		vec4 color = vec4( match/255.0, 0.0 );
		gl_FragColor = color;
	}';

	public function new() {
		super( new Shader( {
			tDiffuse:   { type: "t", value: null }
		}, null, FS ) );
	}
}
