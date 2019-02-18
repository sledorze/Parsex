package com.mindrocks.text.parsers;

class LAnon<I,O> extends Anon<I,O>{
  var closure : Void -> Parser<I,O>;
  public function new(closure){
    super(null);
    this.closure = closure;
  }
  override public function parse(ipt){
    trace('parsing');
    return if(method == null){
      var spoof : Dynamic = null;
      if(spoof == null){
        spoof = (false);
        spoof = closure();
      }
      method = spoof;
      method(ipt);
    }else{
      method(ipt);
    }
  }
}