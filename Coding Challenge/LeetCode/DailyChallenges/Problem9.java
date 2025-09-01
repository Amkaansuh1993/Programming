public class Problem9 {

    public static void main(String[] args) {
        int x = -121;
        Boolean Res = isPalindrome(x);
        System.out.println(Res);
    }

    public static boolean isPalindrome(int x) {
        int temp,i=0;
        int[] Comp=new int[100];
        if (x<0)
        return false;
        else if(x==0)
        return true;
        else {
            while (x!=0)
            {
                temp=x%10;x=x/10;
                Comp[i++]=temp;
            }
            for ( int j=0;j<i/2;j++)
            {
                if(Comp[j]!=Comp[i-1-j])
                return false;
            }
            return true;
        }
    }
}