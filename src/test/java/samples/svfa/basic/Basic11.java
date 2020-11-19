package samples.svfa.basic;

public class Basic11 {

    public static void main(String args[]) {
        String s1 = source();
        String s2 = "abc";
        String s3 = s1.toUpperCase();
        String s4 = s2.toUpperCase(); // not context sensitive.

        sink(s3);           /* BAD */
        sink(s1 + ";");   /* BAD */
        sink(s4);           /* OK */
    }

    public static String source() {
        return "secret";
    }

    public static void sink(String s) {

    }
}
