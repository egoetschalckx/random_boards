import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const maxX = 5;
  static const maxY = 9;

  Queue<Color> usedColors = Queue();

  List<List<Board>> headboard = List.empty(growable: true);
  Column headboardColumn = Column();

  static const Color pecan = Color(0xFFE0A03E);
  static const Color walnut = Color(0xFF450E00);
  static const Color grey = Color(0xFF706F6D);
  static const Color mahogany = Color(0xFFEB9D4A);
  static const Color cabernet = Color(0xFFD04E58);

  static const List<Color> colors = [ pecan, walnut, grey, mahogany, cabernet ];

  @override
  Widget build(BuildContext context) {
    headboard = genHeadboard(maxX, maxY);
    headboardColumn = _headboard2widgets(headboard);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                headboard = genHeadboard(maxX, maxY);
                headboardColumn = _headboard2widgets(headboard);
              });
            },
            tooltip: 'Refresh',
          )
        ],
      ),
      body: Center(child: headboardColumn)
    );
  }

  List<List<Board>> genHeadboard(int x, int y) {
    List<List<Board>> headboard = List.empty(growable: true);
    for (int i = 0; i < y; i++) {
      headboard.add(genBoards(x));
    }

    int temp = 42;

    return headboard;
  }

  List<Board> genBoards(int x) {
    List<Board> boards = List.empty(growable: true);
    var rng = Random();
    int remainX = x;

    int colorRng = -1;
    int lastColor = -1;
    while (remainX > 2) {
      int size = rng.nextInt(remainX);

      int colorRng = rng.nextInt(5);
      while (lastColor == colorRng) {
        colorRng = rng.nextInt(5);
      }
      lastColor = colorRng;
      Board board = Board(size, colors[colorRng]);
      boards.add(board);
      remainX -= size;
    }

    colorRng = rng.nextInt(5);
    while (lastColor == colorRng) {
      colorRng = rng.nextInt(5);
    }
    boards.add(Board(remainX, colors[colorRng]));

    return boards;
  }

  Widget _board2widgets(List<Board> boards) {
    List<Widget> children = List.empty(growable: true);

    for (int i = 0; i < boards.length; i++) {
      children.add(boards[i].toWidget());
    }

    Row row = Row(
      children: children,
    );
    return row;
  }

  Column _headboard2widgets(List<List<Board>> headboard) {
    List<Widget> widgets = List.empty(growable: true);
    //headboard.forEach((b) { widgets.add(_board2widgets(b)) });
    
    for (int i = 0; i < headboard.length; i++) {
      widgets.add(_board2widgets(headboard[i]));
    }

    Column col = Column(
      children: widgets,
    );

    return col;
  }
}

class Board {
  EdgeInsets ei = const EdgeInsets.all(2.0);

  int length;
  Color color;

  Board(this.length, this.color);

  toWidget() {
    DecoratedBox db = DecoratedBox(decoration: BoxDecoration(color: color));
    SizedBox sb = SizedBox(height: 2 * 22, width: length.toDouble() * 150, child: db);
    Padding padding = Padding(
      padding: ei,
      child: sb,
    );

    return padding;
  }
}
