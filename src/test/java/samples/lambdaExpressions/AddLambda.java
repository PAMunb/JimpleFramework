interface Addable {
    int add(int a, int b);
}

public class AddLambda {
    public static void main (String[] args) {

        Addable sum = (a,b) -> (a+b);

        System.out.println(sum.add(1,2));
    }
}