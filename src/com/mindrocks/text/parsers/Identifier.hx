package com.mindrocks.text.parsers;

class Identifier extends Direct<String,String>{
  var stamp : String;
  public function new(stamp,?id){
    super(id);
    this.stamp = stamp;
  }
  override public function parse(ipt:Input<String>){
    return if(ipt.startsWith(stamp)) {
      succeed(stamp, ipt.drop(stamp.length));
    }else{
      failed(
        '$stamp expected and not found'.errorAt(ipt).newStack()
        , ipt
        , false
      );
    }
  }
  override public function getDelegation(){
    return cast DDirect(name());
  }
}