package com.mindrocks.text;

typedef InputT<I> = {
  content   : Enumerable<Dynamic,I>,
  offset    : Int,
  memo      : Memo,
  ?tag      : String
}