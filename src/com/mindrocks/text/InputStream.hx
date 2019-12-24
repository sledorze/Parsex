package com.mindrocks.text;

/**
 * ...
 * @author 0b1kn00b
 */
import Type;

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
class Enumerable<C,T> extends Indexable	<C,T> {
	
	public function new(d,?i) {
		super(d, i);
	}
	public function next():T {
		var o = this.at(this.index);
		index++;
		return o;
	}
	public function hasNext():Bool {
		//trace(index);
		return index < length;
	}
	public function setIndex(i:Int):Enumerable<C,T> {
		throw "abstract function";
		return this;
	}
	public function match(fn:T -> Bool,at:Int):Bool{
		throw "abstract function";
		return false;
	}
	public function prepend(v:T):Enumerable<C,T> {
		throw "abstract function";
		return null;
	}
	public function range(loc:Int,?len:Null<Int>):C {
		throw "abstract function";
		return null;
	}
}
class StringEnumerable extends Enumerable<String,String>{
	public function new(v, ?i) {
		super(v, i);
	}
	override public function at(i:Int) {
		return this.data.charAt(this.index);
	}
	override private function get_length() {
		return this.data.length;
	}
	override public function prepend(v:String):Enumerable<String,String> {
		var left 	= this.data.substr(0, index);
		var right = this.data.substr(index);
		
		return new StringEnumerable( this.data = left + v + right , this.index );
	}
	override public function range(loc:Int, ?len:Null<Int>):String {
		if (len == null ) len = this.length - loc;
		return data.substr(loc, len);
	}
	override public function match(e:String->Bool,at:Int){
		return e(this.range(at));
	}
	override public function setIndex(i:Int):Enumerable<String,String>{
		return new StringEnumerable(this.data,i);
	}
}
class ArrayEnumerable<T> extends Enumerable < Array<T>, T > {
	public function new(v,?i) {
		super(v, i);
	}
	override public function at(i:Int):T {
		return this.data[i];
	}
	override private function get_length() {
		return this.data.length;
	}
	override public function prepend(v:T):Enumerable<Array<T>,T> {
		var out = this.data.copy();
				out.insert(this.index, v);
		return new ArrayEnumerable( out , this.index );
	}
	override public function range(loc:Int, ?len:Null<Int>):Array<T> {
		len = len == null ? length - loc : len;
		return data.slice(loc, loc + len);
	}
}

class Indexable<C,T>{
	public var data : C;
	public var index : Int;
	public function new(data,?index = 0) {
		this.data 	= data;
		this.index	= index;
	}  
	public function at(i):T {
		throw "abstract method";
		return null;
	}	
	public var length (get, null):Int;
	private function get_length():Int {
		throw "abstract method";
		return -1;
	}
}

class StringIterator {
	private var ln		: Int;
	private var data 	: String;
	public var index 	: Int;
	
	public function new(data) {
		this.data = data;
		this.ln		= data.length;
	}
	public function next():String {
		var o = this.data.charAt(this.index);
		this.index++;
		return o;
	}
	public function hasNext():Bool {
		return this.index < this.ln;
	}
}