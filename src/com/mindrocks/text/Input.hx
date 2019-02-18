package com.mindrocks.text;

@:forward abstract Input<I>(InputT<I>) from InputT<I>{
  inline public function take(len : Int) : String {
    return this.content.range(this.offset, len);
  }

  inline public function drop<I>(len : Int) : Input<I> {
    return {
      content : this.content,
      offset : this.offset + len,
      memo  : this.memo
    };
  }
  inline public function startsWith( x : String) : Bool {
    return take(x.length) == x;
  }

  inline public function matchedBy(e : EReg) : Bool { // this is deadly unfortunate that RegEx don't support offset and first char maching constraint..
    return e.match(rest());
  }

  inline public function rest() : String {
    return this.content.range(this.offset);
  }
  
  inline public function position<I>(r : Input<I>) : Int return
    this.offset;

  public function textAround(?before : Int = 10, ?after : Int = 10) : { text : String, indicator : String } {

    var offset = Std.int(Math.max(0, this.offset - before));

    var text = this.content.range(offset, before + after);

    var indicPadding = Std.int(Math.min(this.offset, before));
    var indicator = StringTools.lpad("^", "_", indicPadding+1);

    return {
      text : text,
      indicator : indicator
    };
  }
  public function errorMessage(msg: FailureStack){
    var x = textAround();

    var r = "";
    msg.each(function(err){
        r += "Error at " + err.pos + " : " + err.msg+"\n";
    });

    return r + " "+x.text+"\n"+x.indicator;
  }
  @:from inline public static function reader(str : String) : Input<String> return {
    content : Tools.enumerable(str),
    offset : 0,
    memo : {
      memoEntries : new Map<String,MemoEntry>(),
      recursionHeads: new Map<String,Head>(),
      lrStack : List.nil()
    }
  }

  public inline function setRecursionHead(head : Head) {
    this.memo.recursionHeads.set(this.offset + "", head);
  }
  public inline function removeRecursionHead() {
    this.memo.recursionHeads.remove(this.offset + "");
  }
  public inline function getRecursionHead() : Option<Head> {
    var res = this.memo.recursionHeads.get(this.offset + "");
    return res == null?None: Some(res);
  }
  public inline function getFromCache(genKey : Int -> String) : Option<MemoEntry> {
    var key = genKey(this.offset);
    var res = this.memo.memoEntries.get(key);
    return res == null?None: Some(res);
  }
  inline public function updateCacheAndGet(genKey : Int -> String, entry : MemoEntry) {
    var key = genKey(this.offset);
    this.memo.memoEntries.set(key, entry);
    return entry;
  }
  public function toString(){
    return 'at ${this.offset}:#(${this.tag}) ${rest()}';
  }
}