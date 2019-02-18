package com.mindrocks.text;

class Lift{
  static public inline function errorAt<I>(msg : String, pos : Input<I>) : FailureMsg {
    return {
      msg : msg,
      pos : pos.offset
    };
  }
  static public inline function newStack(failure : FailureMsg) : FailureStack {
    var newStack = FailureStack.nil();
    return newStack.cons(failure);
  }
  static public inline function report(stack : FailureStack, msg : FailureMsg) : FailureStack {
    return stack.cons(msg);
  }

  static public inline function fail<I,T>(msg : String, isError : Bool) : Parser<I,T>
    return new Failed(msg,isError);
  
  static public inline function success<I, T>(v : T):Parser<I,T>  
	  return Parser.pure(new Succeed(v));
  
  static public inline function identifier(str:String,?pos:PosInfos){
    return Parsers.identifier(str,pos);
  }
  static public inline function ors<I,O>(arr:Array<Parser<I,O>>){
    return Parsers.ors(arr);
  }
  static public inline function option<I,O>(ps:Parser<I,O>):Parser<I,Option<O>>{
    return Parsers.option(ps);
  }
  static public inline function regexParser(r:EReg,?pos):Parser<String,String>{
    return Parsers.regexParser(r,pos);
  }
  static public inline function lazy<I,O>(f:Void->Parser<I,O>):Parser<I,O>{
    return Parser.fromConstructor(f);
  }
}