package com.mindrocks.text;

class Tools {
	public static function enumerable < C, T > (v:C):Enumerable < C, T > {
		//TODO ugh.
		var o : Enumerable<C,T> = null;
		cast( switch( Type.typeof(v) ) {
				case 		TClass(c)	: switch (Type.getClassName(c)) {
						case "Array" 	: o = cast new ArrayEnumerable(cast v);
						case "String"	: o = cast new StringEnumerable(cast v);
						default 		: throw "no Enumerable found for " + c;
				}
				default : throw "no Enumerable found for: " + v;
				}
		);
		return o;
	}
	public static function isSequencable(v:Dynamic) {
			return switch( Type.typeof(v) ) {
				case 		TClass(c)	: switch (Type.getClassName(c)) {
						case "Array" 	: true;
						case "String"	: true;
						default 			: false; 
				}
				default : false;
			}
	}
	public static function isImmutable(x:Dynamic) {
		return ( x == null || Std.is(x, Bool) || Std.is(x, Float) || Std.is(x, String) ) ;
	}
}