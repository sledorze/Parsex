package com.mindrocks.text;

enum ParseResultT<I,T> {
  Success(match : T, rest : Input<I>);
  Failure(errorStack : FailureStack, rest : Input<I>, isError : Bool);
}