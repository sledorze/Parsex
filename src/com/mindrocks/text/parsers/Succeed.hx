package com.mindrocks.text.parsers;

class Succeed<I,O> extends Direct<I,O>{
  var value : O;
  public function new(value){
    super();
    this.value = value;
  }
  override public function parse(ipt){
    return succeed(this.value,ipt); 
  }
}