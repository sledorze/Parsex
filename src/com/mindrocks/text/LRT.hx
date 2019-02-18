package com.mindrocks.text;

typedef LRT = {
  seed: ParseResult<Dynamic,Dynamic>,
  rule: Parser<Dynamic,Dynamic>,
  head: Option<Head>
}