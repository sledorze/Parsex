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
}