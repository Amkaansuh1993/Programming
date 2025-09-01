public class Problem1897 {
    public static void main(String[] args) {
        String[] words={"abc","aabc","bc"};
        boolean res=makeEqual(words);
        System.out.println(res);
    }

    public static boolean makeEqual(String[] words) {
        if (words.length == 1) {
                return true;
            }
            int totalCharCount = 0;
            for (String s : words) {
                totalCharCount += s.length();
            }
            if (totalCharCount % words.length != 0) {
                return false;
            }
    
            int[] myMap = new int[26];
            for (String s : words) {
                for (char c : s.toCharArray()) {
                    myMap[c - 'a']++;
                }
            }
            for (int i : myMap) {
                if (i % words.length != 0) {
                    return false;
                }
            }
            return true;
        }
}