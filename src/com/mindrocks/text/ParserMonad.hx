package com.mindrocks.text;

/**
 * ...
 * @author sledorze
 */

import com.mindrocks.monads.Monad;
//import com.mindrocks.text.Parser;
using com.mindrocks.text.Parser;

class ParserM {

  macro public static function dO(body : haxe.macro.Expr) return
    Monad._dO("ParserM", body, haxe.macro.Context);

  inline public static function ret < I, T > (v : T) : Void -> Parser <I,T>
    return v.success();

  inline public static function map < I, T, U > (p1 : Void -> Parser < I, T > , f : T -> U) : Void -> Parser < I, U >
    return p1.then(f);

  inline public static function flatMap < I, T, U > (p1 : Void -> Parser < I, T > , fp2 : T -> (Void -> Parser < I, U > )) : Void -> Parser < I, U >
    return p1.andThen(fp2);
    
}
