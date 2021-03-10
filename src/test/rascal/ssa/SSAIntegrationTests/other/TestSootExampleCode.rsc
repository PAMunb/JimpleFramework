module ssa::SSAIntegrationTests::other::TestSootExampleCode

import Set;
import lang::jimple::toolkit::FlowGraph;
import ssa::SSAIntegrationTests::util::CreateClassfileSSAFlowGraph;

test bool testSootSampleCodeMethod() {
	loc classFilePath = |project://JimpleFramework/target/test-classes/samples/ssa/other/SootExampleCode.class|;
	int methodToTest = 1;
	FlowGraph result = createClassFileSSAFlowGraph(classFilePath, methodToTest);

	return !isEmpty(result);
}