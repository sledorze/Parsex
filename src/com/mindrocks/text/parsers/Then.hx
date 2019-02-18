package com.mindrocks.text.parsers;

class Then<I,T,U> extends Base<I,U,Parser<I,T>>{
  var transform : T -> U;
  public function new(delegation:Parser<I,T>,transform:T->U,?id){
    super(delegation,id);
    this.transform  = transform; 
  }
  override public function parse(input:Input<I>):ParseResult<I,U>{
    //trace(delegation);
    return switch(delegation.parse(input)){
      case Success(m, r)    :  Success(transform(m), r);
      case x                :  x.elide();
    };
  }

}