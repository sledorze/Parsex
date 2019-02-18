package com.mindrocks.text;

@:forward abstract Head(HeadT) from HeadT{
  public function getHead<I,T>() : Parser < I, T > {
    return cast(this.headParser);
  }
}