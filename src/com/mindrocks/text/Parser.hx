package com.mindrocks.text;

@:forward abstract Parser<I,O>(Interface<I,O>) to Interface<I,O>{
  public function new(self:Interface<I,O>){
    this = self;
  }
  @:noUsing static inline public function eof<O>():Parser<String,O>{
    return Parsers.eof;
  }
  @:noUsing @:from static inline public function fromConstructor<I,O>(fn:Void->Parser<I,O>):Parser<I,O>{
    return pure(new LAnon(fn));
  }
  @:noUsing @:from static inline public function fromInterface<I,O>(it:Interface<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  @:noUsing @:from static inline public function fromFunction<I,O>(f:Input<I>->ParseResult<I,O>):Parser<I,O>{
    return new Anon(f);
  }
  @:noUsing static inline public function pure<I,O>(it:Interface<I,O>):Parser<I,O>{
    return new Parser(it);
  }
  public function mkHead() : Head return {
    headParser    : cast elide(),
    involvedSet   : List.nil(),
    evalSet       : List.nil()
  }
  inline public function elide<U>() : Parser<I,U> return cast(pure(this));

  inline public function andWith<U,V>(that:Parser<I,U>,fn:O->U->V):Parser<I,V>{
    return Parsers.andWith(pure(this),that,fn);
  }
  inline public function and<U>(that:Parser<I,U>):Parser<I,Tuple2<O,U>>{
    return Parsers.and(pure(this),that);
  }
  inline public function _and<U>(that:Parser<I,U>):Parser<I,U>{
    return Parsers._and(pure(this),that);
  }
  inline public function and_<U>(that:Parser<I,U>):Parser<I,O>{
    return Parsers.and_(pure(this),that);
  }


  inline public function or(that:Parser<I,O>):Parser<I,O>{
    return Parsers.or(pure(this),that);
  }


  inline public function many():Parser<I,Array<O>>{
    return Parsers.many(pure(this));
  }
  inline public function oneMany():Parser<I,Array<O>>{
    return Parsers.oneMany(pure(this));
  }


  inline public function commit():Parser<I,O>{
    return Parsers.commit(pure(this));
  }

  inline public function then<U>(fn:O->U):Parser<I,U>{
    return Parsers.then(pure(this),fn);
  }
  inline public function andThen<U>(fn:O->Parser<I,U>):Parser<I,U>{
    return Parsers.andThen(pure(this),fn);
  }
  inline public function trace(fn):Parser<I,O>{
    return Parsers.trace(pure(this),fn);
  }
  inline public function filter(fn:O->Bool):Parser<I,O>{
    return Parsers.filter(pure(this),fn);
  }

  inline public function tag(tag : String):Parser<I,O> {
    return Parsers.tag(pure(this),tag);
  }
  inline public function xs(fn):Parser<I,O>{
    return Parsers.xs(pure(this),fn);
  }

  inline public function repsep<U>(sep:Parser<I,U>):Parser<I,Array<O>>{
    return Parsers.repsep(pure(this),sep);
  }
  inline public function rep1sep<U>(sep:Parser<I,U>):Parser<I,Array<O>>{
    return Parsers.rep1sep(pure(this),sep);
  }
  inline public function memo():Parser<I,O>{
    return LRs.memo(pure(this));
  }
  inline public function recall(genKey : Int -> String, input : Input<I>) : Option<MemoEntry>{
    return LRs.recall(pure(this),genKey,input);
  }
  inline public function lrAnswer(genKey : Int -> String, input: Input<I>, growable: LR){
    return LRs.lrAnswer(pure(this),genKey,input,growable);
  }
}