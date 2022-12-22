import 'package:flutter/material.dart';

class ListCategoriesPage extends StatelessWidget {
  const ListCategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Text('pedram');
        },
      ),
    );
  }
}
