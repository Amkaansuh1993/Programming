package LeetCode.DailyChallenges;

/**
 * Problem1438
 */
public class Problem1438 {

    public static void main(String[] args) {
        int[] nums={693,6771,2395,7652,2605,4868,651,4927,9588,4796,514,8577,5365,4816,522,7989,1423,2678,9757,6280,8079,4324,7360,369,6881,573,4833,805,5686,3269,5609,2964,4011,2266,1492,667,1546,2532,5035,5177,8078,9707,9399,9816,7767,352,6309,9465,8913,6216,3843,8609,2332,9013,1714,6836,9063,6321,3666,9126,139,9768,9364,9214,5182,6719,6365,9143,3580,2174,7162,2895,1793,9303,1846,4881,2877,5764,7742,8153,8633,2630,9635,4380,3931,4326,1156,8344,5332,4011,9995,9113,3597,4305,2646,2148,931,7583,5843,2114,4072,4989,680,6953,7319,8074,870,2844,9180,6198,8166,5121,5028,4559,2595,5861,8692,6040,1520,7033,3969,5953,1548,5774,3980,1082,6006,8754,5090,705,9333,5802,8494,205,6310,1573,37,38,9402,2934,7572,1788,3548,6114,1089,8390,2261,6565,3020,7174,9941,1553,8446,4463,7852,2985,6136,2474,1982,2187,1273,6491,2643,2989,3677,4705,1754,807,9872,3567,104,9751,3527,206,7246,3141,6164,4867,2446,5559,6093};
        int limit = 9487;
        int Res = longestSubarray(nums, limit);
        System.out.println(Res);
    }

    public static int longestSubarray(int[] nums, int limit) {
        int Value,finalresult=0,k=0;
        for(int i=0;i<nums.length;i++)
        {
            Value=0;
            int j=i,MIN=nums[i],MAX=nums[i];
            while(j<nums.length)
            {
                for( k=i;k<=j;k++)
                {
                    System.out.print(nums[k]+",");
                    if(MIN>nums[k]) MIN=nums[k];
                    if(MAX<nums[k]) MAX=nums[k];
                }
                // if( Math.abs(nums[i]-MIN) > Math.abs(nums[i]-MAX) )
                //     Value = Math.abs(nums[i]-MIN);
                // else
                //     Value = Math.abs(nums[i]-MAX);
                Value=Math.abs(MIN-MAX);
                if(Value <= limit )
                    { if(finalresult< k-i) finalresult=k-i;
                    System.out.print("++"+Value);}
                j++;
                System.out.println();
            }
            System.out.println();

        }

        return finalresult;
    }
}