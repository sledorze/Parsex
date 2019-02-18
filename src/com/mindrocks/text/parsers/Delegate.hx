package com.mindrocks.text.parsers;

class Delegate<I,O> extends Base<I,O,Parser<I,O>>{
  public function new(delegation,?id){
    super(delegation,id);
  }
  override public function parse(ipt){
    return this.delegation.parse(ipt);
  }
}