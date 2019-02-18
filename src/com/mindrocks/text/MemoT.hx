package com.mindrocks.text;

typedef MemoT = {
  memoEntries : Map<String,MemoEntry>,
  recursionHeads: Map<String,Head>, // key: position (string rep)
  lrStack : List<LR>
}