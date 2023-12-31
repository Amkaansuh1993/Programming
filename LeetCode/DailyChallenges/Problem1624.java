Package LeetCode.DailyChallenges;

class Problem1624 {

  public static void main(String[] args) {
		int Res = maxLengthBetweenEqualCharacters("mgntdygtxrvxjnwksqhxuxtrv");
		System.out.println(Res);
	}
    public int maxLengthBetweenEqualCharacters(String s) {
        char[] c=s.toCharArray();
        int count=-1,temp=-1,tempc=-1;
        for ( int  i=0;i<c.length-1;i++)
        {
            for ( int j=c.length-1;j>i;j--)
            {
                if ( c[i] == c[j] )
                {
                    temp=j-i;
                }
                if (tempc<temp)
            {
                tempc=temp;
            }
            }
            
        }
        if (count < tempc)
            {
                count=tempc-1;
            }
        return count;
    }
}
