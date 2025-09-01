public class Problem1 {
public static void main(String[] args) {
    int[] nums={2,7,11,15};
    int target=9;
    int[] Result=twoSum(nums,target);
    for(int i=0;i<Result.length;i++)
    System.out.println(Result[i]);
}
public static int[] twoSum(int[] nums, int target) {
    for ( int i=0; i<nums.length-1; i++ )
    {
        for ( int j=i+1; j<nums.length; j++ )
        {
                if ( target == nums[i]+nums[j] )
                {
                    int[] res={i,j};
                    return res;
                }
        }
    }
        return nums;
}
}