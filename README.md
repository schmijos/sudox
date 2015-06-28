# Sudo-X

This Sudoku solver written in Pascal was my Matura project in 2006.

It's consisting of a GUI where you can generate new Sudokus, solve them and get help if you don't know further. The Sudoku generation is achieved by using [Knuth's Algorith X](https://en.wikipedia.org/wiki/Knuth%27s_Algorithm_X) and backtracking.

The main challenge was processing the data structure using recursive function calls. As data structure I used big arrays. This is the most pragmatic approach and not very fast because most of the fields are zeroed. A stretch goal would have been to use double-linked lists (the "dancing links" extension).

![](https://github.com/schmijos/sudox/raw/master/screenshot.png)
