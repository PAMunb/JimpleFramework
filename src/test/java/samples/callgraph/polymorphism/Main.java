package samples.callgraph.polymorphism;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.service.Service;
import samples.callgraph.polymorphism.service.factory.JdbcServiceFactory;
import samples.callgraph.polymorphism.service.factory.ServiceFactory;

public class Main {

	public void execute(ServiceFactory factory) {
		User user = factory.createUser("ID", "NAME", "EMAIL", "PHONE");

		Service<User, String> service = factory.getUserService();
		User persistedUser = service.save(user);
		// System.out.println("Persisted user: "+persistedUser.getName());
		persistedUser.getName();
	}

	public void execute2() {
		ServiceFactory factory = new JdbcServiceFactory();

		User user = factory.createUser("ID", "NAME", "EMAIL", "PHONE");

		factory.getUserService().save(user);
	}

	public void execute3(ServiceFactory factory) {
		factory.getUserService().save(null);
	}

	public static void main(String[] args) {
		new Main().execute(new JdbcServiceFactory());
	}

}
