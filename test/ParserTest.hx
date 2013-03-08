package ;

/**
 * ...
 * @author sledorze
 */

import com.mindrocks.text.Parser;
// import js.JQuery;
// import js.Lib;
using com.mindrocks.text.Parser;

import com.mindrocks.functional.Functional;
using com.mindrocks.functional.Functional;

using com.mindrocks.macros.LazyMacro;

using Lambda; 

import com.mindrocks.text.ParserMonad;
using com.mindrocks.text.ParserMonad;

typedef JsEntry = { name : String, value : JsValue}
enum JsValue {
  JsObject(fields : Array<JsEntry>);
  JsArray(elements : Array<JsValue>);
  JsData(x : String);
}
/**
 * Quick n dirty.
 */
class JsonPrettyPrinter {
  public static function prettify(json : JsValue) : String return {
    function internal(json : JsValue) : String return {
      switch (json) {
        case JsObject(fields):
          "{\n" + fields.map(function (field) return field.name + " : " + internal(field.value)).join(",\n") + "\n}";
        case JsArray(elements):
          "[\n" + elements.map(internal).join(",\n") + "\n]";
        case JsData(x):
          x;
      } 
    }
    internal(json);
  }
}

class JsonParser {
  
  static function makeField(t : Tuple2<String, JsValue>) return
    { name : t.a, value : t.b }
  
  static var identifierR = ~/[a-zA-Z0-9_-]+/;

  static  var spaceP = " ".identifier();    
  static  var tabP = "\t".identifier();
  static  var retP = ("\r".identifier().or("\n".identifier()));
  
  static  var spacingP =
	LazyMacro.lazyF([
      spaceP.oneMany(),
      tabP.oneMany(),
      retP.oneMany()
    ].ors().many());
  
  static  var leftAccP = withSpacing("{".identifier());
  static  var rightAccP = withSpacing("}".identifier());
  static  var leftBracketP = withSpacing("[".identifier());
  static  var rightBracketP = withSpacing("]".identifier());
  static  var sepP = withSpacing(":".identifier());
  static  var commaP = withSpacing(",".identifier());
  static  var equalsP = withSpacing(",".identifier());
  
  
  static function withSpacing<I,T>(p : Void -> Parser<String,T>) return
    spacingP._and(p);

  static var identifierP =
    withSpacing(identifierR.regexParser());

  static var jsonDataP =
    identifierP.then(JsData);
    
  static var jsonValueP : Void -> Parser<String,JsValue> =
    [jsonParser, jsonDataP, jsonArrayP].ors().tag("json value").lazyF();

  static var jsonArrayP2 =
    leftBracketP._and(jsonValueP.repsep(commaP).and_(rightBracketP).commit()).then(JsArray);
    
  static var jsonArrayPM =
    ParserM.dO({
      jsons <= ParserM.dO({
        leftBracketP;
        jsons <= jsonValueP.repsep(commaP);
        rightBracketP;
        ret(jsons);
      }).commit();
      ret(JsArray(jsons));
    });
    
  static var jsonArrayP =
    ParserM.dO({
      leftBracketP;
      jsons <= jsonValueP.repsep(commaP);
      rightBracketP;
      ret(JsArray(jsons));
    }).commit();

  static var jsonEntryP =
    identifierP.and(sepP._and(jsonValueP).commit());
  
  static  var jsonEntriesP =
    jsonEntryP.repsep(commaP).commit();

  public static var jsonParser =
    leftAccP._and(jsonEntriesP).and_(rightAccP.commit()).then(function (entries)
      return JsObject(entries.map(makeField).array())
    );
}

class LRTest {

  static var posNumberR = ~/[0-9]+/;
  
  static var plusP = "+".identifier();
  
  static var posNumberP = posNumberR.regexParser().tag("number");
    
  static var binop = LazyMacro.lazyF( (expr.and_(plusP)).andWith(expr.commit(), function (a, b) return a + " + " + b).tag("binop") );
  public static var expr : Void -> Parser<String,String> = binop.or(posNumberP).memo().tag("expression");
}


class MonadParserTest {

  public static var parser : Void -> Parser<String,Array<String>> = ParserM.dO({
      a <= "a".identifier();
      b <= "b".identifier();
      c <= "c".identifier();
      ret([a,b,c]);
  });

}

class ParserTest {

  static function expectFailure<T> (s:String, parser:Parser<String,T>, at){
    switch (parser(s.reader())) {
      case Success(res, _):
        trace(res);
        trace("unexpected success, result line above ");
        return false;
      case Failure(err, rest, _):
        if (rest.offset == at)
        return true;
        else {
          trace("unexpected failure offset: "+ rest.errorMessage(err));
          return false;
        }
        return true;
    }
  }

  static function expectSuccess<A> (s:String, parser: Parser<String, A>, result:A):Bool{
    switch (parser(s.reader())) {
      case Success(res, _):
        if ( Std.string(res) == Std.string(result) )
			return true;
        else {
          trace("result does not match: "+res+" expected :"+result);
          return false;
        }
      case Failure(err, rest, _):
        trace("unexpected failure : "+rest.errorMessage(err));
        return false;
    }
  }
  
  public static function jsonTest() {
    
    var ok = true;
    ok = ok && expectFailure(" {  aaa : aa, bbb :: [cc, dd] } ", JsonParser.jsonParser(), 19);
    ok = ok && expectFailure("5++3+2+3", LRTest.expr(), 2);

    ok = ok && expectSuccess("abc", MonadParserTest.parser(), ["a","b","c"]);

    trace(ok ? "test passed " : "test FAILED!");    
  }
  
}

