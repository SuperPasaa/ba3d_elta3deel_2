import 'package:flutter/material.dart';

void main() {
  runApp(ShowResdential());
}

class ShowResdential extends StatelessWidget {
  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Show")),
          backgroundColor: const Color.fromARGB(255, 147, 100, 100),
        ),
        body: ListView(
          children: [
           
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: Center(),
            ),
            SizedBox(
              height: 520,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print('Favourites Icon Pressed');
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 40.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Favourites',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    print('Your Account Icon Pressed');
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Icon(
                          Icons.person_2_outlined,
                          size: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Text(
                          'Your Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
