package com.mindrocks.text;

@:native("Parsers") class Parsers {
  static public inline function or<I,T>(p1 : Parser<I,T>, p2 : Parser<I,T>):Parser <I,T>{
    return new Or(p1,p2).asParser();
  }
  static public inline function ors<I,T>(ps:Array<Parser<I,T>>):Parser<I,T>{
    return new Ors(ps).asParser();
  }
  static public inline function then<I,T,U>(p:Parser<I,T>,f : T -> U):Parser<I,U>{
    return new Then(p,f).asParser();
  }
  static public inline function andThen<I,T,U>(p:Parser<I,T>,fn:T->Parser<I,U>):Parser<I,U>{
    return new AndThen(p,fn).asParser();
  }
  static public inline function many<I,T>(p1:Parser<I,T>):Parser<I,Array<T>>{
    return new Many(p1).asParser();
  }
  static public inline function oneMany<I,T>(p1:Parser<I,T>){
    return many(p1).filter(
      (arr) -> arr.length>0
    ); 
  }
  static public inline function and_<I,T,U>(p1:Parser<I,T>,p2 : Parser<I, U>):Parser <I,T> {
    return andWith(p1,p2, (a,_) -> a);
  }
  static public inline function and<I,T,U>(p1:Parser<I,T>,p2 : Parser<I,U>):Parser<I,Tuple2<T,U>>{
    return andWith(p1,p2,
      (l,r) -> Tuples.t2(l,r)
    );
  }
  
  @:native("__and") // Prevent a bug with hxcpp
  static public inline function _and<I,T,U>(p1:Parser<I,T>, p2 : Parser<I,U>):Parser<I,U> {
    return andWith(p1,p2, (_,b) -> b);
  }
  static public inline function andWith<I,T,U,V>(p1:Parser<I,T>,p2:Parser<I,U>,f:T->U->V):Parser<I,V>{
    return new With(p1,p2,f).asParser();
  }
  static public inline function commit<I,T> (p1 : Parser<I,T>):Parser <I,T>{
    return new Commit(p1).asParser();
  }
  static public inline function notEmpty<T>(arr:Array<T>):Bool return arr.length>0;


  static public inline function trace<I,T>(p : Parser<I,T>, f : T -> String):Parser<I,T> return
    return then(p,function (x:T) { trace(f(x)); return x;} );

  static public inline function xs<I,T>(p:Parser<I,T>, f : Input<I> -> Void):Parser<I,T>{
    return new Parser(new Anon(function(i:Input<I>):ParseResult<I,T>{
      var out = p.parse(i);
      f(out.pos());
      return out;
    }));
  }
  static public inline function identifier(x : String):Parser<String,String>{
    return new Identifier(x);
  }

  static public inline function regexParser(r : EReg):Parser<String,String>{
    return new Regex(r);
  }
    
  static public inline function rep1sep<I,T,U>(p1:Parser<I,T>,sep : Parser<I,U> ):Parser < I, Array<T> > {
    var next = many(_and(sep,p1));
    return then(and(p1,next),
      function (t:Tuple2<T,Array<T>>){ t.b.insert(0, t.a); return t.b;}
    ); /* Optimize that! */
  }
  static public inline function repsep<I,T,U>(p1:Parser<I,T>,sep : Parser<I,U> ):Parser < I, Array<T> > {
    return or(rep1sep(p1,sep),[].success());
  }
  static public inline function withError<I,T>(p:Parser<I,T>, f : String -> String ):Parser<I,T>
    return new ErrorTransformer(p,f).asParser();

  
  @:noUsing static public inline function tag<I,T>(p : Parser<I,T>, tag : String):Parser<I,T> {
    return withError(p, function (x) return '$tag expected in "$x"');
  } 
  static public inline function filter<I,T>(p:Parser<I,T>,fn:T->Bool):Parser<I,T>{
    return new AndThen(
      p,
      function(o){
        return fn(o) ? Parser.pure(new Succeed(o)) : Parser.pure(new Failed('filter failed',false)); 
      }
    ).asParser();
  }
  static public inline function option<I,T>(p:Parser<I,T>):Parser<I,Option<T>>{
    return new OptionP(p);
  }
  static public inline function eof<T>(input:Input<String>):ParseResult<String,T>{
    var err = 'not end of file'.errorAt(input).newStack();
    // trace(input.offset);
    // trace(input.content.length);
    // trace(input.content.hasNext());
    return !input.content.hasNext() ? Functions.succeed(null,input) : Functions.failed(err,input,false);
  }
}
