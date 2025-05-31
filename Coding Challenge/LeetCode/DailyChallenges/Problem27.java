package LeetCode.DailyChallenges;

/**
 * Problem27
 */
public class Problem27 {

    public static void main(String[] args) {
        int[] nums={3, 2, 2, 3};
        int val=2;
        int res = removeElement(nums, val);
        System.out.println(res);
    
    }

    public static int removeElement(int[] nums, int val) {
        int count = 0;
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != val) {
                nums[count] = nums[i];
                count++;
            }
        }
        return count;
    }
}