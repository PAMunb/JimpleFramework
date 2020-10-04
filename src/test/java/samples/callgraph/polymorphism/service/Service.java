package samples.callgraph.polymorphism.service;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

import samples.callgraph.polymorphism.domain.Entity;
import samples.callgraph.polymorphism.repository.Repository;
import samples.callgraph.polymorphism.util.Log;

public interface Service<E extends Entity<ID>, ID extends Serializable> extends Log {

	Repository<E, ID> getRepository();

	default E save(E entity) {
		return getRepository().save(entity);
	}

	default E update(E entity) {
		return getRepository().update(entity);
	}

	default List<E> findAll() {
		return getRepository().findAll();
	}

	default Optional<E> findById(ID id) {
		return getRepository().findById(id);
	}

	default void delete(ID id) {
		getRepository().delete(id);
	}

}
