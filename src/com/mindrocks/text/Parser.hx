package com.mindrocks.text;

import com.mindrocks.text.InputStream;

import com.mindrocks.functional.Functional;
using com.mindrocks.functional.Functional;

import com.mindrocks.macros.LazyMacro;

using Lambda;
using com.mindrocks.text.Parser; 

/**
 * ...
 * @author sledorze
 */

typedef Input<I> = {
  content : Enumerable<Dynamic,I>,
  offset : Int,
  memo : Memo
}

typedef Memo = {
  memoEntries : Hash<MemoEntry>,
  recursionHeads: Hash<Head>, // key: position (string rep)
  lrStack : List<LR>
}

enum MemoEntry {
  MemoParsed(ans : ParseResult<Dynamic,Dynamic>);
  MemoLR(lr : LR);
}

typedef MemoKey = String

class ParserObj {
  inline public static function castType<I,T, U>(p : Parser<I,T>) : Parser<I,U> return 
    untyped p
}

class ResultObj {
  
  inline public static function castType<I,T, U>(p : ParseResult<I,T>) : ParseResult<I,U> return 
    untyped p
  
  public static function posFromResult<I,T>(p : ParseResult<I,T>) : Input<I>
    switch (p) {
      case Success(_, rest) : return rest;
      case Failure(_, rest, _) : return rest;
    }
    
  public static function matchFromResult<I,T>(p : ParseResult<I,T>) 
    switch (p) {
      case Success(x, _) : return Std.string(x);
      case Failure(_, _, _) : return "";
    }

}

class MemoObj {
  
  inline public static function updateCacheAndGet<I>(r : Input<I>, genKey : Int -> String, entry : MemoEntry) {
    var key = genKey(r.offset);
    r.memo.memoEntries.set(key, entry);    
    return entry;
  }
  public inline static function getFromCache<I>(r : Input<I>, genKey : Int -> String) : Option<MemoEntry> {
    var key = genKey(r.offset);
    var res = r.memo.memoEntries.get(key);
    return res == null?None: Some(res);
  }

  public inline static function getRecursionHead<I>(r : Input<I>) : Option<Head> {
    var res = r.memo.recursionHeads.get(r.offset + "");
    return res == null?None: Some(res);
  }
  
  public inline static function setRecursionHead<I>(r : Input<I>, head : Head) {
    r.memo.recursionHeads.set(r.offset + "", head);
  }

  public inline static function removeRecursionHead<I>(r : Input<I>) {
    r.memo.recursionHeads.remove(r.offset + "");
  }
  
  inline public static function forKey(m : Memo, key : MemoKey) : Option<MemoEntry> {
    var value = m.memoEntries.get(key);
    if (value == null) {
      return None;
    } else {
      return Some(value);
    }
  }
}

class ReaderObj {

  public static function textAround(r : Input<String>, ?before : Int = 10, ?after : Int = 10) : { text : String, indicator : String } {
    
    var offset = Std.int(Math.max(0, r.offset - before));
    
    var text = r.content.range(offset, before + after);
    
    var indicPadding = Std.int(Math.min(r.offset, before));
    var indicator = StringTools.lpad("^", "_", indicPadding+1);
    
    return {    
      text : text,
      indicator : indicator
    };
  }

  public static function errorMessage(r : Input<String>, msg: FailureStack){
    var x = r.textAround();

    var r = "";
    msg.each(function(err){
        r += "Error at " + err.pos + " : " + err.msg+"\n";
    });

    return r + " "+x.text+"\n"+x.indicator;
  } 
  
  inline public static function position<I>(r : Input<I>) : Int return
    r.offset
  
  inline public static function reader(str : String) : Input<String> return {
    content : Tools.enumerable(str),
    offset : 0,
    memo : {
      memoEntries : new Hash<MemoEntry>(),
      recursionHeads: new Hash<Head>(),
      lrStack : List.nil()
    }
  }
  
  inline public static function take(r : Input<String>, len : Int) : String {
    return r.content.range(r.offset, len);
  }
  
