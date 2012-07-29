package com.mindrocks.macros;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;



/**
 * ...
 * @author sledorze
 */

class LazyMacro {

  // detect if applying lazy would change anything (this obviously is not working, would requiers inspecting the actual AST).
  static function alreadyLazy(type : Type) : Bool {
    switch (type) {
      case TFun(args, _): return args.length == 0;
      case TLazy(f) : return alreadyLazy(f());
      default : return false;
    };
  }
  
  @:macro public static function lazy<T>(exp : ExprOf<T>) : ExprOf<Void -> T> {    
    var res = 
      macro {
        var value = null;
        var computationRequested = false;
        function () {
          if (!computationRequested) {
            computationRequested = true; // not null to prevent live lock if it forms a cycle.
            value = $exp;
          }
          return value;
        };
      };

    
  
    if (
      Context.getLocalType() != null // Json.stringify(Context.typeof(exp))
    ) {
//      trace("type not equal");
    }
      
    return res;
  }

  @:macro public static function lazyF<T>(exp : ExprOf<Void -> T>) : ExprOf<Void -> T> {
    return
      macro {
        var value = null;
        var computationRequested = false;
        function () {
          if (!computationRequested) {
            computationRequested = true; // not null to prevent live lock if it forms a cycle.
            value = $exp();
          }
          return value;
        };
      };
  }

}
