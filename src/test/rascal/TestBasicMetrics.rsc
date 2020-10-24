module TestBasicMetrics

import lang::jimple::core::Context;
import lang::jimple::toolkit::BasicMetrics;

test bool testNumberOfClasses() {
 list[str] es = []; 
 return 12 == execute([|project://JimpleFramework/src/test/resources/slf4j|], es, Analysis(numberOfClasses)); 
}

test bool testNumberOfPublicMethods() {
 list[str] es = []; 
 return 230 == execute([|project://JimpleFramework/src/test/resources/slf4j|], es, Analysis(numberOfPublicMethods)); 
}