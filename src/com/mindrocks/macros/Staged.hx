package com.mindrocks.macros;

/**
 * ...
 * @author sledorze
 */
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Tools;
// import haxe.macro.Type;

#if macro
using Type;
using Lambda;
using Std;

class Substituer {
  var transfo : Expr -> String -> Void;
  public function new(transfo : Expr -> String -> Void) {
    this.transfo = transfo;    
  }
  
  static function extractLookup(b : Expr) : Array<{ field : String, expr : Expr }> return {
    switch(b.expr) {
      case EObjectDecl(fields): fields;
      default : throw ("shouldn't happened - lookup expression " + Std.string(b.expr));
    }
  }
  
  function substitueSeveral(src : Array<Expr>) {
    for (exp in src) {
      substitueExp(exp);
    }
  }
/*
  function substitueName(name : String) {
    for (sub in subs) {
      if (sub.field == name) {
        switch (sub.expr.expr) {
          case EConst(v):
            switch (v) {
              case CString( s ): return s;
	            case CIdent( s ): return s;
	            case CType( s ): return s;
              default:
            }
          default:
        }
      }
    }
    return name;
  }
*/
  function substitueTypeParam(tp : TypeParam) {
    switch (tp) {
      case TPType( ct ) : substitueComplexType(ct);
	    case TPExpr( e ) : substitueExp(e);
    }
  }

  function substitueTypePath(tp : TypePath) {
    for (param in tp.params) {
      substitueTypeParam(param);
    }
  }

  function substitueFunc(func : Function) {
    for (arg in func.args) {
  //    arg.name = substitueName(arg.name);
      substitueComplexType(arg.type);
      substitueExp(arg.value);
    }
    substitueExp(func.expr);
    for (param in func.params) {
      for (constraint in param.constraints) {
        substitueComplexType(constraint);
      }
    }
  }
  
  function substitueField(field : Field) {
    switch (field.kind) {
      case FVar(ct, e):
        substitueComplexType(ct);
        substitueExp(e);
      case FProp(get, set, t, e):
        substitueComplexType(t);
        substitueExp(e);
      case FFun(f):
        substitueExp(f.expr);
        for (funArg in f.args) {
  //        funArg.name = substitueName(funArg.name);
          substitueComplexType(funArg.type);
          substitueExp(funArg.value);
        }
        for (param in f.params) {
          for (constraint in param.constraints) {
            substitueComplexType(constraint);
          }
        }
    }    
  }

  function substitueComplexType(ct : ComplexType) {
    if (ct != null) {
      switch (ct) {
        case TPath(tp): substitueTypePath(tp);
        case TParent(t): substitueComplexType(t);
        case TFunction(args, ret):
          for (arg in args) {
            substitueComplexType(arg);
          }
          substitueComplexType(ret);
        case TExtend(tp, fields):
          substitueTypePath(tp);
          for (field in fields) {
            substitueField(field);
          }
        case TAnonymous(fields):
          for (field in fields) {
            substitueField(field);
          }
        case TOptional(ct):
          substitueComplexType(ct);
      }
    }
  }
    
  public function substitueExp(src : Expr) {
    if (src == null) return;
    switch (src.expr) {
      case EConst( c ):
        switch (c) {
          case CIdent( identName ):
            if (identName.charAt(0) == '$') {
              transfo(src, identName);
            }
          default:
        }
      case EArray( e1, e2) : substitueExp(e1); substitueExp(e2);
      case EBinop( op, e1, e2) : substitueExp(e1); substitueExp(e2);
      case EField( e, field) : substitueExp(e);
      case EType( e, field) :  substitueExp(e);
      case EParenthesis( e ) :  substitueExp(e);
      case EObjectDecl( fields) :
        for (field in fields)
        substitueExp(field.expr);
      case EArrayDecl( values) : substitueSeveral(values);
      case ECall( e, params) :  substitueExp(e); substitueSeveral(params);
      case ENew( t, params) : substitueSeveral(params);
      case EUnop( op, postFix, e ) : substitueExp(e); 
      case EVars( vars):
        for (vr in vars) {
          substitueExp(vr.expr); 
        }
      case EFunction( name, f) : substitueFunc(f);        
      case EBlock( exprs) : substitueSeveral(exprs);
      case EFor( it, expr):  substitueExp(it); substitueExp(expr); 
      case EIn( e1, e2) : substitueExp(e1); substitueExp(e2);
      case EIf( econd, eif, eelse): substitueExp(econd); substitueExp(eif); substitueExp(eelse);
      case EWhile( econd, e, normalWhile): substitueExp(econd); substitueExp(e);
      case ESwitch( e, cases, edef):
        substitueExp(e); 
        for (cas in cases) {
          substitueExp(cas.expr); 
        }        
        substitueExp(edef); 
      case ETry( e, catches):
        substitueExp(e); 
        for (cat in catches) {
          substitueExp(cat.expr); 
        }        
      case EReturn(e):
        substitueExp(e); 
      case EBreak:
      case EContinue:
      case EUntyped( e):
        substitueExp(e); 
      case EThrow( e):
        substitueExp(e); 
      case ECast( e, t):
        substitueExp(e);
        substitueComplexType(t);
      case EDisplay( e, isCall):
        substitueExp(e);
      case EDisplayNew(t): //: TypePath 
        substitueTypePath(t);

      case ETernary( econd, eif, eelse):
        substitueExp(econd);
        substitueExp(eif);
        substitueExp(eelse);
      case ECheckType( e, t):
        substitueExp(e);
        substitueComplexType(t);
    }
  }

}

