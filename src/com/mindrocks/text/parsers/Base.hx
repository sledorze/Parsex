package com.mindrocks.text.parsers;

class Base<I,O,T> implements Interface<I,O,T>{
  static var constructors      : Array<Parser<Dynamic,Dynamic>> = [];
  public var id(get,null)      : Int;
  public function get_id(){
    return id;
  }
  var delegation                : T;
  public function new(?delegation,?id){
    this.delegation = delegation;
        this.id     = id;
  }
  public function parse(ipt:Input<I>):ParseResult<I,O>{
    return "default implementation".errorAt(ipt).newStack().toParseResult(ipt,true);
  }
  public function asParser():Interface<I,O,Dynamic>{
    return cast this;
  }
  public function getDelegation():Delegated<Dynamic,Dynamic>{
    return DDirect(name());
  }
  public function sanity(){
    throw "sanity not implemented";
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