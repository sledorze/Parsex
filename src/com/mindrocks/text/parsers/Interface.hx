package com.mindrocks.text.parsers;

@:allow(com.mindrocks)interface Interface<I,O>{
  //var pos(default,null)           
  var id(get,null)                  : Int;
  public function get_id():Int;

  public function parse(ipt:Input<I>):ParseResult<I,O>;
}