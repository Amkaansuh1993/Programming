package LeetCode.DailyChallenges;

import java.util.Arrays;

/**
 * Problem286
 */
public class Problem286 {

    public static void main(String[] args) {
        int[] nums={9,6,4,2,3,5,7,0,1};
        int Result=missingNumber(nums);
        System.out.println(Result);
    }

    public static int missingNumber(int[] nums) {
        Arrays.sort(nums);
        // for ( int i=0; i< nums.length; i++ )
        // {
        //     System.out.print(nums[i]);
        // }

        for (int j=0;j< nums.length;j++)
        {
            if ( j != nums[j] )
             return j;
        }

        return nums.length;
    }
}