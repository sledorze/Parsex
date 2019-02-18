package com.mindrocks.text.parsers;

class Base<I,O,T> implements Interface<I,O>{
  public var id(get,null)      : PosInfos;
  public function get_id(){
    return id;
  }
  public var uid(default,null)  : Int;

  var delegation                : T;
  public function new(?delegation,?id:PosInfos){
    this.delegation = delegation;
    this.id         = id;
  }
  public function parse(ipt:Input<I>):ParseResult<I,O>{
    return "default implementation".errorAt(ipt).newStack().toParseResult(ipt,true);
  }
  public function asParser():Parser<I,O>{
    return Parser.pure(this);
  }
  function succeed(x:O,xs:Input<I>):ParseResult<I,O>{
    return Success(x,xs);
  }
  function failed(stack,xs,isError):ParseResult<I,O>{
    return Failure(stack,xs,isError);
  }
  function name(){
    return Type.getClassName(Type.getClass(this)).split(".").pop();
  }
}