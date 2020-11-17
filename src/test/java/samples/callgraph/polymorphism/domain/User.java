package samples.callgraph.polymorphism.domain;

public interface User extends Entity<String> {

	public String getName();
	public String getEmail();
	public String getPassword();
	
}
