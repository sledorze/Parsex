package com.mindrocks.text;

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