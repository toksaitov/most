import java.util.Scanner;

public class Main
{
       public static void main (String[] argv)
       {
         Scanner theScanner = new Scanner(System.in);
         
         int a = theScanner.nextInt();
         int b = theScanner.nextInt();
		 
         System.out.println(a + b);
       }
}