package com.mindrocks.text;


@:forward abstract FailureStack(FailureStackT) from FailureStackT to FailureStackT{
  static inline public function nil(){
    return List.nil();
  }
  public function cons(x):FailureStack{
    return this.cons(x);
  }
  public function isParseFail(){
    return this.last().msg == ParseFail.failed;
  }
  public function toParseResult<I,T>(rest : Input<I>, isError):ParseResult<I,T>{
    return Failure(this,rest,isError);
  }
  public function toString(){
    return this.fold(
      (memo,msg) -> '$memo,$msg',
      ""
    );
  }
}