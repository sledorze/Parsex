using com.mindrocks.functional.Functional;
using com.mindrocks.text.Parser;
using com.mindrocks.text.Lift;
import com.mindrocks.text.*;

class SimpleParser{
  static public function test(){
    var a = new SimpleParser();
        a.testIdentitifierSuccess();
        a.testOption();
        a.testRegex();
        a.testRecure();
  }
  public function new(){

  }
  static var test_id = "test".identifier(); 
  function testIdentitifierSuccess(){
    var b = "test";
    var c = test_id.parse(b);
    shouldSucceed(c);
  }
  function testOption(){
    var b = "tes";
    var c = test_id.option().parse(b);
    shouldSucceed(c);
  }
  function testRegex(){
    var b = "aaaa";
    var c = ~/a+/.regexParser().parse(b);
    shouldSucceed(c);
  }
  function shouldSucceed(v:ParseResult<Dynamic,Dynamic>){
    switch (v) {
      case Failure(errors, xs, isError):
        errors.each(
          (x) -> trace(x)
        );
        default:
    }
  }
  function testRecure(){
    var t = "1+2+3x4";
    var o = p_expr.parse(t);
      trace(o);
  }
  static var p_int = ~/[0-9]+/.regexParser().then(
    (x) -> Num(Std.parseInt(x))
  );
  static var p_star_id = "x".identifier();
  static var p_plus_id = "+".identifier();

  static var p_expr :Parser<String,Expr> = {
    [
        p_mult.lazy(),
        p_plus.lazy(),
        p_int
    ].ors().memo();
  }
  static function p_mult(){
    return 
      p_expr
      .and_(p_star_id)
      .and(p_expr)
      .then((tp) -> Mult(tp.a,tp.b));
  }
  static function p_plus(){
    return 
      p_expr
      .and_(p_plus_id)
      .and(p_expr)
      .then((tp) -> Plus(tp.a,tp.b));
  }
}
enum Expr{
  Mult(l:Expr,r:Expr);
  Plus(l:Expr,r:Expr);
  Num(v:Int);
}