import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'puzzle_classes.dart';
import 'puzzle_functions.dart';
import 'dart:math';
import 'puzzle_globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Puzzle15());
}

class Puzzle15 extends StatefulWidget {
  @override
  _Puzzle15State createState() => _Puzzle15State();
}

class _Puzzle15State extends State<Puzzle15> {
  final String _title = "Sam Loyd's 15-Puzzle";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColor: Colors.blue[400],
        accentColor: Colors.blue[200],
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black)),
      ),
      home: FrontPage(title: _title),
    );
  }
}

class FrontPage extends StatefulWidget {
  String title;
  FrontPage({this.title});

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  void plusSideLength() {
    setState(() {
      if (globals.nbrSideTiles < 8) {
        globals.nbrRows++;
        globals.nbrColumns++;
        globals.nbrSideTiles++;
        Board.initTiles(globals.nbrRows, globals.nbrColumns);
      }
    });
  }

  void minusSideLength() {
    setState(() {
      if (globals.nbrSideTiles > 2) {
        globals.nbrRows--;
        globals.nbrColumns--;
        globals.nbrSideTiles--;
        Board.initTiles(globals.nbrRows, globals.nbrColumns);
      }
    });
  }

  void executeShuffle() {
    setState(() {
      globals.shuffleFlag = true; //prevent initializing
      Board.shuffle(globals.nbrRows, globals.nbrColumns);
      //print("executeShuffle called");
      //print(globals.nbrSideTiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    globals.tileSize =
        getTileSize(context, globals.nbrSideTiles, globals.nbrSideTiles);
    Board.initTiles(globals.nbrRows, globals.nbrColumns);
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(widget.title))),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Spacer(),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          for (int row = 0; row < globals.nbrSideTiles; row++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int col = 0; col < globals.nbrSideTiles; col++)
                  TapTile(
                    id: Board.tiles[row][col],
                    nbrRows: globals.nbrSideTiles,
                    nbrColumns: globals.nbrSideTiles,
                    x: row,
                    y: col,
                  )
              ],
            ),
        ]),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShuffleButton(doShuffle: executeShuffle),
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: plusSideLength,
              child: new Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Colors.amber,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Size = ${globals.nbrSideTiles}',
                  style: TextStyle(fontSize: globals.tileSize / 4)),
            ),
            FloatingActionButton(
              onPressed: minusSideLength,
              child: new Icon(
                Icons.remove,
                color: Colors.black,
              ),
              backgroundColor: Colors.amber,
            ),
          ],
        ),
        Spacer(),
      ]),
    );
  }
}
