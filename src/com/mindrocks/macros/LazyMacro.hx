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
  
  macro public static function lazy<T>(exp : ExprOf<T>) : ExprOf<Void -> T> {    
	return
      macro {
        var value = null;
        var computationRequested = false;
        function () {
          if (!computationRequested) {
            computationRequested = true; // not false to prevent live lock if it forms a cycle.
            value = $exp;
          }
          return value;
        };
      };
  }

  macro public static function lazyF<T>(exp : ExprOf<Void -> T>) : ExprOf<Void -> T> {
    return
      macro {
        var value = null;
        var computationRequested = false;
        function () {
          if (!computationRequested) {
            computationRequested = true; // not false to prevent live lock if it forms a cycle.
            value = $exp();
          }
          return value;
        };
      };
  }

}
