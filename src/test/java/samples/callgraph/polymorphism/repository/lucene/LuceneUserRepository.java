package samples.callgraph.polymorphism.repository.lucene;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.repository.Repository;

public class LuceneUserRepository implements Repository<User, String> {

	@Override
	public User save(User entity) {
		log("[LuceneRepository] save: " + entity);
		return entity;
	}

	@Override
	public User update(User entity) {
		log("[LuceneRepository] update: " + entity);
		return entity;
	}

	@Override
	public List<User> findAll() {
		log("[LuceneRepository] findAll");
		return new ArrayList<>();
	}

	@Override
	public Optional<User> findById(String id) {
		log("[LuceneRepository] findById: " + id);
		return Optional.empty();
	}

	@Override
	public void delete(String id) {
		log("[LuceneRepository] delete: " + id);
	}

}
