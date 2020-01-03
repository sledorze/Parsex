package com.mindrocks.text;

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