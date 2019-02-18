package com.mindrocks.text;

@:forward abstract LR(LRT) from LRT{
  public function pos<I>() : Input<I> return
    switch(this.seed) {
      case Success(_, xs): xs;
      case Failure(_, xs, _): xs;
    }
}