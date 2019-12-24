package com.mindrocks.text;

@:forward abstract ParseResult<I,T>(ParseResultT<I,T>) from ParseResultT<I,T>{
  @:noUsing static public inline function fail<I,T>(error,rest, isError : Bool):ParseResult<I,T>{
    return ParseResultT.Failure(error,rest,isError);
  }
  public function pos() : Input<I>
    return switch (this) {
      case Success(_, xs)     : xs;
      case Failure(_, xs, _)  : xs;
    }

  public function match(p : ParseResult<I,T>)
    return switch (this) {
      case Success(x, _)    : Std.string(x);
      case Failure(_, _, _) : "";
    }
  inline public function elide<U>() : ParseResult<I,U> return cast(this);

  public function mkLR(rule,head){
    return ParseResults.mkLR(this,rule,head);
  }
  public function fold<Z>(succ:T->Input<I>->Z,fail:FailureStack->Input<I>->Bool->Z){
    return switch(this){
      case Success(match, xs)                 : succ(match,xs);
      case Failure(errorStack, xs, isError)   : fail(errorStack,xs,isError);
    }
  }
  public function sfold<Z>(succ:ParseResult<I,T>->T->Input<I>->Z,fail:ParseResult<I,T>->FailureStack->Input<I>->Bool->Z){
    return switch(this){
      case Success(m, xs)                     : succ(this,m,xs);
      case Failure(errorStack, xs, isError)   : fail(this,errorStack,xs,isError);
    }
  }
  public function toString(){
    return fold(
      (v:T,i:Input<I>)  -> '$v',
      (e,_,_)           -> e.toString()
    );
  }
  public function isSuccess(){
    return fold(
      (_,_)   -> true,
      (_,_,_) -> false
    );
  }
}