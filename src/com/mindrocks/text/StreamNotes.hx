typedef StreamT<T>	= {
	public function at(idx:Int):T;
	public function to(idx:Int):StreamT<T>;

	public var length(get,null):Int;
	function get_length():Int;

	public function prepend(x:Stream<T>):Stream<T>;

	public function range(loc:Int, ?len:Null<Int>):Iterator<T>;

	public function eof():Bool;
	public function iterator():Iterator<T>;
	public function match(v:T):Bool;
}
class StringSteam{
	var data 	: String;
	var idx 	: Int;

	public function new(data,?idx=0){
		this.data = data;
		this.idx 	= idx;
	}
	function copy(?data,?idx){
		return new StringSteam(data == null ? this.data : data, idx == null ? this.idx : idx ):
	}
	public function at(idx:Int){
		return this.data.charAt(idx);
	}
	public function to(idx:Int){
		return copy(null,idx);
	}
	public var length(get_length):Int;
	function length(){
		return this.data.length;
	}
	/*public function prepend(x:Stream<String>):Stream<String>{
		
	}*/
}
abstract Stream<T>(StreamT<T>) from StreamT<T>{

}