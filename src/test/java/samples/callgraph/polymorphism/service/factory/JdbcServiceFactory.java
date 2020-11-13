package samples.callgraph.polymorphism.service.factory;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.domain.UserImpl;
import samples.callgraph.polymorphism.repository.jdbc.JdbcUserRepository;

public class JdbcServiceFactory extends ServiceFactory {

	@SuppressWarnings("unchecked")
	@Override
	protected JdbcUserRepository getRepository() {
		return new JdbcUserRepository();
	}

	@Override
	public User createUser(String id, String name, String email, String phone) {
		return new UserImpl(id, name, email, phone);
	}

}
