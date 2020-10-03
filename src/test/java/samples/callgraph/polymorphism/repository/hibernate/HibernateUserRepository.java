package samples.callgraph.polymorphism.repository.hibernate;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.repository.Repository;

public class HibernateUserRepository implements Repository<User, String> {

	@Override
	public User save(User entity) {
		System.out.println("[HibernateRepository] save: " + entity);
		return entity;
	}

	@Override
	public User update(User entity) {
		System.out.println("[HibernateRepository] update: " + entity);
		return entity;
	}

	@Override
	public List<User> findAll() {
		System.out.println("[HibernateRepository] findAll");
		return new ArrayList<>();
	}

	@Override
	public Optional<User> findById(String id) {
		System.out.println("[HibernateRepository] findById: " + id);
		return Optional.empty();
	}

	@Override
	public void delete(String id) {
		System.out.println("[HibernateRepository] delete: " + id);
	}

}
