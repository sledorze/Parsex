package com.mindrocks.text;

class LRs{
  static public function lrAnswer<I,T>(p: Parser<I,T>, genKey : Int -> String, input: Input<I>, growable: LR): ParseResult<I,T> {
    switch (growable.head) {
      case None: throw "lrAnswer with no head!!";
      case Some(head):
        if (head.getHead() != p) /*not head rule, so not growing*/{
          return cast(growable.seed);
        } else {
          input.updateCacheAndGet(genKey, MemoParsed(growable.seed));
          switch (growable.seed) {
            case Failure(_, _, _) :
              return cast(growable.seed);
            case Success(_, _) :
              return grow(p, genKey, input, head); /*growing*/
          }
        }
    }
  }
  static public function recall<I,T>(p : Parser<I,T>, genKey : Int -> String, input : Input<I>) : Option<MemoEntry> {
    var cached = input.getFromCache(genKey);
    switch (input.getRecursionHead()) {
      case None: return cached;
      case Some(head):
        if (cached == None && !(head.involvedSet.cons(head.headParser).contains(p))) {
          return Some(MemoParsed(Failure("dummy ".errorAt(input).newStack(), input, false)));
        }
        if (head.evalSet.contains(p)) {
          head.evalSet = head.evalSet.filter(function (x) return x != p);

          var memo = MemoParsed(p.parse(input));
          input.updateCacheAndGet(genKey, memo); // beware; it won't update lrStack !!! Check that !!!
          cached = Some(memo);
        }
        return cached;
    }
  }
  static public function setupLR<I>(p: Parser<I,Dynamic>, input: Input<I>, recDetect: LR) {
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
    var res = p.parse(rest);
    switch (res) {
      case Success(_, _) :
        if (oldRes.pos().offset < res.pos().offset ) {
          rest.updateCacheAndGet(genKey, MemoParsed(res));
          return grow(p, genKey, rest, head);
        } else {
          //we're done with growing, we can remove data from recursion head
          rest.removeRecursionHead();
          switch (rest.getFromCache(genKey).get()) {
            case MemoParsed(ans): return cast(ans);
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
          return cast(oldRes);
        }

    }
  }

  /**
   * Lift a parser to a packrat parser (memo is derived from scala's library)
   */
  public static function memo<I,T>(p : Parser<I,T>) : Parser<I,T>{
    return new MemoP(p);
  };
}