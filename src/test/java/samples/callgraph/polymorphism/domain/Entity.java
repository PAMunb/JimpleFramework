package samples.callgraph.polymorphism.domain;

import java.io.Serializable;

@FunctionalInterface
public interface Entity<ID extends Serializable> extends Serializable {

    ID getId();

}
