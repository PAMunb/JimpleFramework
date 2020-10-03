package samples.callgraph.polymorphism.service.factory;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.domain.hibernate.HibernateUser;
import samples.callgraph.polymorphism.repository.hibernate.HibernateUserRepository;

public class HibernateServiceFactory extends ServiceFactory {

	@SuppressWarnings("unchecked")
	@Override
	protected HibernateUserRepository getRepository() {
		return new HibernateUserRepository();
	}

	@Override
	public User createContact(String id, String name, String email, String phone) {
		return new HibernateUser(id, name, email, phone);
	}

}
