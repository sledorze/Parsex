Parser combinator library.

More info here:
http://lambdabrella.blogspot.com/2012/01/packrat-parser-combinators-for-haxe.html

The original implementation was inspired from Scala.

Special thanks goes to Marc Weber and Laurence Taylor for supporting the effort.

- dependencies:
  * tinkerbell:
  https://github.com/back2dos/tinkerbell
    
- optional:
  * monax if you want to use monad like syntax:
  https://github.com/sledorze/monax

TODO:
- implement benchmarks for all platforms
- implement getFastChar for String Inputs
- think about moving offset to Success enum so that less objects have to be
  created.
- much more testing!
