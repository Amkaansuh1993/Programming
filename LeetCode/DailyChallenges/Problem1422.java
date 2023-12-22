package LeetCode.DailyChallenges; 

public class Problem1422 {
    public static void main(String[] args) {
        int result=maxScore("1001001");
        System.out.println(result);
    }

    public static int maxScore(String s) {
        char[] c=s.toCharArray();
        int lres=0,rres=0,lsum=0,rsum=0,fin=0;
        for(int i=0;i<s.length()-1;i++)
        {
            rres=0;
            lres=0;
            for ( int j=i+1;j<s.length();j++)
            {
                    if( c[j] == '1') 
                        rres++;
            } rsum=rres;
            for ( int k=0;k<=i;k++)
            {
                if(c[k] == '0')
                    lres++;
            } lsum=lres;
            if ( fin < lsum+rsum )
                fin=lsum+rsum;
        }

        return fin;
    }
    
}