package com.mindrocks.text;

class ParseResults{
  public static function mkLR<I,T>(seed: ParseResult<I,Dynamic>, rule: Parser<I,T>, head: Option<Head>) : LR return {
    seed: seed,
    rule: rule.elide(),
    head: head
  }
}