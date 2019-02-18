package com.mindrocks.text;

import com.mindrocks.text.InputStream;

using com.mindrocks.functional.Functional;

using Lambda;
using com.mindrocks.text.Parser;

/**
 * ...
 * @author sledorze
 */




class ParserConstructorImpl<I,T>{
  static var constructors : Array<ParserConstructorImpl<Dynamic,Dynamic>> = [];

  static public function find<I,O>(v:Void->Parser<I,O>):ParserConstructorImpl<I,O>{
    return cast constructors.find(
      (x) -> return x.get == v || x.getter == v
    );
  }
  static public function generate<I,T>(v:Void->Parser<I,T>):ParserConstructorImpl<I,T>{
    var cached : ParserConstructorImpl<I,T> =  find(v);
    if(cached == null){
      trace("cache miss");
      cached = new ParserConstructorImpl(v);
      constructors.push(cached);
    }else{
      trace("get cached");
    }
    return cast cached;
  } 
  public var getter : Void->Parser<I,T>;
  var value  : Parser<I,T>;
  function new(getter){
    this.getter = getter;
  }
  public function get(){
    if(value == null){
      var r = null;
      if(r == null){
        r = untyped (false);
        r = getter();
      }
      value = r;
    }
    return value;
  }
}