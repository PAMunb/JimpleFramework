package samples.callgraph.polymorphism.repository.jdbc;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.repository.Repository;

public class JdbcUserRepository implements Repository<User, String> {

	@Override
	public User save(User entity) {
		System.out.println("[JdbcRepository] save: " + entity);
		return entity;
	}

	@Override
	public User update(User entity) {
		System.out.println("[JdbcRepository] update: " + entity);
		return entity;
	}

	@Override
	public List<User> findAll() {
		System.out.println("[JdbcRepository] findAll");
		return new ArrayList<>();
	}

	@Override
	public Optional<User> findById(String id) {
		System.out.println("[JdbcRepository] findById: " + id);
		return Optional.empty();
	}

	@Override
	public void delete(String id) {
		System.out.println("[JdbcRepository] delete: " + id);
	}

}
