package samples.callgraph.polymorphism;

import java.util.List;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.service.factory.JdbcServiceFactory;
import samples.callgraph.polymorphism.service.factory.LuceneServiceFactory;
import samples.callgraph.polymorphism.service.factory.ServiceFactory;

public class Main {

	public void execute() {
		ServiceFactory factory = new JdbcServiceFactory();
		ServiceFactory lucene = new LuceneServiceFactory();
//		AbstractServiceFactory factory = new HibernateServiceFactory();

		User user = factory.createContact("ID", "NAME", "EMAIL", "PHONE");

		User persisted = factory.getContactService().save(user);
		lucene.getContactService().save(persisted);

		List<User> users = factory.getContactService().findAll();
		//users.parallelStream().forEach(System.out::println);
		for(User usr: users) {
			System.out.println(usr);
		}
	}

	public static void main(String[] args) {
		new Main().execute();
	}

}
