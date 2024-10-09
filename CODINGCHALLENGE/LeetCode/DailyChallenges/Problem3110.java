package LeetCode.DailyChallenges;


/**
 * Problem3110
 */
public class Problem3110 {

    public static void main(String[] args) {
        String S = "hello";
        int Res = scoreOfString(S);
        System.out.println(Res);
    }

    public static int scoreOfString(String S) {
        char[] c = S.toCharArray();
        int Sum=0,tempres=0;
        for ( int i=0; i < S.length()-1 ; i++ )
        {
            // int temp1 = (int)c[i];
            // int temp2 = (int)c[i+1];
            // if (temp2>temp1)
            // { tempres=temp2-temp1; } 
            // else 
            // { tempres=temp1-temp2; } 
            if ((int)c[i+1]>(int)c[i])
            { tempres=(int)c[i+1]-(int)c[i]; } 
            else 
            { tempres=(int)c[i]-(int)c[i+1]; } 

            Sum=Sum+tempres;
        }
        
        return Sum;
    }
}