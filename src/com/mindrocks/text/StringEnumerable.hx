package com.mindrocks.text;

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