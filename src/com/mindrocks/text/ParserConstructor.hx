package com.mindrocks.text;

@:callable abstract ParserConstructor<I,T>(Void->Parser<I,T>) from Void->Parser<I,T>{

  public function new(self:Void->Parser<I,T>){
    this = ParserConstructorImpl.generate(self).get;
  }
  static public function enforce<I,T>(v:ParserConstructor<I,T>):ParserConstructor<I,T>{
    var out = new ParserConstructor(
      ParserConstructorImpl.find(v.prj()).get
    );
    if(out == null){
      out = new ParserConstructor(
        ParserConstructorImpl.generate(v.prj()).get
      );
    }
    return out;
  }
  public function prj(){
    return this;
  }
}