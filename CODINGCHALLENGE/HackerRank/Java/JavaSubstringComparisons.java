import java.util.Scanner;

public class JavaSubstringComparisons {

    public static void main(String[] args) {
        System.out.println(getSmallestAndLargest("welcometojava", 3));
    }
    public static String getSmallestAndLargest(String s, int k) {
        String smallest = "";
        String largest = "";
        
        int length=s.length();
        String[] temp=new String[length];
        
        for ( int i=0; i<=length-k; i++)
            temp[i]=s.substring(i,i+k);
    
        int j=0;
        smallest=largest=temp[0];
        while(j<=length-k)
            {
                if( temp[j].compareTo(smallest) < 0 )
                    { smallest=temp[j];}
                
                if( temp[j].compareTo(largest) > 0  )
                { largest=temp[j];}
                j++;
            }
            
        // Complete the function
        // 'smallest' must be the lexicographically smallest substring of length 'k'
        // 'largest' must be the lexicographically largest substring of length 'k'
        
        return smallest + "\n" + largest;
    }
    
}

