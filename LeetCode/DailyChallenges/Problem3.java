package LeetCode.DailyChallenges;

public class Problem3 {
    public static void main(String[] args) {
        String s="asjrgapa";
        char ch;
        String rs="";
        for (int i=0; i<s.length(); i++)
      {
        ch= s.charAt(i); //extracts each character
        rs= ch+rs; //adds each character in front of the existing string
      }


        int Res=Math.max(lengthOfLongestSubstring(s),lengthOfLongestSubstring(rs));
        System.out.println(Res);
    }
    public static int lengthOfLongestSubstring(String s) {
        if(s.length()==0)
        return 0;

        char[] c=s.toCharArray();
        char[] fin=new char[c.length];
        int j=0;
        fin[j]=c[0];
        boolean flag;
        for(int i=1;i<c.length;i++)
        {
            flag=false;
            for(int k=0;k<=j;k++)
            {
                if (c[i]==fin[k])
                flag=true;
            }
            if(flag==false)
            {j++;
                fin[j]=c[i];
                ;
            }
        }
        String nfin=String.copyValueOf(fin,0,j+1);
        int res=Math.max(Lcheck(s,nfin),Rcheck(s,nfin));

        return res;
    }

    public static int Lcheck(String s,String c)
    {
        for(int i=0;i<c.length();i++)
        {
            System.out.println("L"+c.substring(i));
            if (s.contains(c.substring(i)))
            {
                System.out.println("LRESULT"+c.substring(i).length());
                return c.substring(i).length();
            }
        }
        return 0;
    }

    public static int Rcheck(String s,String c)
    {
        for(int i=0;i<c.length();i++)
        {
            System.out.println("R"+c.substring(0,c.length()-(i)));
            if (s.contains(c.substring(0,c.length()-(i))))
            {
                System.out.println("RRESULT"+c.substring(0,c.length()-(i)).length());
                return c.substring(0,c.length()-(i)).length();
            }
        }
        return 0;
    }
}
