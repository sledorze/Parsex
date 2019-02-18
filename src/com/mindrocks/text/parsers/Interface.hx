package com.mindrocks.text.parsers;


@:allow(com.mindrocks)interface Interface<I,O>{
  //var pos(default,null)           
  var id(get,null)                   : PosInfos;
  public function get_id():PosInfos;
  public var uid(default,null)              : Int;
  public function parse(ipt:Input<I>):ParseResult<I,O>;
}