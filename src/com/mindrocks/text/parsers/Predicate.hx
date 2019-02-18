package com.mindrocks.text.parsers;

class Predicate<I,O> extends Delegate<I,O>{
  var predicate :  O -> Bool;
  public function new(delegation,predicate,?id){
    super(delegation,id);
    this.predicate = predicate;
  }
  override public function parse(ipt:Input<I>):ParseResult<I,O>{
    return new AndThen(delegation,
      (o:O) -> predicate(o) ? o.success() : "predicate failed".fail(false)
    ).parse(ipt);
  }
}