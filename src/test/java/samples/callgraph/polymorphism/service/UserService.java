package samples.callgraph.polymorphism.service;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.repository.Repository;

public class UserService extends AbstractService<User, String> {

	public UserService(Repository<User, String> repository) {
		super(repository);
	}

	@Override
	protected boolean valid(User entity) {
		log("[ContactService] valid: " + entity);
		return true;
	}

}
