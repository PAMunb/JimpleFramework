package samples.staticInvoke;

public class StaticInvoke {

  public static void staticInvoke() {
    callee();
  }

  private static void callee() {
    System.out.println("foo");
  }
}