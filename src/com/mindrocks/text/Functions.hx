package com.mindrocks.text;

class Functions{
  static public function succeed<I,O>(x:O,xs:Input<I>):ParseResult<I,O>{
    return Success(x,xs);
  }
  static public function failed<I,O>(stack,xs,isError):ParseResult<I,O>{
    return Failure(stack,xs,isError);
  }
}