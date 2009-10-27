using System;

namespace Main
{
    public class Program
    {
        public static void Main(string[] args)
        {
            string[] numbers = Console.ReadLine().Split(new char[] { ' ' });

            int a = int.Parse(numbers[0]);
            int b = int.Parse(numbers[1]);

            Console.WriteLine(a + b);
        }
    }
}
