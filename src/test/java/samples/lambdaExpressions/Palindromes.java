import java.util.Arrays;
import java.util.List;
import java.util.Comparator;

public class Palindromes {
    public static void main (String[] args) throws Exception {

        List<String> words = Arrays.asList("Hannah", "Ana", "Elle", "Bob", "Otto", "Natan", "Luisa", "Andre", "Renata");

        //compare to the inverse
        Comparator<String> stringComparator = 
            (s1,s2) -> s1.toLowerCase().compareTo(new StringBuilder(s2).reverse().toString().toLowerCase());

        Runnable r = () -> words.forEach(w -> {
            if(stringComparator.compare(w,w) == 0){
                System.out.println(w + " is a palindrome.");
            } else {
                System.out.println(w + " is not a palindrome.");
            }
        });

        Thread t = new Thread(r);
        t.start();
        t.join();

    }
}