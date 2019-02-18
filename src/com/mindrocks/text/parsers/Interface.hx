package com.mindrocks.text.parsers;

@:allow(com.mindrocks)interface Interface<I,O,T>{
  //var pos(default,null)           
  var id(get,null)                  : Int;
  public function get_id():Int;

  private var delegation            : T;
  public function parse(ipt:Input<I>):ParseResult<I,O>;
  public function sanity():Void;
  public function asParser():Interface<I,O,Dynamic>;
  public function getDelegation():Delegated<Dynamic,Dynamic>;
}