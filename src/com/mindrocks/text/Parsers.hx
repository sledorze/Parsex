package com.mindrocks.text;

@:native("Parsers") class Parsers {
  static public inline function or<I,T>(p1 : Interface<I,T>, p2 : Interface<I,T>):Interface <I,T>{
    return new Or(p1,p2);
  }
  static public inline function ors<I,T>(ps:Array<Interface<I,T>>):Interface<I,T>{
    return new Ors(ps);
  }
  static public inline function then<I,T,U>(p:Interface<I,T>,f : T -> U):Interface<I,U>{
    return new Then(p,f);
  }
  static public inline function andThen<I,T,U>(p:Interface<I,T>,fn:T->Interface<I,U>):Interface<I,U>{
    return new AndThen(p,fn);
  }
  static public inline function many<I,T>(p1:Interface<I,T>):Interface<I,Array<T>>{
    return new Many(p1);
  }
  static public inline function oneMany<I,T>(p1:Interface<I,T>){
    return many(p1).filter(
      (arr) -> arr.length>0
    ); 
  }
  static public inline function and_<I,T,U>(p1:Interface<I,T>,p2 : Interface<I, U>):Interface <I,T> {
    return andWith(p1,p2, (a,_) -> a);
  }
  static public inline function and<I,T,U>(p1:Interface<I,T>,p2 : Interface<I,U>):Interface<I,Tuple2<T,U>>{
    return andWith(p1,p2,
      (l,r) -> Tuples.t2(l,r)
    );
  }
  
  @:native("__and") // Prevent a bug with hxcpp
  static public inline function _and<I,T,U>(p1:Interface<I,T>, p2 : Interface<I,U>):Interface<I,U> {
    return andWith(p1,p2, (_,b) -> b);
  }
  static public inline function andWith<I,T,U,V>(p1:Interface<I,T>,p2:Interface<I,U>,f:T->U->V):Interface<I,V>{
    return new With(p1,p2,f);
  }
  static public inline function commit<I,T> (p1 : Interface<I,T>):Interface <I,T>{
    return new Commit(p1);
  }
  static public inline function notEmpty<T>(arr:Array<T>):Bool return arr.length>0;


  static public inline function trace<I,T>(p : Interface<I,T>, f : T -> String):Interface<I,T> return
    p.then(function (x:T) { trace(f(x)); return x;} );

  static public inline function identifier(x : String):Interface<String,String>{
    return new Identifier(x);
  }

  static public inline function regexInterface(r : EReg):Interface<String,String>{
    return new Regex(r);
  }
    
  static public inline function rep1sep<I,T,U>(p1:Interface<I,T>,sep : Interface<I,U> ):Interface < I, Array<T> > {
    var next = _and(sep,p1).many();
    return p1.and(next).then(
      function (t:Tuple2<T,Array<T>>){ t.b.insert(0, t.a); return t.b;}
    ); /* Optimize that! */
  }
  static public inline function repsep<I,T,U>(p1:Interface<I,T>,sep : Interface<I,U> ):Interface < I, Array<T> > {
    return rep1sep(p1,sep).or([].success());
  }
  static public inline function withError<I,T>(p:Interface<I,T>, f : String -> String ):Interface<I,T>
    return new ErrorTransformer(p,f);

  
  @:noUsing static public inline function tag<I,T>(p : Interface<I,T>, tag : String):Interface<I,T> {
    return withError(p, function (x) return '$tag expected in "$x"');
  } 
  static public inline function filter<I,T>(p:Interface<I,T>,fn):Interface<I,T>{
    return new AndThen(
      p,
      function(o){
        return fn(o) ? new Succeed(o) : new Failed('filter failed',false); 
      }
    );
  }
  static public inline function option<I,T>(p:Interface<I,T>):Interface<I,Option<T>>{
    return new OptionP(p);
  }
}
