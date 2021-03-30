import java.util.Arrays;
import java.util.List;
import java.util.Comparator;

public class Runners {
    public static void main (String[] args) throws Exception {

        List<String> words = Arrays.asList("Hannah", "Bob", "Otto", "Natan", "Luisa", "Andre", "Renata");

        List<Integer> nums = Arrays.asList(-2, -1, 0, 1, 2);

        //compare to the inverse
        Comparator<String> stringComparator = 
            (s1,s2) -> s1.toLowerCase().compareTo(new StringBuilder(s2).reverse().toString().toLowerCase());

        Runnable rString = () -> words.forEach(w -> {
            if(stringComparator.compare(w,w) == 0){
                System.out.println(w + " is a palindrome.");
            } else {
                System.out.println(w + " is not a palindrome.");
            }
        });

        Comparator<Integer> intComparator = 
            (i1, i2) -> i1.compareTo(i2);

        Runnable rInteger = () -> nums.forEach(n -> {
            if (intComparator.compare(n, 0) == 0) {
                System.out.println("ZERO");
            } else {
                System.out.println(n);
            }
        });

        Thread t1 = new Thread(rString);
        t1.start();
        t1.join();

        Thread t2 = new Thread(rInteger);
        t2.start();
        t2.join();
    }
}