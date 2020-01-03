package com.mindrocks.text;

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