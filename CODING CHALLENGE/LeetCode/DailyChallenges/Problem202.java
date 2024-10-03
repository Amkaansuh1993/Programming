package LeetCode.DailyChallenges;

class Problem202 {

public static void main(String[] args) {
    int n=19;
    boolean res=isHappy(n);
}

    public static boolean isHappy(int n) {
        int sum;
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
                boolean res = isHappy(sum);

        return res;
    }
    
}