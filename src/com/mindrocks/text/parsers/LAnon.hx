package com.mindrocks.text.parsers;

class LAnon<I,O> extends Anon<I,O>{
  var closure : Void -> Parser<I,O>;
  public function new(closure){
    super(null);
    this.closure = closure;
  }
  override public function parse(ipt){
    return if(method == null){
      var spoof : Dynamic = null;
      if(spoof == null){
        spoof = (false);
        spoof = closure();
      }
      spoof.parse(ipt);
    }else{
      method(ipt);
    }
  }
}