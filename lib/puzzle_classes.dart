import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'puzzle_functions.dart';
import 'puzzle_globals.dart' as globals;

// The Tile is a square with color and an id number
// The size is derived from the Window dimensions
// ID number is written centrally in the square
// Font size is half tile size, i.e. large
class Tile extends StatelessWidget {
  Color color;
  int id;
  int nbrRows;
  int nbrColumns;
  Tile({this.color, this.id, this.nbrRows, this.nbrColumns});
  @override
  Widget build(BuildContext context) {
    //double tileSize = getTileSize(context, nbrRows, nbrColumns);
    return Container(
        width: globals.tileSize,
        height: globals.tileSize,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(),
        ),
        child: Center(
          child: Text(id.toString(),
              style: TextStyle(fontSize: globals.tileSize / 2)),
        ));
  }
}

class Board extends StatelessWidget {
  static final tiles = List.generate(
      globals.maxRows,
      (i) => List.generate(globals.maxCols, (j) => i * globals.maxCols + j + 1,
          growable: false),
      growable: false);

  static initTiles(int rows, int cols) {
    if (!globals.shuffleFlag) {
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          tiles[i][j] = i * cols + j + 1;
        }
      }
    }
    globals.shuffleFlag = false;
    int p = getParity(rows, cols);
    print("Parity (Init): $p");
  }

  static int getRandomIx(int max) {
    var rng = new Random();
    return rng.nextInt(max);
  }

  static shuffle(int rows, int cols) {
    //print("shuffle routine $rows, $cols");
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        int i = getRandomIx(rows);
        int j = getRandomIx(cols);
        int tem = tiles[i][j];
        tiles[i][j] = tiles[row][col];
        tiles[row][col] = tem;
      }
    }
    int p = getParity(rows, cols);
    print("Parity (Shuffle): $p");
  }

  //The parity of a configuration is given by
  //the parity of the sum of the Manhattan distance
  //of the n^2 tile from home plus the parity of
  //the configuration seen as an nxn permutation.
  // The latter is even or odd if an equivalent
  // set of transpositions is even or odd, respectively.
  //
  //This routine counts the length of the cycle to which
  //for each element, i.e. odd cycles an odd nbr of times,.
  // even cycles an even nbr. of times.
  //
  static getParity(int rows, int cols) {
    int i = 0;
    int j = 0;
    int i0 = 0;
    int iRow = 0;
    int iCol = 0;
    int transCount = 0;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        i = tiles[row][col]; //the origin
        if (i == rows * cols) {
          transCount += rows - row + cols - col; //Manhattan distance parity
        }
        i0 = i;
        iRow = (i / rows).truncate();
        iCol = (i % cols);
        j = tiles[iRow][iCol]; //the destination
        while (i0 != j) {
          transCount++;
          i = j;
          iRow = ((i - 1) / rows).truncate();
          iCol = ((i - 1) % cols);
          j = tiles[iRow][iCol];
        }
      }
    }
    return transCount % 2;
  }

  @override
  Widget build(BuildContext context) {}
}

//
class TapTile extends StatelessWidget {
  int id;
  int nbrRows;
  int nbrColumns;
  int x;
  int y;
  TapTile({this.id, this.nbrRows, this.nbrColumns, this.x, this.y});

  @override
  Widget build(BuildContext context) {
    Color color = globals
        .tileColors[getTileColor(Board.tiles[x][y], x, y, nbrRows, nbrColumns)];
    int id = Board.tiles[x][y];
    bool isLast = detectLastTile(id, nbrRows, nbrColumns);
    //double tileSize = getTileSize(context, nbrRows, nbrColumns);
    return GestureDetector(
      onTap: () {
        print(id.toString() + ' was tapped!');
        if (((y + 1) < nbrColumns) &&
            (Board.tiles[x][y + 1] == nbrRows * nbrColumns)) {
          print(id.toString() + ' can move right');
        } else {
          print(id.toString() + ' cannot move right');
        }
        if ((y > 0) && (Board.tiles[x][y - 1] == nbrRows * nbrColumns)) {
          print(id.toString() + ' can move left');
        } else {
          print(id.toString() + ' cannot move left');
        }
        if (((x + 1) < nbrRows) &&
            (Board.tiles[x + 1][y] == nbrRows * nbrColumns)) {
          print(id.toString() + ' can move down');
        } else {
          print(id.toString() + ' cannot move down');
        }
        if ((x > 0) && (Board.tiles[x - 1][y] == nbrRows * nbrColumns)) {
          print(id.toString() + ' can move up');
        } else {
          print(id.toString() + ' cannot move up');
        }
      },
      child: Container(
          width: globals.tileSize,
          height: globals.tileSize,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(),
          ),
          child: Center(
            child: Text(id.toString(),
                style: TextStyle(fontSize: globals.tileSize / 2)),
          )),
    );
  }
}

class ShuffleButton extends StatelessWidget {
  final Function doShuffle;
  ShuffleButton({this.doShuffle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        doShuffle();
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.amber[500],
        ),
        child: Center(
          child:
              Text('Shuffle', style: TextStyle(fontSize: globals.tileSize / 4)),
        ),
      ),
    );
  }
}
