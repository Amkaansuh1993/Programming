import java.util.*;
import java.io.*;

class JavaLoopsII{
    public static void main(String []argh){
        Scanner in = new Scanner(System.in);
        int t=in.nextInt();
        for(int i=0;i<t;i++){
            int a = in.nextInt();
            int b = in.nextInt();
            int n = in.nextInt();
            
             for(int j=0;j<n;j++)
                {
                    int sum=0,k=0;
                    while(k<=j)
                    {
                        sum=sum+(int)(Math.pow(2,k));
                        k++;
                    }
                    System.out.print(a+sum*b+" ");
                }
                System.out.println();
        }
        
       
        in.close();
    }
}