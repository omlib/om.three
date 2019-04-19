package om.three.macro;

#if macro

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import om.macro.MacroTools.*;
//import om.macro.MacroFieldTools.*;

using om.macro.FieldTools;

// TODO: include shader source from external file
// TODO: build contructor (?)

class BuildShaderPass {

	/**
		Adds properties from uniform class parameter
	**/
	static function build() : Array<Field> {
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		var cl = Context.getLocalClass().get();
		//trace('###################################### '+cl.name);
		
		//var path = Context.getPosInfos(pos).file;
		//trace( path );
		///trace( "################ "+Context.getPosInfos(pos).file );

		/*
		trace(fields.hasField('FS'));
		if( !fields.hasField('FS') ) {
			trace('HAS NO FS field');
			trace(Sys.getCwd());
		}
		*/
		//trace(Sys.getCwd());

		var params = cl.superClass.params;
		//trace(cl.params);
		switch params[0] {
		case TType(t,params):
			switch t.get().type {
			case TAnonymous(a):
				for( f in a.get().fields ) {
					if( !f.isPublic )
						continue;
					switch f.name {
					case 'tDiffuse':
					default:
						if( fields.hasField( f.name ) ) {
							#if dev
							trace( 'Cannot create shaderpass property, field ['+f.name+'] already exists' );
							#end
							continue;
						}
						var propName = f.name;
						//trace(propName);
						switch f.type {
						case TAnonymous(a):
							for( f in a.get().fields ) {
								switch f.name {
								case 'type':
								case 'value':
									switch f.type {
									case TAbstract(t,params):
										var propType = TypeTools.toComplexType( t.get().type );
										addProperty( fields, propName, propType );
										break;
									case TInst(t,params):
										var type = t.get();
										//trace(type.name);
										//TODO: check if supported types
										/*
										switch type.name {
										case 'Color','Vector2':
										default: // unsupported type
										}
										*/
										addProperty( fields, propName,  TPath( { name: type.name, pack: type.pack } ) );
										break;
									
									default:
									}
								default:
									throw 'Unknown uniform field [${f.name}]';
								}
							}
						default:
						}
					}
				}
			default:
			}
		default:
		}
		return fields;
	}

	static function addProperty( fields : Array<Field>, name : String, type : ComplexType ) {
		//trace("addProperty: "+name );
		fields.push({
			//meta:[{name:':isVar',pos:pos}],
			access:[APublic],
			name: name,
			kind: FProp( 'get', 'set', type ),
			pos: Context.currentPos()
		});
		fields.push( createAccessorMethod( 'get', name, type ) );
		fields.push( createAccessorMethod( 'set', name, type ) );
	}

	static function createAccessorMethod( accessorType : String, name : String, type : ComplexType ) : Field {
		var identName = accessorType+'_'+name;
		var pos = Context.currentPos();
		var args = new Array<FunctionArg>();
		var exprStr = 'return uniforms.$name.value';
		if( accessorType == 'set' ) {
			args.push( { name:'v', type:type } );
			exprStr += '=v';
		}
		return {
			//meta:[{name:':keep',pos:pos}],
			access: [APublic,AInline],
			name: identName,
			kind: FFun( { args: args, ret: type, expr: Context.parse( exprStr, pos ) } ),
			pos: pos
		};
	}
}

#end
