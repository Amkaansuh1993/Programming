public class Problem26 {
    public static void main(String[] args) {
        int[] nums={1,1,2};
        int k=removeDuplicates(nums);
        for(int l=0;l<=k;l++)
        {System.out.println(nums[l]);}
    }
    public static int removeDuplicates(int[] nums) {
        int j=0;
        for(int i=1;i<nums.length;i++)
        {
            if(nums[j]!=nums[i])
            {
                nums[++j]=nums[i];
            }
        }
        return j;
    }
}
