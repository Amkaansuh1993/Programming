package LeetCode.DailyChallenges;

import java.util.Arrays;

public class Problem1160 {
    public static void main(String[] args) {
        String[] words={"hello","world","leetcode"};
        String chars="welldonehoneyr";
    int Result=countCharacters(words,chars);
    System.out.println(Result);
}    

    public static int countCharacters(String[] words, String chars) {
        char[] c=chars.toCharArray();
        int wlen=words.length;
        int clen=c.length;
        int matched=0;
        Arrays.sort(c);
        for (int i=0;i<wlen;i++)
        {
            char[] temp=words[i].toCharArray();
            Arrays.sort(temp);
            int tlen=temp.length;
            int p=0;
            for ( int j=0;j<clen;j++)
            {
                if(temp[p] == c[j])
                {
                    
                    if(p>=tlen-1)
                    {matched=matched+tlen;break;}
                    p++;
                }
            }
        }
        return matched;
    }
}
