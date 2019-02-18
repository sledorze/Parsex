package ;

using com.mindrocks.text.Lift;
/**
 * ...
 * @author sledorze
 */

import com.mindrocks.text.Parser;
import haxe.Timer;

import com.mindrocks.functional.Functional;
using com.mindrocks.functional.Functional;

using Lambda; 

// Parse a definition base on text based specification of expressions.
/*
			Letrec("factorial", // letrec factorial =
				Lambda("n",    // fn n =>
					Apply(
						Apply(   // cond (zero n) 1
							Apply(Ident("cond"),     // cond (zero n)
								Apply(Ident("zero"), Ident("n"))),
							Ident("1")),
						Apply(    // times n
							Apply(Ident("times"), Ident("n")),
							Apply(Ident("factorial"),
								Apply(Ident("pred"), Ident("n")))
						)
					)
				),      // in
				Apply(Ident("factorial"), Ident("5"))
			),
*/

enum PrimitiveType {
  Number(x : Int);
  FloatNumber(x : Float);
}

typedef Identifier = String;

enum RExpression {
  Primitive(p : PrimitiveType);
  Ident(id : Identifier);
  LambdaExpr(param : Identifier, expr : Expression);
  Apply(fun : RExpression, param : Identifier);
}

typedef LetExpression = {
  ident : Identifier,
  expr : RExpression
}

typedef Expression = {
  lets : Array<LetExpression>,
  expr : RExpression
}

typedef Definition = {
  name : Identifier,
  expr : Expression
}

class LambdaTest {
  
  public static  var identifierR  = ~/[a-zA-Z0-9_-]+/;
  public static  var numberR      = ~/[-]*[0-9]+/;
  public static  var spaceP      = " ".identifier();    
  public static  var tabP        = "\t".identifier();
  public static  var retP        = ("\r".identifier().or("\n".identifier()));
  
  static function spacingP(){
   return [
      spaceP.oneMany(),
      tabP.oneMany(),
    ].ors().many(); 
  }
  static  function spacingOrRetP(){
    return [
      spaceP.oneMany(),
      tabP.oneMany(),
      retP.oneMany()
	  ].ors().many(); 
  }
    
  static  var stringStartP          = withSpacing("\"".identifier());
  static  var stringStopP           = "\"".identifier();
  static  var leftAccP              = withSpacing("{".identifier());
  static  var rightAccP             = withSpacing("}".identifier());
  static  var leftBracketP          = withSpacing("[".identifier());
  static  var rightBracketP         = withSpacing("]".identifier());
  static  var sepP                  = withSpacing(":".identifier());
  static  var commaP                = withSpacing(",".identifier());
  static  var equalsP               = withSpacing("=".identifier());
  static  var arrowP                = withSpacing("=>".identifier());
  static  var dotP                  = ".".identifier();
  
  static function maybeRet<T>(p : Parser<String, T>) : Parser<String, T> {return 
    spacingOrRetP().option()._and(p);
  }
    
  static function withSpacing<T>(p : Parser<String, T>) : Parser<String, T> return
	  spacingP()._and(p);

  static var identifierP =
    withSpacing(identifierR.regexParser()).tag("identifier");

  static  var letP = withSpacing("let".identifier());
  static  var inP = withSpacing("in".identifier());
  
  static var identP : Parser<String, RExpression> =
    identifierP.then(function (id) return Ident(id)).tag("identifier");

  static var numberP : Parser<String, PrimitiveType> =
    numberR.regexParser().then(function (n) return Number(Std.parseInt(n)));
  
  static var floatNumberP : Parser<String, PrimitiveType> = // TODO: change this!
    numberP.and_(dotP).and(numberP).then(function (p) return FloatNumber(Std.parseFloat(p.a + "." + p.b)));
  
// TODO
//  static var stringP =
//    stringStartP._and(    
    
  static var primitiveP : Parser<String, RExpression> = [
      floatNumberP,
      numberP,
    ].ors().then(Primitive).tag("primitive");
    
  static var applicationP : Parser<String, RExpression> =
	( 
    rExpressionP().and(identifierP)
    .then(function (p) return Apply(p.a, p.b)).tag("application") 
  );

  static function lambdaP(){
    return 
      (identifierP.and_(arrowP)
      .and(maybeRet(expressionP.commit()))
      .then(function (p) return LambdaExpr(p.a, p.b)).tag("lambda") );
  }
  static function rExpressionP():Parser<String, RExpression>{
    return [
      lambdaP(),
      applicationP,
      identP,
      primitiveP
    ].ors().memo().tag("RExpression"); 
  } 
  static var letExpressionP : Parser<String, LetExpression> =
    ( identifierP.and_(equalsP).and(maybeRet(rExpressionP().commit())).then(function (p) return { ident: p.a, expr: p.b }).tag("let expression") );
  
  public static var expressionP : Parser<String, Expression> =
	(

		(letP._and(maybeRet(maybeRet(letExpressionP).rep1sep(commaP.or(retP)).and_(commaP.option())).and_(maybeRet(inP)).commit())).option().and(maybeRet(rExpressionP())).then(function (p) {
		  var lets =
			switch (p.a) {
			  case Some(ls): ls;
			  case None: [];
			};
		  return { lets : lets, expr : p.b };
		}).tag("expression")
	);
    


  static var definitionP =
	(
		maybeRet(identifierP).and_(equalsP).and(maybeRet(expressionP.commit()))
      .then(function (p) return { name : p.a, expr : p.b } ).tag("definition")
	);
    
  public static var programP =
    definitionP.many().tag("program").commit();
  
}

class LangParser {

  static function tryParse<T>(str : String, parser : Parser<String, T>, withResult : T -> Void, output : String -> Void) {
    try {
      var res = 
        Timer.measure(function () return parser.parse(str));
      
      switch (res) {
        case Success(res, xs):
          var remaining = xs.rest();
          if (StringTools.trim(remaining).length == 0) {
            trace("success!");            
          } else {
            trace("cannot parse " + remaining);
          }
          withResult(res);
        case Failure(err, xs, _):
          var p = xs.textAround();
          output(p.text);
          output(p.indicator);          
          err.map(function (error) {
            output("Error at " + error.pos + " : " + error.msg);
          });

          
      }
    } catch (e : Dynamic) {
      throw(e);
      trace("Error " + Std.string(e));
    }    
  }
  
  public static function langTest() {
    
    function toOutput(str : String) {
      trace(StringTools.replace(str, " ", "_"));
    }

    var input = "
      toto =
        let
          a = 56
          b = d
          v = a =>
            let x = 12
            in x
          b = d
        in
          add c d          
    ";
    var out = LambdaTest.programP.parse(input);
    var errs = out.fold(
          (_,_) -> None,
          (err,xs,_) -> {
            trace(xs);
            return Some(err);
          }
        );
    errs.get().each(
      (x) -> trace(x)
    );
  }
  public static function numberParserTest(){
    trace(
      LambdaTest.numberR.regexParser().tag("testing").parse("21")
    );
 }
  
}
