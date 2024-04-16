package LeetCode.DailyChallenges;

import java.util.Arrays;

/**
 * Problem217
 */
public class Problem217 {

    public static void main(String[] args) {
        int[] nums={0,1,2,3,4};
        Boolean res=containsDuplicate(nums);
        System.out.println(res);
    }
    public static boolean containsDuplicate(int[] nums) {
        Arrays.sort(nums);
        int length=nums.length;
        for ( int i=0;i<length-1;i++)
        {
            if(nums[i]==nums[i+1])
                {
                    return true;
                }
        }
        return false;
    }
}