package LeetCode.DailyChallenges;

public class Problem1248 {
    public static void main(String[] args) {
        int[] nums={2,2,2,1,2,2,1,2,2,2};
        int k=2;
        int Res = numberOfSubarrays(nums,k);
        System.out.println(Res);
    }
    public static int numberOfSubarrays(int[] nums, int k) {
        int n = nums.length;
        int[] cnt = new int[n + 1];
        cnt[0] = 1;
        int ans = 0, t = 0;
        for (int v : nums) {
            t += v & 1;
            if (t - k >= 0) {
                ans += cnt[t - k];
            }
            cnt[t]++;
        }
        return ans;
    }
}
