package com.mindrocks.text;

@:forward abstract Parser<I,O>(Interface<I,O,Dynamic>) from Interface<I,O,Dynamic>{
  public function new(self:Interface<I,O,Dynamic>){
    this = new LAnon(
      () -> self
    );
  }
  public function mkHead() : Head return {
    headParser    : elide(),
    involvedSet   : List.nil(),
    evalSet       : List.nil()
  }
  inline public function elide<U>() : Parser<I,U> return cast(this);

  inline public function andWith<U,V>(that:Parser<I,U>,fn:O->U->V):Parser<I,V>{
    return Parsers.andWith(this,that,fn);
  }
  inline public function and<U>(that:Parser<I,U>):Parser<I,Tuple2<O,U>>{
    return Parsers.and(this,that);
  }
  inline public function _and<U>(that:Parser<I,U>):Parser<I,U>{
    return Parsers._and(this,that);
  }
  inline public function and_<U>(that:Parser<I,U>):Parser<I,O>{
    return Parsers.and_(this,that);
  }


  inline public function or(that:Parser<I,O>):Parser<I,O>{
    return Parsers.or(this,that);
  }


  inline public function many():Parser<I,Array<O>>{
    return Parsers.many(this);
  }
  inline public function oneMany():Parser<I,Array<O>>{
    return Parsers.oneMany(this);
  }


  inline public function commit():Parser<I,O>{
    return Parsers.commit(this);
  }

  inline public function then<U>(fn:O->U):Parser<I,U>{
    return Parsers.then(this,fn);
  }
  inline public function andThen<U>(fn:O->Parser<I,U>):Parser<I,U>{
    return Parsers.andThen(this,fn);
  }
  inline public function trace(fn):Parser<I,O>{
    return Parsers.trace(this,fn);
  }
  inline public function filter(fn):Parser<I,O>{
    return Parsers.filter(this,fn);
  }

  inline public function tag(tag : String):Parser<I,O> {
    return Parsers.tag(this,tag);
  }

  inline public function repsep<U>(sep:Parser<I,U>):Parser<I,Array<O>>{
    return Parsers.repsep(this,sep);
  }
  inline public function rep1sep<U>(sep:Parser<I,U>):Parser<I,Array<O>>{
    return Parsers.rep1sep(this,sep);
  }
  inline public function memo():Parser<I,O>{
    return LRs.memo(this);
  }
  inline public function recall(genKey : Int -> String, input : Input<I>) : Option<MemoEntry>{
    return LRs.recall(this,genKey,input);
  }
  inline public function lrAnswer(genKey : Int -> String, input: Input<I>, growable: LR){
    return LRs.lrAnswer(this,genKey,input,growable);
  }
}