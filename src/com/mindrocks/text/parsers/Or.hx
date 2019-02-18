package com.mindrocks.text.parsers;

class Or<I,O> extends Base<I,O,Tuple2<Parser<I,O>,Parser<I,O>>>{
  public function new(fst,snd,?id){
    super(
      Tuples.t2(fst,snd),
      id
    );
  }
  override public function parse(ipt:Input<I>):ParseResult<I,O>{
    return delegation.a.parse(ipt).sfold(
      (res,_,_)     -> res,
      (res,_,_,er)  -> er? res : delegation.b.parse(ipt) 
    );
  }
  override public function getDelegation<A,B>():Delegated<A,B>{
    return cast DConj(delegation);
  }
}