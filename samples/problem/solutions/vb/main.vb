Imports System

Module Main

    Sub Main()
        Dim numbers As String() = Console.ReadLine().Split(New Char() {" "c})

        Dim a As Integer = Integer.Parse(numbers.First)
        Dim b As Integer = Integer.Parse(numbers.Last)

        System.Console.WriteLine(a + b)
    End Sub

End Module