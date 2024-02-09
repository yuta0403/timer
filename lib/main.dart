import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer/nextpage..dart';

void main() {
  runApp(const App());
}

// StatelessWidgetで静的なclassを定義
class App extends StatelessWidget {
  const App({super.key});

//アプリのタイトル部分の数値を実装
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'タイマー'),
    );
  }
}

//StatefullWidgetで動的なclassを定義
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//要件
//分：秒：m秒が表現されている
//変数を3つ定義している
//if文を使って適切なタイミングで変数をインクリメントしている

//初期値を指定
class _MyHomePageState extends State<MyHomePage> {
  int _millisecond = 0;
  int _second = 0;
  int _minute = 0;
  Timer? _timer;
  bool _isRunning = false;

//run状態の挙動を記載
  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(
        const Duration(milliseconds: 1),
        (timer) {
          setState(() {
            _millisecond += 1;
            if (_millisecond >= 1000) {
              _millisecond = 0;
              _second++;
              if (_second >= 60) {
                _second = 0;
                _minute++;
              }
            }
          });
//画面遷移
          if (_minute == 10) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NextPage()),
            );
          }
        },
      );
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  //以下の処理はtoggletimerを動かした際に行われるため不要（スタートするまで動かない）

  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer.periodic(
  //     const Duration(milliseconds: 1),
  //     (timer) {
  //       setState(() {
  //         _millisecond++;
  //         _second++;
  //         _minute++;
  //       });
  //     },
  //   );
  // }
//リセットボタンの値を入れる
  void resetTimer() {
    _timer?.cancel();

    setState(() {
      _millisecond = 0;
      _second = 0;
      _minute = 0;
      _isRunning = false;
    });
  }

//widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_minute.toString().padLeft(2, "0")}',
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  ":",
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  '${_second.toString().padLeft(2, "0")}',
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  ".",
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  '${(_millisecond / 10).toInt().toString().padLeft(2, "0")}',
                  style: TextStyle(fontSize: 50),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                toggleTimer();
              },
              child: Text(
                _isRunning ? 'ストップ' : 'スタート',
                style: TextStyle(
                  color: _isRunning ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                resetTimer();
              },
              child: Text(
                'リセット',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
