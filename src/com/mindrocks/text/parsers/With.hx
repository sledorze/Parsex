package com.mindrocks.text.parsers;

class With<I,T,U,V> extends Base<I,V,Tuple2<Parser<I,T>,Parser<I,U>>>{
  var transform  : T -> U -> V;
  public function new(l,r,transform,?id){
    super({a:l,b:r},id);
    this.transform  = transform;
  }
  override public function sanity(){
    if(delegation == null){
      throw "null delegation";
    }
  }
  override public function parse(input:Input<I>){
    sanity();
    return switch (delegation.a.parse(input)) {
          case Success(m1, r) :
            switch (delegation.b.parse(r)) {
              case Success(m2, r) : 
                succeed(transform(m1, m2), r);
              case x : 
                x.elide();
            }
          case x: x.elide();
        }  
    }
  override public function getDelegation(){
    return cast DDisj(this.delegation);
  }
}