package com.mindrocks.text.parsers;

class Ors<I,T> extends Base<I,T,Array<Parser<I,T>>>{
  public function new(delegation,?id){
    super(delegation,id);
  }

  override public function parse(ipt){
    var pIndex = 0;
    while (pIndex < delegation.length) {
      var p   = delegation[pIndex];
      if(p == null){
        //p = '${delegation.length} $pIndex'.fail(true);
      }
      //trace(p);
      var res = p.parse(ipt);
      switch (res) {
        case Success(_, _) : 
          return res;
        case Failure(_, _, isError) :
          if (isError || (++pIndex == delegation.length)){
            return res; // isError means that we commited to a parser that failed; this reports to the top..
          }
      };
    }
    return failed("none match".errorAt(ipt).newStack(), ipt, false);
  }

}