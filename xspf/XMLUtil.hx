package xspf;

class XMLUtil {
	
	public static function attach( x : Xml, src : Dynamic, name : String ) {
		var v = Reflect.field( src, name );
		if( v != null ) x.addChild( createElement( name, Std.string(v) ) );
	}
	
	public static function createElement( name : String, content : String ) : Xml {
		var x = Xml.createElement( name );
		x.addChild( Xml.createPCData( content ) );
		return x;
	}
	
}
