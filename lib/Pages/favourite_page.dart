import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_second/Pages/show_page.dart';

class Favorites extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Favorites> {
  List favourites = [] ;
  int currentIndex = 0; // Add a default value

  void getResidential() async {
    CollectionReference tblProduct =
        FirebaseFirestore.instance.collection('favourites');
    await Future.delayed(Duration(seconds: 2));
    await tblProduct.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        store['documentId'] = doc.id;
        favourites.add(store);
      });


      isloading = false;
      setState(() {});
    });
  }

  void deleteCommercial(String docID, int index) {
    FirebaseFirestore.instance
        .collection('favourites')
        .doc(docID)
        .delete();
    favourites.removeAt(index);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Deleted Successfuly'),
      backgroundColor: Colors.green,
    ));
    setState(() {});
  }

  bool isloading = true;

  @override
  void initState() {
    getResidential();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 20.0, left: 8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Color.fromRGBO(118, 165, 209, 1),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
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
                SizedBox(height: 10.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                        showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("remove frome favourites"),
                                          content: Text(
                                              "Are you sure you want to remove frome favourites?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteCommercial(
                                                        " ${favourites[index]['documentId']}",
                                                        index);
                                                setState(() {});
                                              },
                                              child: Text("remove"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  
                                  
                              


                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         SingleProperty(data: favourites[index]),
                                  //   ),
                                  // );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Image.network(
                                    '${favourites[index]['image']}',
                                    height: 225,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                          '${favourites[index]['propertyStatus']} ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(
                                            '${favourites[index]['propertyPrice']} \$',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Spacer(
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
     
    );
  }
}
