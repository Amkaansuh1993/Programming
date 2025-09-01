public class Problem13 {
    public static void main(String[] args) {
        String S="MCMXCIV";
        int Res = romanToInt(S);
        System.out.println(Res);
        
    }

    public static int romanToInt(String S) {
        int res=0,i=0,len=S.length();
        char[] c = S.toCharArray();
        while (i<len)
        {
            switch (c[i]) {
                case 'I': res=res+1;
                    break;
                case 'V': if(i!=0 && c[i-1] == 'I') {res=res-1;res=res+4;} else {res=res+5;}
                    break;
                case 'X': if(i!=0 && c[i-1] == 'I') {res=res-1;res=res+9;} else {res=res+10;}
                    break;
                case 'L': if(i!=0 && c[i-1] == 'X') {res=res-10;res=res+40;} else {res=res+50;}
                    break;
                case 'C': if(i!=0 && c[i-1] == 'X') {res=res-10;res=res+90;} else {res=res+100;}
                    break;
                case 'D': if(i!=0 && c[i-1] == 'C') {res=res-100;res=res+400;} else {res=res+500;}
                    break;
                case 'M': if(i!=0 && c[i-1] == 'C') {res=res-100;res=res+900;} else {res=res+1000;}
                    break;
            }
            i++;
        }
        return res;
    }
}
