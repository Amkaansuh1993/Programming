import java.io.*;
import java.util.*;

public class JavaStringReverse {

    public static void main(String[] args) {
        
        Scanner sc=new Scanner(System.in);
        String A=sc.next();
        sc.close();
        char[] c=A.toCharArray();
        int flag=0;
        /* Enter your code here. Print output to STDOUT. */
        if(A.length()==0 || A.length()==1)
        {System.out.print("Yes");
        System.exit(0);}
        else {
            for(int i=0;i<A.length()/2;i++)
                {
                    if(c[i]==c[A.length()-1-i])
                        flag++;
                }
        }
        if(flag==A.length()/2)
        System.out.print("Yes");
        else
        System.out.print("No");
    }
}



