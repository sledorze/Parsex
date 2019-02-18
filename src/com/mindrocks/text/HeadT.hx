package com.mindrocks.text;

typedef HeadT = {
  headParser        : Parser<Dynamic,Dynamic>,
  involvedSet       : List<Parser<Dynamic,Dynamic>>,
  evalSet           : List<Parser<Dynamic,Dynamic>>
}