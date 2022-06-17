import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Make control direction here
enum Direction {
  up,
  down,
  left,
  right,
}

//will launch first time when we run the app
void main(){
  runApp(const MyApp());
}

//MyApp will called by main because it`s already declared above
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: const HomePage(),
    );
  }
}

//we need this class because in MyApp class this class is called
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> SnakePos = [24,44,64];
  int FoodLoc = Random().nextInt(700);
  bool start = false;
  Direction direction = Direction.down;
  List<int> TotalSpot = List.generate(760, (index) => index);

  //this method function is when we start the app it will declared snake position and timer
  StartGame(){
    start = true;
    SnakePos = [24,44,64];
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      UpdateSnake();
      if(GameOver()){
        GameOverAlert();
        timer.cancel();
      }
    });
  }

  //This method will run when the game is running
  UpdateSnake(){
    //controller
    setState((){
      switch(direction){
        case Direction.down:
          if(SnakePos.last > 740){
            SnakePos.add(SnakePos.last-700+20);
          }else{
            SnakePos.add(SnakePos.last+20);
          }
          break;
        case Direction.up:
          if(SnakePos.last < 20){
            SnakePos.add(SnakePos.last+700-20);
          }else{
            SnakePos.add(SnakePos.last-20);
          }
          break;
        case Direction.right:
          if((SnakePos.last+1)%20==0){
            SnakePos.add(SnakePos.last+760-20);
          }else{
            SnakePos.add(SnakePos.last+20);
          }
          break;
        case Direction.left:
          if(SnakePos.last%20==0){
            SnakePos.add(SnakePos.last-1+20);
          }else{
            SnakePos.add(SnakePos.last-1);
          }
          break;
        default:
      }
      //This code function run when we eat food
      if(SnakePos.last == FoodLoc){
        TotalSpot.removeWhere((element)=> SnakePos.contains(element));
        FoodLoc = TotalSpot[Random().nextInt(TotalSpot.length-1)];
      }else{
        SnakePos.removeAt(0);
      }
    });
  }

  bool GameOver(){
    final copyList = List.from(SnakePos);
    if(SnakePos.length>copyList.toSet().length){
      return true;
    }else{
      return false;
    }
  }

  GameOverAlert(){
    showDialog(
      context: context,
      builder: (BuildContext context){
       return AlertDialog(
         title: const Text(
           'Game Over',
         ),
         content: Text(
           'Ýour score is : '+(SnakePos.length-3).toString(),
         ),
         actions: [
           TextButton(
               onPressed: () {
                 StartGame();
                 Navigator.of(context).pop(true);
               },
               child: const Text('Play Again')),
           TextButton(
               onPressed: () {
                 SystemNavigator.pop();
               },
               child: const Text('Exit'))
         ],
       );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (direction != Direction.up && details.delta.dy > 0) {
              direction = Direction.down;
            }
            if (direction != Direction.down && details.delta.dy < 0) {
              direction = Direction.up;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (direction != Direction.left && details.delta.dx > 0) {
              direction = Direction.right;
            }
            if (direction != Direction.right && details.delta.dx < 0) {
              direction = Direction.left;
            }
          },
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 760,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 20,
            ),
            itemBuilder: (context,index){
              if (SnakePos.contains(index)) {
                return Container(
                  color: Colors.blue,
                );
              }
              if (index == FoodLoc) {
                return Container(
                  color: Colors.green[900],
                );
              }
              return Container(
                color: Colors.black,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          StartGame();
        },
        child: start
            ? Text((SnakePos.length - 3).toString())
            : const Text('Start'),
      ),
    );
  }
}