package samples.callgraph.polymorphism.repository;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

import samples.callgraph.polymorphism.domain.Entity;

public interface Repository<E extends Entity<ID>, ID extends Serializable>  {

	E save(E entity);

    E update(E entity);

    List<E> findAll();

    Optional<E> findById(ID id);

    void delete(ID id);
	
}
