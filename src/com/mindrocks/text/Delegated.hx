package com.mindrocks.text;

using Lambda;

abstract Delegated<A,B>(DelegatedT<A,B>) from DelegatedT<A,B>{
  public function show(?tab){
    function handle(v,tab){
      var n = '$tab ';
      return switch(v){
          case DUnknown            : '?';
          case DDirect(name,meta)  : 'd: $name($meta)';
          case DUnit(p)            : p == null ? "?" : p.getDelegation().show(n); 
          case DArray(p)           : p == null ? "?" : p.getDelegation().show(n);
          case DOrs(arr)           : arr.map((x)->x == null ? '?' : x.getDelegation().show(n) ).join(',');
          case DConj(tp)           : tp.a.getDelegation().show(n) + "," + tp.b.getDelegation().show(n);
          case DDisj(tp)           : tp.a.getDelegation().show(n) + "," + tp.b.getDelegation().show(n);
      }
    }
    return handle(this,"");
  }
  public function toString(){
    return show();
  }
  public function elide():Delegated<Dynamic,Dynamic>{
    return this;
  }
}