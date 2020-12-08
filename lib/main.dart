import 'package:flutter/material.dart';
import 'package:flutter_try/bloc/post_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_try/homepage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INFINITE',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
          backgroundColor: Colors.pink,
        ),
        body: BlocProvider(
          create: (context) =>
              PostBloc(httpClient: http.Client())..add(PostFetched()),
          child: HomePage(),
        ),
      ),
    );
  }
}
