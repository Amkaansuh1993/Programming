package LeetCode.DailyChallenges;

import java.util.Arrays;

/**
 * Problem1637
 */
public class Problem1637 {

    public static void main(String[] args) {
        int[][] points={{8,7},{9,9},{7,4},{9,7}};
        int result=maxWidthOfVerticalArea(points);
        System.out.println(result);
    }

    public static int maxWidthOfVerticalArea(int[][] points) {
       int res=0; 
    //     for ( int i=0;i<points.length-1;i++)
    //    {
    //     for ( int j=0;j<points.length-1-i;j++)
    //     {
    //         if ( points[j][0] > points[j+1][0] )
    //         { 
    //             int temp = points[j][0];
    //             points[j][0]=points[j+1][0];
    //             points[j+1][0]=temp;
    //         }
    //     }
    //     }
        Arrays.sort(points, (a, b) -> Integer.compare(a[0], b[0]));
       for ( int i=0;i<points.length-1;i++ )
        {
            if ( res <= points[i+1][0]-points[i][0] )
                res = points[i+1][0]-points[i][0];
        }
        return res;
    }
}