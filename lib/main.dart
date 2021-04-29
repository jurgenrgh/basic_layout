import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  final String _title = "Sam Loyd's 15-Puzzle";
  int nbr_tiles_side = 4;
  int tile_width = 60;
  int tile_height = 60;

  @override
  Widget build(BuildContext context) {
    Board.shuffle(4);
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColor: Colors.blue[400],
        accentColor: Colors.blue[200],
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      home: Scaffold(
        appBar: AppBar(title: Center(child: Text(_title))),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                TapTile(color: Colors.amber, id: Board.tiles[0][0]),
                TapTile(color: Colors.blue, id: Board.tiles[1][0]),
                TapTile(color: Colors.amber, id: Board.tiles[2][0]),
                TapTile(color: Colors.blue, id: Board.tiles[3][0]),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Tile(color: Colors.blue, id: Board.tiles[0][1]),
                Tile(color: Colors.amber, id: Board.tiles[1][1]),
                Tile(color: Colors.blue, id: Board.tiles[2][1]),
                Tile(color: Colors.amber, id: Board.tiles[3][1]),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Tile(color: Colors.amber, id: Board.tiles[0][2]),
                Tile(color: Colors.blue, id: Board.tiles[1][2]),
                Tile(color: Colors.amber, id: Board.tiles[2][2]),
                Tile(color: Colors.blue, id: Board.tiles[3][2]),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Tile(color: Colors.blue, id: Board.tiles[0][3]),
                Tile(color: Colors.amber, id: Board.tiles[1][3]),
                Tile(color: Colors.blue, id: Board.tiles[2][3]),
                Tile(color: Colors.amber, id: Board.tiles[3][3]),
              ]),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TheButton(),
            ],
          ),
          Spacer(),
        ]),
      ),
    );
  }
}

// The Tile is a square with color and an id number
// The size is derived frrom the Window dimensions
// ID number is writen centrally in the square
// Fontsize is half tile size, i.e. large
class Tile extends StatelessWidget {
  Color color;
  int id;
  Tile({this.color, this.id});
  @override
  Widget build(BuildContext context) {
    double tileSize = getTileSize(context, 4);
    return Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(),
        ),
        child: Center(
          child: Text(id.toString(), style: TextStyle(fontSize: tileSize / 2)),
        ));
  }
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context,
    {double dividedBy = 1, double reducedBy = 0.0}) {
  return (screenSize(context).height - reducedBy) / dividedBy;
}

double screenWidth(BuildContext context,
    {double dividedBy = 1, double reducedBy = 0.0}) {
  return (screenSize(context).width - reducedBy) / dividedBy;
}

double getTileSize(BuildContext context, int nbr,
    {double scale = 0.9, double margin = 8.0}) {
  double screen_width = screenWidth(context);
  double screen_height = screenHeight(context);
  double square_side =
      scale * ([screen_width, screen_height].reduce(min)) - margin;

  double tile_side = (square_side / nbr);
  return tile_side;
}

class TheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Board.shuffle(4);
        print('The Button was tapped!');
      },
      child: Container(
        height: getTileSize(context, 4),
        width: 2 * getTileSize(context, 4),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.amber[500],
        ),
        child: Center(
          child: Text('Shuffle', style: TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}

class TapTile extends StatelessWidget {
  Color color;
  int id;
  TapTile({this.color, this.id});
  @override
  Widget build(BuildContext context) {
    double tileSize = getTileSize(context, 4);
    return GestureDetector(
      onTap: () {
        print(id.toString() + ' was tapped!');
      },
      child: Container(
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(),
          ),
          child: Center(
            child:
                Text(id.toString(), style: TextStyle(fontSize: tileSize / 2)),
          )),
    );
  }
}

class Board {
  static var tiles = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16]
  ];

  static int getRandomIx(int max) {
    var rng = new Random();
    return rng.nextInt(max);
  }

  static shuffle(int size) {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        int i = getRandomIx(size);
        int j = getRandomIx(size);
        int tem = tiles[i][j];
        tiles[i][j] = tiles[row][col];
        tiles[row][col] = tem;
      }
    }
  }
}
