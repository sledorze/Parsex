package com.mindrocks.text;

import com.mindrocks.text.ParseResult;

abstract ParseFail(ParseResult<Dynamic,Dynamic>) to ParseResult<Dynamic,Dynamic>{
  public static var failed : String = "Base Failure";
  function new(self){
    this = self;
  }
  @:noUsing static public function at<I,T>(ipt:Input<I>):ParseFail{
    return new ParseFail(failed.errorAt(ipt).newStack().toParseResult(ipt,false));
  }
}