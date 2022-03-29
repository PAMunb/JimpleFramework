package samples;

import java.lang.invoke.MethodHandles;
import java.math.BigInteger;

public class FibonacciRecursive extends MasterBenchmarkFibonacci{
    private static BigInteger fib(int n){
        if(n <= 1){
            return BigInteger.valueOf(n);
        }
        else{
            return fib(n-1).add(fib(n-2));
        }
    }

    public static void main(String[] args) {
        System.out.println(MethodHandles.lookup().lookupClass().getSimpleName() + "...");

        FibonacciRecursive fibR = new FibonacciRecursive();

        /*fibR.populate();

        fibR.warmUp();*/

        fibR.measure();

        fibR.end();
    }

    @Override
    public void work() {
        BigInteger fib = fib(38);
        System.out.println(fib);
    }
}
