// https://github.com/UnB-CIC/sle-course/blob/master/sample-code/oberon/src/lang/util/Stack.rsc

module lang::jimple::util::Stack

import lang::jimple::util::Maybe;

data Stack[&T] = empty() | push(&T v, Stack[&T] s);      

int size(empty()) = 0;
int size(push(v,r)) = 1 + size(r);

Maybe[&T] peek(empty()) = nothing();
Maybe[&T] peek(push(v, r)) = just(v);

tuple[Maybe[&T] v, Stack[&T] stack] pop(Stack[&T] s) {
  switch(s) {
    case empty() : return <nothing(), empty()>; 
    case push(v, r) : return <just(v), r>;  
  }
   
  return <nothing(), empty()>;
}
