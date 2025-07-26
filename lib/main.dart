import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/task_view_model.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
            ),
          ),


          home: const HomeScreen(),
      ),
    );
  }
}
