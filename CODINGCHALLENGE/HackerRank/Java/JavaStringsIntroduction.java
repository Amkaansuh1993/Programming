import java.util.Scanner;

public class JavaStringsIntroduction {
    public static void main(String[] args) {
        
        Scanner sc=new Scanner(System.in);
        String A=sc.next();
        String B=sc.next();
        sc.close();
        /* Enter your code here. Print output to STDOUT. */
        System.out.println(A.length()+B.length());
        // if( A.compareTo(B) >= 0 )
        // flag="Yes";
        // else
        // flag="No";
        System.out.println( A.compareTo(B) >=0  ? "Yes" : "No" );
        System.out.print(A.substring(0,1).toUpperCase()+A.substring(1)+" "+B.substring(0,1).toUpperCase()+B.substring(1));
    }
}
