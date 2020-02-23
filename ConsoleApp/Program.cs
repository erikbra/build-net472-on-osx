using System;
using ClassLibrary1;

namespace ConsoleApp
{
    static class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Do(FlipFlop.Flip);
        }

        private static void Do(FlipFlop flipOrFlop)
        {
            Console.WriteLine("Does it flip or flop? " + flipOrFlop);
        }
    }
}
