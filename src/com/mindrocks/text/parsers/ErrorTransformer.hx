package com.mindrocks.text.parsers;

class ErrorTransformer<I,O> extends Delegate<I,O>{
  var transformer : String -> String;
  public function new(delegation,transformer,?id){
    super(delegation,id);
    this.transformer = transformer;
  }
  override public function parse(ipt){
    return switch(delegation.parse(ipt)) {
      case Failure(err, input, isError): 
        Failure(
          err.report(
            (transformer(err.head.msg))
              .errorAt(input)
          )
          , input
          , isError);
      case r: 
        r;
    }
  }
}