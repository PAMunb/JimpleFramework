package samples.students;

import java.util.Random;

public class Student {
	String name;
	int age;
	int reg;
	
	public Student(String name, int age) {
		Random rand = new Random();
		
		this.name = name;
		this.age = age;
		this.reg = rand.nextInt(89999) + 10000;
	}
	
	public Student setAge(int newAge) {
		this.age = newAge;
		
		return this;
	}
}