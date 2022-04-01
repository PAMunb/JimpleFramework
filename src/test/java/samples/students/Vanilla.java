package samples.students;
 
import java.util.Collections;
import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;

//import datatypes.*;

public class Vanilla {
	public static void main(String[] args) {
		List<Student> students = Collections.emptyList();
		students.add(new Student("Pedro", 30));
		students.add(new Student("João", 25));
		
		Predicate<Student> p = s -> s.name == "Pedro";
		//Function<Student, Student> f = s -> s.setAge(50);
		
		Vanilla v = new Vanilla();
		
		//v.vanilla(students, p, f);
	}
	
	public List<Student> vanilla(List<Student> students, Predicate<Student> p, Function<Student, Student> f) {
		List<Student> result = Collections.emptyList();
		/*List<Student> auxState = students;
		boolean over = false;
		
		while(!over) {
			List<Student> sub = auxState.subList(0, auxState.size());
			
			if(p.test(auxState.get(0))) {
				result.add(f.apply(auxState.get(0)));
			}
			
			auxState = sub;
		}*/
		
		return result;
	}
	
	public List<Student> withFStream(List<Student> students, Predicate<Student> p, Function<Student, Student> f) {
		//return FStream.fstream(students).filterfs(p).mapfs(f).unfstream();
		return Collections.emptyList();
	}
}