module TestSuite

import TestAvailableExpressions; 

import IO; 
import List; 

data TestCase = TestCase(str name, bool () function); 

list[TestCase] tcs = [TestCase("TestAvailableExpressions", testAvailableExpressions)]; 


public void main(list[str] _) {
  int count = 0; 
  list[str] errors = [];
   
  while(count < size(tcs)) {
	try {
	  res = tcs[count].function();
	  if(! res) {
	    errors += "test case <count> <tcs[count].name> failed"; 
	  }
	}
	catch: errors +=  "foo"; 
	count = count + 1; 
  }
  println(errors); 
}