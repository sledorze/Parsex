package com.mindrocks.text;

abstract UID(Int) to Int{
  public function new(){
    this = UIDs.parserUid();
  }
}
private class UIDs{
  static var _parserUid = 0;
  public static function parserUid() {
    return ++_parserUid;
  }
}