  inline public static function drop<I>(r : Input<I>, len : Int) : Input<I> {
    return {
      content : r.content,
      offset : r.offset + len,
      memo  : r.memo
    };
  }
  
  inline public static function startsWith(r : Input<String>, x : String) : Bool {    
    return take(r, x.length) == x;
  }
  
  inline public static function matchedBy(r : Input<String>, e : EReg) : Bool { // this is deadly unfortunate that RegEx don't support offset and first char maching constraint..
    return e.match(rest(r));
  }
  
  public inline static function rest(r : Input<String>) : String {
    return r.content.range(r.offset);
  }
}

class FailureObj {
  inline public static function newStack(failure : FailureMsg) : FailureStack {
    var newStack = FailureStack.nil();
    return newStack.cons(failure);
  }
  inline public static function errorAt<I>(msg : String, pos : Input<I>) : FailureMsg {
    return {
      msg : msg,
      pos : pos.offset      
    };
  }
  inline public static function report(stack : FailureStack, msg : FailureMsg) : FailureStack {
    return stack.cons(msg);
  }
}



typedef FailureStack = com.mindrocks.functional.List<FailureMsg>
typedef FailureMsg = {
  msg : String,
  pos : Int
}

enum ParseResult<I,T> {
  Success(match : T, rest : Input<I>);
  Failure(errorStack : FailureStack, rest : Input<I>, isError : Bool);
}

typedef Parser<I,T> = Input<I> -> ParseResult<I,T>

typedef LR = {
  seed: ParseResult<Dynamic,Dynamic>,
  rule: Parser<Dynamic,Dynamic>,
  head: Option<Head>
}

typedef Head = {
  headParser: Parser<Dynamic,Dynamic>,
  involvedSet: List<Parser<Dynamic,Dynamic>>,
  evalSet: List<Parser<Dynamic,Dynamic>>
}

