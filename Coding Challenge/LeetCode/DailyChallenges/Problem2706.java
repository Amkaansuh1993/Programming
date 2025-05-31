package LeetCode.DailyChallenges;

public class Problem2706 {

public static void main(String[] args) {
    int[] prices={1,2,2};
    int money=3;
    int result=buyChoco(prices,money);
    System.out.println(result);
}

    public static int buyChoco(int[] prices, int money) 
    {
    for ( int j=0;j<prices.length-1;j++)
        {
            for ( int k=j+1;k<prices.length;k++)
            {
                if ( prices[j] > prices[k] )
                { 
                    int temp = prices[j];
                    prices[j] = prices[k];
                    prices[k] = temp;
                }
            }
        }
        int sum_price[]=new int[prices.length-1];
        for (int i=0;i<prices.length-1;i++)
        {
            int cost = prices[i]+prices[i+1];
            sum_price[i]=money-cost;
        }
for ( int i=0;i<sum_price.length;)
{
    if (sum_price[0]<0)
           return money;
           
           if(sum_price[i]==0)
            {
                return sum_price[i];
            }
           
           return sum_price[0];
            
}
    return money;
}
}
