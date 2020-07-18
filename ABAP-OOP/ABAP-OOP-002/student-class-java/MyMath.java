import java.lang.Math;

public class MyMath {
    public static final double PI = 3.1415926;

    public static double power(double x, double y) {
        return Math.pow(x, y);
    }
}

class MyMathTest {
    public static void main(String[] args) {
        System.out.println(MyMath.PI);
        System.out.println(MyMath.power(25, 3));
    }
}