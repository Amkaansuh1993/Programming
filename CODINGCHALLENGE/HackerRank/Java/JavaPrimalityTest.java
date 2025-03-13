import java.math.BigInteger;
import java.util.Scanner;

public class JavaPrimalityTest {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String n = sc.next();
        sc.close();
        System.out.println(BigInteger.valueOf(Integer.parseInt(n)).isProbablePrime(Integer.parseInt(n))?"prime":"not Prime");
   }
}