class Staged {
  
  static function fieldToExpr(subs : Array<{field : String, expr : Expr }>) return function (src : Expr, identName : String) {
    var name = identName.substr(1);
    for (sub in subs) {
      if (sub.field == name) {
        try {
    //      trace("before " + Std.string(sub.expr));
          var handled =
            switch (sub.expr.typeof()) {
              case TObject:
                if (sub.expr.expr != null && sub.expr.pos != null) { // great chance it's an Expr..
                  src.expr = sub.expr.expr;
                  true;
                } else false;
              case TEnum(_):
                if (Std.is(sub.expr, ExprDef)) {
                  src.expr = untyped sub.expr;
                };
                true;
              default: false;
            };
/*            
          trace("sub.expr " + Std.string(sub.expr));
          trace("sub.expr.typeof() " + Std.string(sub.expr.typeof()));
          
          trace("name " + name + ": " + handled);
*/          
          if (!handled) {
            src.expr = Context.makeExpr(sub.expr, src.pos).expr;
          }
          
        } catch (e : Dynamic) {
          trace("Error during substitution" + name);
        }
        break;
      }
    }
  }

  public static function subtituedWithExpForField(exp : Expr, arr : Array<{field : String, expr : Expr }>) {
    new Substituer(fieldToExpr(arr)).substitueExp(exp);
  }

  public static function collectIdentifiers(exp : Expr) : Array<String> {
    var res = [];
    var subs = new Substituer(function (_, identifier) {
      res.push(identifier);
    });
    subs.substitueExp(exp);
    return res;
  }

  static var pexp : Expr;
  public static function pput(e : Expr) {
    pexp = e;
  }
  @:macro public static function pget(e : Expr) {
    return pexp;
  }
  
  @:macro public static function flatten(e : Expr) {
    return exp({
      Staged.pput($_e);
      Staged.pget({});
    });
  }

  public static function cpy<T>(x : T) : T {
   return
    switch (Type.typeof(x)) {
      case TNull: x;
	    case TInt: x;
	    case TFloat: x;
	    case TBool : x;
    case TObject :
        var obj : T = untyped { };
        untyped  obj.index = x.index;
        for (f in Reflect.fields(x)) {         
          Reflect.setField(obj, f, cpy(Reflect.field(x, f)));
        }
        obj;        
      case TFunction: x;
      case TClass( c ):
        if (Std.is(x, Array)) {
          var arr : Array<Dynamic> = untyped x;
          var res : Array<Dynamic> = arr.map(cpy).array();
          untyped res;
        } else {
          var obj : T = Type.createEmptyInstance(c);
          for (f in Reflect.fields(x)) {
            Reflect.setField(obj, f, cpy(Reflect.field(x, f)));
          }
          obj;          
        }
    	case TEnum( e  ):
        Type.createEnumIndex(e, Type.enumIndex(x), Type.enumParameters(x).map(cpy).array());
      case TUnknown:
        x;

    }
  }

  static var id = 0;
  static function getId():String {
    id++;
    return "" + id;
  }
  private static var slice : Hash<Expr> = new Hash<Expr>();

  public static function setSlice(e : Expr) : String {
    var id = getId();
    slice.set(id, e);
    return id;
  }
  public static function getSlice(id : String) : Expr {
    return slice.get(id);
  }

  public static function mk(expDef : ExprDef)
    return { expr : expDef, pos : Context.currentPos() }
  
  static function mkCall(clazz : String, meth : String)
    return mk(EField(mk(EConst(CType(clazz))), meth))
  
  static var currentPos =
    mk(ECall(mkCall("Context", "currentPos"), []));
    
  static var stagedCpy =
    mkCall("Staged", "cpy");
    
  static var contextMakeExpr =
    mkCall("Context", "makeExpr");
    
  static var stagedGetSlice =
    mkCall("Staged", "getSlice");
    
  static var substitueExpr =
    mk(ECall(mkCall("Staged", "subtituedWithExpForField"), [mk(EConst(CIdent("res"))), mk(EConst(CIdent("mappings")))]));
    
  @:macro public static function exp(code : Expr, ?id : Int = 0) : Expr {
    var idStr = setSlice(code);
    
    var identifiers =
      Staged.collectIdentifiers(code);
      
//    trace("Identifiers " + identifiers);
      
    function fieldForName(str) {
      var exp = 
        if (StringTools.startsWith(str, "_")) {
          mk(EConst(CIdent(str.substr(1))));
        } else {
          mk(ECall(contextMakeExpr, [mk(EConst(CIdent(str))), currentPos]));
        }
      
      return mk(EObjectDecl([
        { field : "field", expr : mk(EConst(CString(str))) },
        { field : "expr", expr : exp }
      ]));
    }
    
    var mappingFields =
      identifiers.map(function (str) return str.substr(1)).map(fieldForName).array();
    
    var mappingExp : ExprDef = 
      EVars([
        { name : "mappings", type : null, expr : mk(EArrayDecl(mappingFields))}
      ]);

    var copyExp : ExprDef = 
      EVars([
        { name : "res", type : null, expr : mk(ECall(stagedCpy, [mk(ECall(stagedGetSlice, [mk(EConst(CString(idStr)))]))])) }
      ]);
    
    return
      mk(EBlock([
        mk(mappingExp),
        mk(copyExp),
        substitueExpr,
        mk(EConst(CIdent("res")))
      ]));
  }

}
#end