@:native("Parsers") class Parsers {
  
  public static function mkLR<I,T>(seed: ParseResult<I,Dynamic>, rule: Parser<I,T>, head: Option<Head>) : LR return {
    seed: seed,
    rule: rule.castType(),
    head: head
  }
  
  public static function mkHead<I,T>(p: Parser<I,T>) : Head return {
    headParser: p.castType(),
    involvedSet: List.nil(),
    evalSet: List.nil()
  }
  
  public static function getPos<I>(lr : LR) : Input<I> return 
    switch(lr.seed) {
      case Success(_, rest): rest;
      case Failure(_, rest, _): rest;
    }

  public static function getHead < I, T > (hd : Head) : Parser < I, T > {
    var r : Parser < I, T > = untyped hd.headParser;
    return r;
  }
    
  static var _parserUid = 0;
  static function parserUid() {
    return ++_parserUid;  
  }
  
  
  static function lrAnswer<I,T>(p: Parser<I,T>, genKey : Int -> String, input: Input<I>, growable: LR): ParseResult<I,T> {
    switch (growable.head) {
      case None: throw "lrAnswer with no head!!";
      case Some(head): 
        if (head.getHead() != p) /*not head rule, so not growing*/{
          var r : ParseResult<I,T> = untyped growable.seed;
          return r;
        } else {
          input.updateCacheAndGet(genKey, MemoParsed(growable.seed));
          switch (growable.seed) {
            case Failure(_, _, _) :
              var r : ParseResult<I,T> = untyped growable.seed;
              return r;
            case Success(_, _) :
              return grow(p, genKey, input, head); /*growing*/ 
          }
        }
    }
  }
  
  static function recall<I,T>(p : Parser<I,T>, genKey : Int -> String, input : Input<I>) : Option<MemoEntry> {
    var cached = input.getFromCache(genKey);
    switch (input.getRecursionHead()) {
      case None: return cached;
      case Some(head):
        if (cached == None && !(head.involvedSet.cons(head.headParser).contains(p))) {
          return Some(MemoParsed(Failure("dummy ".errorAt(input).newStack(), input, false)));
        }          
        if (head.evalSet.contains(p)) {
          head.evalSet = head.evalSet.filter(function (x) return x != p);
          
          var memo = MemoParsed(p(input));
          input.updateCacheAndGet(genKey, memo); // beware; it won't update lrStack !!! Check that !!!
          cached = Some(memo);
        }
        return cached;
    }
  }
  
  static function setupLR<I>(p: Parser<I,Dynamic>, input: Input<I>, recDetect: LR) {
    if (recDetect.head == None)
      recDetect.head = Some(p.mkHead());
    
    var stack = input.memo.lrStack;

    var h = recDetect.head.get(); // valid (see above)
    while (stack.head.rule != p) {
      var head = stack.head;
      head.head = recDetect.head;
      h.involvedSet = h.involvedSet.cons(head.rule);
      stack = stack.tail;
    }
  }
  
  static function grow<I,T>(p: Parser<I,T>, genKey : Int -> String, rest: Input<I>, head: Head): ParseResult<I,T> {
    //store the head into the recursionHeads
    rest.setRecursionHead(head);
    var oldRes =
      switch (rest.getFromCache(genKey).get()) {
        case MemoParsed(ans): ans;
        default : throw "impossible match";
      };
      
    //resetting the evalSet of the head of the recursion at each beginning of growth
    
    head.evalSet = head.involvedSet;
    var res = p(rest);
    switch (res) {
      case Success(_, _) :        
        if (oldRes.posFromResult().offset < res.posFromResult().offset ) {
          rest.updateCacheAndGet(genKey, MemoParsed(res));
          return grow(p, genKey, rest, head);
        } else {
          //we're done with growing, we can remove data from recursion head
          rest.removeRecursionHead();
          switch (rest.getFromCache(genKey).get()) {
            case MemoParsed(ans):
              var r : ParseResult<I, T> = untyped ans;
              return r;
            default: throw "impossible match";
          }
        }
      case Failure(_, _, isError):
        if (isError) { // the error must be propagated  and not discarded by the grower!
          
          rest.updateCacheAndGet(genKey, MemoParsed(res));
          rest.removeRecursionHead();
          return res;
          
        } else {
          rest.removeRecursionHead();
          var r : ParseResult<I,T> = untyped oldRes;
          return r;
        }
        
    }
  }

  inline public static var baseFailure = "Base Failure";

  /**
   * Lift a parser to a packrat parser (memo is derived from scala's library)
   */
  public static function memo<I,T>(_p : Void -> Parser<I,T>) : Void -> Parser<I,T>
    return LazyMacro.lazy({
      // generates an uid for this parser.
      var uid = parserUid();
      function genKey(pos : Int) return uid+"@"+pos;
      function (input :Input<I>) {
        
        switch (recall(_p(), genKey, input)) {
          case None :
            var base = Failure(baseFailure.errorAt(input).newStack(), input, false).mkLR(_p(), None);
            
            input.memo.lrStack  = input.memo.lrStack.cons(base);
            input.updateCacheAndGet(genKey, MemoLR(base));
            
            var res = _p()(input);
            
            input.memo.lrStack = input.memo.lrStack.tail;
            
            switch (base.head) {
              case None:
                input.updateCacheAndGet(genKey, MemoParsed(res));
                return res;
              case Some(_):
                base.seed = res;
                return lrAnswer(_p(), genKey, input, base);
            }
            
          case Some(mEntry):            
            switch(mEntry) {
              case  MemoLR(recDetect):
                setupLR(_p(), input, recDetect);
                var r : ParseResult<I,T> = untyped recDetect.seed;
                return r;
              case  MemoParsed(ans):
                var r : ParseResult<I,T> = untyped ans;
                return r;
            }
        }
        
      };
    })
  
  public static function fail<I,T>(error : String, isError : Bool) : Void -> Parser <I,T>
    return LazyMacro.lazy(function (input :Input<I>) return Failure(error.errorAt(input).newStack(), input, isError))

  public static function success<I,T>(v : T) : Void -> Parser <I,T>
    return LazyMacro.lazy(function (input) return Success(v, input))

  public static function identity<I,T>(p : Void -> Parser<I,T>) : Void -> Parser <I,T> return p

  public static function andWith < I, T, U, V > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,U>, f : T -> U -> V) : Void -> Parser <I,V>
    return LazyMacro.lazy({
      function (input) {
        var res = p1()(input);
        switch (res) {
          case Success(m1, r) :
            var res = p2()(r);
            switch (res) {
              case Success(m2, r) : return Success(f(m1, m2), r);
              case Failure(_, _, _):
                var r : ParseResult<I, V> = untyped res;
                return r;
            }
          case Failure(_, _, _):
            var r : ParseResult<I, V> = untyped res;
            return r;
        }
      }
    })

  inline public static function and < I, T, U > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,U>) : Void -> Parser < I, Tuple2 < T, U >> return
    andWith(p1, p2, Tuples.t2)
    
    inline public static function sndParam<A,B>(_, b) return b
    
  inline public static function _and < I, T, U > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,U>) : Void -> Parser < I, U > return
    andWith(p1, p2, sndParam)

    inline public static function fstParam<A,B>(a, _) return a

  public static function and_ < I, T, U > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I, U>) : Void -> Parser < I, T > return
    andWith(p1, p2, fstParam)

  // aka flatmap
  public static function andThen < I, T, U > (p1 : Void -> Parser<I, T>, fp2 : T -> (Void -> Parser<I, U>)) : Void -> Parser < I, U >
    return LazyMacro.lazy({
      function (input) {
        var res = p1()(input);
        switch (res) {
          case Success(m, r): return fp2(m)()(r);
          case Failure(_, _, _):
            var r : ParseResult<I, U> =  untyped res; //Failure is not parametrized with T and U
            return r;
        }
      }
    })

  // map
  public static function then < I, T, U > (p1 : Void -> Parser<I,T>, f : T -> U) : Void -> Parser < I, U >
    return LazyMacro.lazy({
      function (input) {
        var res = p1()(input);
        switch (res) {
          case Success(m, r): return Success(f(m), r);
          case Failure(_, _, _):
            var r : ParseResult<I, U> = untyped res;
            return r;
        };
      }
    })

  static var defaultFail =
    fail("not matched", false);
    
  static public function forPredicate<T>(pred : T -> Bool) return function (x : T) return
    pred(x) ? success(x) : defaultFail  
    
  inline public static function filter<I,T>(p : Void -> Parser<I,T>, pred : T -> Bool) : Void -> Parser <I,T> return
    andThen(p, forPredicate(pred))
  
  /**
   * Generates an error if the parser returns a failure (an error make the choice combinator fail with an error without evaluating alternatives).
   */
  public static function commit < I, T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I, T >
    return LazyMacro.lazy( {
      function (input) {        
        var res = p1()(input);
        switch(res) {
          case Success(_, _): return res;
          case Failure(err, rest, isError) :
            return (isError || (err.last().msg == baseFailure))  ? res : Failure(err, rest, true);
        }
      }
    })
  
  public static function or < I,T > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,T>) : Void -> Parser < I, T >
    return LazyMacro.lazy({
      function (input) {
        var res = p1()(input);
        switch (res) {
          case Success(_, _) : return res;
          case Failure(_, _, isError) : return isError ? res : p2()(input); // isError means that we commited to a parser that failed; this reports to the top..
        };
      }
    })
  
