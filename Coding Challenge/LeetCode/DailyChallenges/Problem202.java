public class Problem202 {
public static void main(String[] args) {
    int n=19;
    boolean res=isHappy(n);
    System.out.println(res);
}

    public static boolean isHappy(int n) {
        int sum;
        boolean res=false;
        if(n == 1)
            return true;
        else
        {
            sum=0;
            while(n>0)
            {
                int temp = n%10;
                sum = sum + temp*temp;
                n=n/10;
            }
        } 
            if (sum != 1 )
                 res = isHappy(sum);

        return res;
    }
    
}