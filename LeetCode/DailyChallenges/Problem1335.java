package LeetCode.DailyChallenges;
//TRY THIS
import java.util.ArrayDeque;
import java.util.Deque;

public class Problem1335 {
public static void main(String[] args) {
    int[] s={6,5,4,3,2,1};
    int d=2;
    int Res=minDifficulty(s,d);
    System.out.println(Res);
}

    public static int minDifficulty(int[] jobDifficulty, int d) {
        return minDifficultyOptimized(jobDifficulty, d);
    }

    private static int minDifficultyOptimized(int[] jobDifficulty, int d) {
        int n = jobDifficulty.length;

        if (n < d) {
            return -1;
        } else if (n == d) {
            int totalDifficulty = 0;
            for (int difficulty : jobDifficulty) {
                totalDifficulty += difficulty;
            }
            return totalDifficulty;
        }

        // dp[j]: minimum difficulty of first (j+1) jobs in (i+1) days
        int[] dp = new int[n];
        dp[0] = jobDifficulty[0];

        // Initialize dp with maximum difficulty encountered so far
        for (int i = 1; i < n; i++) {
            dp[i] = Math.max(jobDifficulty[i], dp[i - 1]);
        }

        int[] dpPrev = new int[n];
        Deque<Integer> stack = new ArrayDeque<>(); // Use a deque for the decreasing stack

        // Dynamic Programming with decreasing stack optimization
        for (int i = 1; i < d; i++) {
            int[] temp = dp;
            dp = dpPrev;
            dpPrev = temp;
            stack.clear();

            for (int j = i; j < n; j++) {
                dp[j] = jobDifficulty[j] + dpPrev[j - 1];

                // Process the decreasing stack
                while (!stack.isEmpty() && jobDifficulty[stack.peekLast()] <= jobDifficulty[j]) {
                    int lastIdx = stack.pollLast();
                    dp[j] = Math.min(dp[j], dp[lastIdx] + jobDifficulty[j] - jobDifficulty[lastIdx]);
                }

                if (!stack.isEmpty()) {
                    dp[j] = Math.min(dp[j], dp[stack.peekLast()]);
                }

                stack.addLast(j);
            }
        }

        return dp[n - 1];
    }
}
