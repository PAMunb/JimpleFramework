module util::RunSVFA


private tuple[list[loc] classPath, list[str] entryPoints] simple() {
	//TODO compile class before using: mvn test -DskipTests
	files = [|project://JimpleFramework/target/test-classes/samples/callgraph/simple/SimpleCallGraph.class|];
    es = ["samples.callgraph.simple.SimpleCallGraph.A()"];
    //es = ["samples.TestCallGraph.execute()"];
    //es = ["samples.callgraph.simple.SimpleCallGraph.B()","samples.TestCallGraph.C()"];
    return <files, es>;
}