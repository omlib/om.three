package om.three;

#if macro

import haxe.macro.Compiler;
import haxe.macro.Context;
import sys.FileSystem;

using StringTools;

class Lib {

	static function build() {
		var pos = Context.currentPos();
		var includeJsFiles = Context.defined( 'om_three_include_js' );
		var listIncludedJsFiles = Context.defined( 'om_three_include_js_list' );
		if( listIncludedJsFiles ) includeJsFiles = true;
		if( includeJsFiles ) {
			var path : String = null;
			for( cp in Context.getClassPath() ) {
				if( cp.endsWith( 'om/three/src/' ) ) {
					path = cp.substr( 0, cp.length - 5 );
					break;
				}
			}
			if( path == null )
				Context.error( 'failed to resolve om.three library path', pos );
			Context.onGenerate( function(types){
				for( type in types ) {
					switch type {
					case TInst(t,params):
						var ct = t.get();
						if( ct.isExtern ) {
							var pack = ct.pack;
							if( pack[0] == 'om' && pack[1] == 'three' ) {
								var jsPath = '$path/res/script/'+pack[2]+'/'+ct.name+'.js';
								if( FileSystem.exists( jsPath ) ) {
									Compiler.includeFile( jsPath, Top );
									if( listIncludedJsFiles ) {
										Sys.println( 'include $jsPath' );
									}
								}
							}
							/*
							//TODO: allow to specify custom js path @:js("<path>")
							if( ct.meta.has(':js') ) {
								//trace(ct.meta.extract(':js')[0].params);
							}
							*/
						}
					default:
					}
				}
			});
		}
	}
}

#end
