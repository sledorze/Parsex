package com.mindrocks.text.parsers;

class Regex extends Direct<String,String>{
  var stamp : EReg;
  public function new(stamp,?id){
    super(id);
    this.stamp = stamp;
  }
  override public function parse(ipt:Input<String>){
    return if (ipt.matchedBy(stamp)) {
        var pos = stamp.matchedPos();
        if (pos.pos == 0) {
          succeed(ipt.take(pos.len), ipt.drop(pos.len));
        } else {
          failed(
            '$stamp not matched at position ${ipt.offset} '.errorAt(ipt)
            .newStack()
            , ipt
            , false
          );
        }
      } else {
        failed('$stamp not matched'.errorAt(ipt).newStack(), ipt, false);
      }
  }
}