module util::TestStack

import lang::jimple::util::Maybe;
import lang::jimple::util::Stack;

Stack[int] stack = push(1, push(2, empty()));

test bool emptySizeTest() = 0 == size(empty());
test bool sizeTest() = 2 == size(stack);

test bool emptyPopTest() = <nothing(), empty()> == pop(empty());
test bool popTest() = <just(1), push(2, empty())> == pop(stack);

test bool emptyPeekTest() = nothing() == peek(empty());
test bool peekTest() = just(1) == peek(stack);