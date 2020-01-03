package ;

import com.mindrocks.text.Parser;
import com.mindrocks.text.parsers.Base;

class Test {
	
	public static function main() {
		new Parser(new Base());
		LangParser.numberParserTest();
		//LangParser.langTest();
		//ParserTest.jsonTest();
		SimpleParser.test();
	}
  
}
