package samples.callgraph.polymorphism.repository.hibernate;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.repository.Repository;

public class HibernateUserRepository implements Repository<User, String> {

	@Override
	public User save(User entity) {
		log("[HibernateRepository] save: " + entity);
		return entity;
	}

	@Override
	public User update(User entity) {
		log("[HibernateRepository] update: " + entity);
		return entity;
	}

	@Override
	public List<User> findAll() {
		log("[HibernateRepository] findAll");
		return new ArrayList<>();
	}

	@Override
	public Optional<User> findById(String id) {
		log("[HibernateRepository] findById: " + id);
		return Optional.empty();
	}

	@Override
	public void delete(String id) {
		log("[HibernateRepository] delete: " + id);
	}

}
