/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
package LeetCode.DailyChallenges;

import java.util.Iterator;

public class Problem2 {
    public static void main(String[] args) {
    }

    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode Result=new ListNode();
        ListNode headl1=null,headl2=null,headres=null,taill1=null,taill2=null,tailres=null,curl1=null,curl2=null,curres=null;
        int i=0,temp=0;
        headl1=l1;headl2=l2;headres=Result;
        curl1=headl1;
        while(curl1.val != '\0')
        {
            i++;
            curl1=curl1.next;
        }
        curl1=headl1;
        
        for (int j=0;j<i;j++)
        {
        curres.val=curl1.val+curl2.val;
        if(curres.val >=10)
        {
        temp = curres.val/10;
        curres.val=curres.val%10;
        }
        curl1=curl1.next;curl2=curl2.next;curres=curres.next;
        curl1.val=curl1.val+temp;   
        }
        return Result;
    }

        
public class ListNode {
      int val;
      ListNode next;
      ListNode() {}
      ListNode(int val) { this.val = val; }
      ListNode(int val, ListNode next) { this.val = val; this.next = next; }
  }
}
