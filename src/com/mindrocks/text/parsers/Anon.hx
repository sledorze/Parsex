package com.mindrocks.text.parsers;

class Anon<I,O> extends Direct<I,O>{

  var method : Input<I> -> ParseResult<I,O>;
  public function new(method,?id){
    super(id);
    this.method = method;
  }
  override public function parse(ipt){
    return this.method(ipt);
  }
}