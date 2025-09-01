public class Problem1758 {
    public static void main(String[] args) {
        int Result=minOperations("10010100");
        System.out.println(Result);
    }

    public static int minOperations(String s) {
        char[] c=s.toCharArray();
        int counter=0;
        int size=s.length()-1;
        for(int i=0;i<size;i++)
        {
            if( c[i] == '0' )
            {if( c[i+1] != '1' ){c[i+1] = '1';counter++;}}
            else 
            {if( c[i+1] != '0' ){c[i+1] = '0';counter++;}}
        }
        c=s.toCharArray();
        int s_counter=0;
        if(c[0] == '0')
            {c[0]='1';s_counter++;} 
            else {c[0]='0';s_counter++;}
        
        for(int i=0;i<size;i++)
        {
            if( c[i] == '0' )
            {if( c[i+1] != '1' ){c[i+1] = '1';s_counter++;}}
            else 
            {if( c[i+1] != '0' ){c[i+1] = '0';s_counter++;}}
        }
    if (counter >= s_counter)
    {
        return s_counter;
    }else
    {
        return counter;
    }
        
    }
}
