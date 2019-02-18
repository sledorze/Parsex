package com.mindrocks.text.parsers;

class Many<I,O> extends Base<I,Array<O>,Parser<I,O>>{
  public function new(delegation,?id){
    super(delegation,id);
  }
  override public function parse(input){

    var parser  = delegation;
    var arr     = [];
    var matches = true;
        while (matches) {
          var res = parser.parse(input);
          switch (res) {
            case Success(m, r): arr.push(m); input = r;
            case Failure(_, _, isError):
              if (isError) {
                return res.elide();
              } else
                matches = false;
          }
        }
    return Success(arr, input);
  }

}