/*
  public static function ors<T>(ps : Array < Void -> Parser<T> > ) : Void -> Parser<T> return {
    ps.fold(function (p, accp) return or(accp, p), fail("none match", false));
  }
*/    
  // unrolled version of the above one
  public static function ors<I,T>(ps : Array < Void -> Parser<I,T> > ) : Void -> Parser<I,T>
    return LazyMacro.lazy({
      function (input) {
        var pIndex = 0;
        while (pIndex < ps.length) {
          var res = ps[pIndex]()(input);
          switch (res) {
            case Success(_, _) : return res;
            case Failure(_, _, isError) :
              if (isError || (++pIndex == ps.length)) return res; // isError means that we commited to a parser that failed; this reports to the top..
          };
        }
        return Failure("none match".errorAt(input).newStack(), input, false);
      }
    })
    
  /*
   * 0..n
   */
  public static function many < I,T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I, Array<T> >
    return LazyMacro.lazy( {
      function (input) {
        var parser = p1();
        var arr = [];
        var matches = true;
        while (matches) {
          var res = parser(input);
          switch (res) {
            case Success(m, r): arr.push(m); input = r;
            case Failure(_, _, isError):
              if (isError) {
                var r : ParseResult<I, Array<T>> = untyped res;
                return r;                
              } else 
                matches = false;
          }
        }
        return Success(arr, input);
      }
    })

    
  static public function notEmpty<T>(arr:Array<T>) return arr.length>0
  /*
   * 1..n
   */
  inline public static function oneMany < I,T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I,Array<T> > return
    filter(many(p1), notEmpty)

  /*
   * 0..n
   */
  public static function rep1sep < I, T > (p1 : Void -> Parser<I,T>, sep : Void -> Parser<I,Dynamic> ) : Void -> Parser < I, Array<T> > return    
    then(and(p1, many(_and(sep, p1))), function (t) { t.b.insert(0, t.a); return t.b;}) /* Optimize that! */

  /*
   * 0..n
   */
  public static function repsep < I,T > (p1 : Void -> Parser<I,T>, sep : Void -> Parser<I,Dynamic> ) : Void -> Parser < I, Array<T> > return
    or(rep1sep(p1, sep), success([]))
    
  /*
   * Produce left recursive application of possible infix binary operators to p1 parsers.
   *
   * eg:
   * chainl1(numberParser, divSymbolParser.then((function (x:Float, y:Float) return x / y).success()));
   * which operating on 1 / 2 / 3
   * would parse and evaluate the result of (1 / 2) / 3
   *
   * p1 parser must be matched at least once.
   */
  public static function chainl1 < I,T > (p1 : Void -> Parser<I,T>, op : Void -> Parser<I,T->T->T> ) : Void -> Parser < I, T >
  {
    function rest (x : T) return
      op.andThen(function (f : T->T->T) return
        p1.andThen(function (y : T) return
          rest(f(x, y))
        )
      ).or(x.success());
      
    return p1.andThen(rest);
  }
    
    
  /*
   * 0..1
   */
  public static function option < I,T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I,Option<T> > return
    p1.then(Some).or(success(None))

  public static function trace<I,T>(p : Void -> Parser<I,T>, f : T -> String) : Void -> Parser<I,T> return
    then(p, function (x) { trace(f(x)); return x;} )

  public static function identifier(x : String) : Void -> Parser<String,String>
    return LazyMacro.lazy(function (input : Input<String>)
      if (input.startsWith(x)) {
        return Success(x, input.drop(x.length));
      } else {
        return Failure((x + " expected and not found").errorAt(input).newStack(), input, false);
      }
    )

  public static function regexParser(r : EReg) : Void -> Parser<String,String>
    return LazyMacro.lazy(function (input : Input<String>) return
      if (input.matchedBy(r)) {
        var pos = r.matchedPos();
        if (pos.pos == 0) {
          Success(input.take(pos.len), input.drop(pos.len));
        } else {
          Failure((Std.string(r) + "not matched at position " + input.offset ).errorAt(input).newStack(), input, false);
        }
      } else {
        Failure((r + " not matched").errorAt(input).newStack(), input, false);
      }
    )

  public static function withError<I,T>(p : Void -> Parser<I,T>, f : String -> String ) : Void -> Parser<I,T>
    return LazyMacro.lazy(function (input : Input<I>) {
      var r = p()(input);
      switch(r) {
        case Failure(err, input, isError): return Failure(err.report((f(err.head.msg)).errorAt(input)), input, isError);
        default: return r;
      }
    })
    
  public static function tag<I,T>(p : Void -> Parser<I,T>, tag : String) : Void -> Parser<I,T> return  
    withError(p, function (_) return tag +" expected")
  
}
