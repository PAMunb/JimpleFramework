package samples.callgraph.polymorphism.service.factory;

import java.io.Serializable;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.domain.Entity;
import samples.callgraph.polymorphism.repository.Repository;
import samples.callgraph.polymorphism.service.UserService;

public abstract class ServiceFactory {

	private UserService userService;

	public ServiceFactory() {
		userService = new UserService(getRepository());
	}

	public UserService getUserService() {
		return userService;
	}

	protected abstract <E extends Entity<ID>, ID extends Serializable> Repository<E, ID> getRepository();

	public abstract User createUser(String id, String name, String email, String phone);

}
