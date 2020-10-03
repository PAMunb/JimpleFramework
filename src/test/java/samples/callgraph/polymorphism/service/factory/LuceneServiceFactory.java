package samples.callgraph.polymorphism.service.factory;

import samples.callgraph.polymorphism.domain.User;
import samples.callgraph.polymorphism.domain.UserImpl;
import samples.callgraph.polymorphism.repository.lucene.LuceneUserRepository;

public class LuceneServiceFactory extends ServiceFactory {

	@SuppressWarnings("unchecked")
	@Override
	protected LuceneUserRepository getRepository() {
		return new LuceneUserRepository();
	}

	@Override
	public User createContact(String id, String name, String email, String phone) {
		return new UserImpl(id, name, email, phone);
	}

}
