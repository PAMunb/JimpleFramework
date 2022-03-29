package samples;

public abstract class MasterBenchmarkFibonacci {
    private final int POPSIZE = 200000000;
    private final int MEASUREMENTS = 10;
    private long[] times = new long[MEASUREMENTS];

    public void end(){
        try {
            System.gc();
            Thread.sleep(200);
            System.runFinalization();
            Thread.sleep(200);
            System.gc();
            Thread.sleep(200);
            System.runFinalization();
            Thread.sleep(1000);
            System.gc();
            Thread.sleep(200);
            System.runFinalization();
            Thread.sleep(200);
            System.gc();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public void measure(){
        for(int i = 0; i < MEASUREMENTS; i++){
            long start = System.currentTimeMillis();

            this.work();

            times[i] = System.currentTimeMillis() - start;
            System.out.println("Iteration " + i + ": " + times[i]);

            try {
                System.gc();
                Thread.sleep(1000);
                System.gc();
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        long sumTimes = 0;
        for(int i = 0; i < times.length; i++){
            sumTimes += times[i];
        }

        System.out.println("Time to complete: " + (sumTimes/(float) times.length)/1000);
    }

    public abstract void work();

    /*public void warmUp(){
        System.out.println(xs.size()); //Print collection's size
        System.out.println(ys.size()); //Print collection's size

        Random r = new Random(5);
        System.out.println(xs.get(r.nextInt(POPSIZE/2))); //Print random element
        System.out.println(ys.get(r.nextInt(POPSIZE/2))); //Print random element

        //Calculate sum of even numbers through the use of an iterator for list xs
        long totalSum = 0;
        Iterator<Integer> it = xs.iterator();
        while(it.hasNext()){
            Integer i = it.next();
            if(i % 2 == 0){
                totalSum += i;
            }
        }
        System.out.println("Even number sum for xs: " + totalSum);

        //Calculate sum of odd numbers through the use of an iterator for list ys
        totalSum = 0;
        it = ys.iterator();
        while(it.hasNext()){
            Integer i = it.next();
            if(i % 2 != 0){
                totalSum += i;
            }
        }
        System.out.println("Odd number sum for ys: " + totalSum);
    }*/

    /*public void populate(){
        for(int n = 1; n <= POPSIZE/2; n++){
            xs.add(n);
            ys.add(n + POPSIZE/2);
        }
    }*/
}
