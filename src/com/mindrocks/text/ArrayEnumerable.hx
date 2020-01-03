package com.mindrocks.text;

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