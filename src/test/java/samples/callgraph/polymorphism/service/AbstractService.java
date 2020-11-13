package samples.callgraph.polymorphism.service;

import java.io.Serializable;

import samples.callgraph.polymorphism.domain.Entity;
import samples.callgraph.polymorphism.repository.Repository;

public abstract class AbstractService<E extends Entity<ID>, ID extends Serializable> implements Service<E, ID> {

	private Repository<E, ID> repository;

	public AbstractService(Repository<E, ID> repository) {
		this.repository = repository;
	}

	protected abstract boolean valid(E entity);

	public E save(E entity) {
		log("[AbstractService] save: " + entity);
		if (valid(entity)) {
			return getRepository().save(entity);
		}
		throw new RuntimeException("Invalid entity: "+entity);
	}

	@Override
	public Repository<E, ID> getRepository() {
		return repository;
	}

}
