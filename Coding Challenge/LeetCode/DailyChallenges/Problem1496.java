public class Problem1496 {

    public static void main(String[] args) {
        Boolean Result = isPathCrossing("SN");
        System.out.println(Result);
    }

    public static boolean isPathCrossing(String path) {
        int size=path.length();
        int x=0,y=0;
        int[][] move=new int[size+1][2];
        move[0][0]=x;move[0][1]=y;
        char[] cpath=path.toCharArray();
        for ( int i=0;i<size;i++)
        {
            switch (cpath[i]) {
                case 'N': y++;
                    break;
                case 'E': x++;                            
                    break;
                case 'W': x--;
                    break;
                case 'S': y--;
                    break;
            }
            move[i+1][0]=x;move[i+1][1]=y;
        }
        for (int i=0;i<size;i++)
        {
            for (int j=i+1;j<=size;j++)
            {   
                if(move[i][0]==move[j][0] && move[i][1]==move[j][1])
                {
                    return true;
                }
            }
        }
        return false;
    }
}
