package com.mindrocks.text;

class ReaderObj {

  

  

  inline public static function reader(str : String) : Input<String> return {
    content : Tools.enumerable(str),
    offset : 0,
    memo : {
      memoEntries : new Map<String,MemoEntry>(),
      recursionHeads: new Map<String,Head>(),
      lrStack : List.nil()
    }
  }

  
}