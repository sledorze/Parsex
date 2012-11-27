package com.mindrocks.functional;
  
/**
 * ...
 * @author sledorze
 */

// Minimal functionnal API.
 
typedef Tuple2<A,B> = { a : A, b : B } 

class Tuples {
  public static function t2<A,B>(a : A, b : B) : Tuple2<A,B> return { a : a, b : b }
}

enum Option<T> {
  None;
  Some(x: T);
}

typedef Lazy<T> = Void -> T

class Functionnal {

  public static function get<T>(o : Option<T>) : T
    switch(o) {
      case Some(x) : return x;
      default : throw "Error Option get on None";
    }  
}


// TODO: would using an enum be faster?
// Stax does add comparing functions etc. but this library does not require
// such.
class List<T> {
  
  public var head (get_head, null): T;
  public var tail (get_tail, null): List<T>;

  private var _headV : T;
  private var _tailV : List<T>;
  
  function get_head() : T {
    return _headV;
  }
  function get_tail() : List<T> {
    return _tailV;
  }
    
  public function new(v : T, t : List<T>) {
    this._headV = v;
    this._tailV = t;
  }
  inline public static function nil<T>() : List<T>
    return Nil._nil
    
  inline public static function cons<T>(t : List<T>, v : T) : List<T> {
    return new List(v, t);
  }
  public function isEmpty() {
    return false;
  }
  public static function contains<T>(l : List<T>, v : T) : Bool {
    while (!l.isEmpty()) {
      if (l.head == v)
        return true;
      l = l.tail;
    }
    return false;
  }

  public static function filter<T>(l : List<T>, p : T -> Bool) : List<T>  {
    if (l.isEmpty())
      return nil();
    else {
      var v = l.head;
      var tail = filter(l.tail, p);
      if (p(v)) {
        return cons(tail, v);
      } else {
        return tail;    
      }
    }
  }

  public static function each<T>(l : List<T>, p : T -> Void) {
    if (l.isEmpty())
      nil();
    else {
      p(l.head);
      var l = l.tail;
    }
  }

  public static function map<A,B>(l : List<A>, p : A -> B) : List<B>  {
    if (l.isEmpty())
      return new Nil();
    else
      return new List(p(l.head), map(l.tail, p));
  }

  public static function last<A>(l : List<A>) : A  {
    var r:List<A> = null;
    while (true){
      if (Std.is(l, Nil))
        if (r == null)
          throw "last called on Nil";
        else return r.get_head()
      else {
        r = l;
        l = l.tail;
      }
    }
    return null; // dummy line, never used
  }

}

class Nil<T> extends List<T> {

  public function new() {
    super(null, null);
  }

  public static var _nil = new Nil();

  override public function isEmpty() {
    return true;
  }
  override function get_head() : T {
    throw "Cannot access head of Nil";
    return null;
  }
  override function get_tail() : List<T> {
    throw "Cannot access tail of Nil";
    return null;
  }
  
}
