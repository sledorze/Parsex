Parser combinator library.
The original implementation was taken from Scala and adopted to HaXe by
Stephane Le Dorze.

- dependencies:
  * tinkerbell https://github.com/back2dos/tinkerbell.git
  optional:
  * monax if you want to use monad like syntax:
    https://github.com/sledorze/monax


TODO:
- implement benchmarks for all platforms
- implement getFastChar for String Inputs
- think about moving offset to Success enum so that less objects have to be
  created.
- much more testing!
