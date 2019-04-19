package om.three.macro;

#if macro

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import om.macro.MacroTools.*;
import om.macro.FieldTools.*;
import sys.FileSystem;
import sys.io.File;

using om.Path;
using om.StringTools;
using om.macro.FieldTools;

private enum abstract ShaderType(String) from String to String {
	var FS;
	var VS;
}

class BuildShader {

	static function build() : Array<Field> {

		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var cl = Context.getLocalClass().get();
		
		//TODO: allow to specify custom path
		//TODO: allow to specify path as @:fs("path-to-shader-file")

		//trace("----------------------------"+cl.name);
		//trace( "Context.getPosInfos(pos).file );

		var path = Context.getPosInfos( pos ).file.directory();

		function addShaderSourceField( type : ShaderType ) {
			if( !fields.hasField( type ) ) {
				var ext : String = type;
				ext = ext.toLowerCase();
				var shaderFile = cl.name.substr( 0, cl.name.indexOf('Shader') ).toLowerCase()+'.'+ext;
				var shaderPath = '$path/$shaderFile';
				if( !FileSystem.exists( shaderPath ) )
					Context.error( 'shader source file not found [$shaderPath]', pos );
				var shaderSource = File.getContent( shaderPath ).trim();
				//shaderSource = shaderSource.split('\n').join('');
				fields.push({
					name: 'FS',
					access:[AStatic],
					kind: FVar( macro : String, macro $v{shaderSource} ),
					pos: pos
				});

			}
		}

		addShaderSourceField( FS );
		//TODO: addShaderSourceField( VS );

		return fields;
	}
}

#end
