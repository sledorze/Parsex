package com.mindrocks.text;

@:forward abstract Memo(MemoT) from MemoT{
  inline public function get(key : MemoKey) : Option<MemoEntry> {
    var value = this.memoEntries.get(key);
    if (value == null) {
      return None;
    } else {
      return Some(value);
    }
  }
}