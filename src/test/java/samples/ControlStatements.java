package samples;

import java.util.ArrayList;

public class ControlStatements {

  public void simpleIfElseIfTakeThen() {
    int a = 1;
    int b = 2;
    int c = 3;
    if (a < b) {
      System.out.println(a);
    } else if (a < c) {
      System.out.println(b);
    } else {
      System.out.println(c);
    }
  }

  public void simpleIfElseIfTakeElseIf() {
    int a = 2;
    int b = 1;
    int c = 3;
    if (a < b) {
      System.out.println(a);
    } else if (a < c) {
      System.out.println(b);
    } else {
      System.out.println(c);
    }
  }

  public void simpleIfElseIfTakeElse() {
    int a = 3;
    int b = 2;
    int c = 1;
    if (a < b) {
      System.out.println(a);
    } else if (a < c) {
      System.out.println(b);
    } else {
      System.out.println(c);
    }
  }

  public void simpleIfElseTakeThen() {
    int a = 1;
    int b = 2;
    if (a < b) {
      System.out.println(a);
    } else {
      System.out.println(b);
    }
  }

  public void simpleIfElseTakeElse() {
    int a = 2;
    int b = 1;
    if (a < b) {
      System.out.println(a);
    } else {
      System.out.println(b);
    }
  }

  public void tableSwitch() {
    int a = 1;
    switch (a) {
      case 1:
        System.out.println(a);
      case 2:
        System.out.println(a);
      default:
        System.out.println(a);
    }
  }

}
