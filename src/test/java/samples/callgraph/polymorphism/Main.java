package samples.callgraph.polymorphism;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.service.factory.JdbcServiceFactory;
import samples.callgraph.polymorphism.service.factory.ServiceFactory;

public class Main {

	public void execute() {//ServiceFactory factory) {
		ServiceFactory factory = new JdbcServiceFactory();
		
		User user = factory.createContact("ID", "NAME", "EMAIL", "PHONE");

		User persistedUser = factory.getContactService().save(user);

		//List<User> users = factory.getContactService().findAll();
		//users.parallelStream().forEach(System.out::println);
		//for(User usr: users) {
		//	System.out.println(usr);
		//}
	}

	public static void main(String[] args) {
		new Main().execute();//new JdbcServiceFactory());
	}

}
