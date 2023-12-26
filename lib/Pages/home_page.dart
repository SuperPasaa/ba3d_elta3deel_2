import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_second/Pages/favourite_page.dart';
import 'package:project_second/Pages/show_Res_page.dart';
import 'package:project_second/Pages/show_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List Residential = [];
  bool isloading = true;
  int currentIndex = 0;
  bool isselected = true;
  User? currentUser = FirebaseAuth.instance.currentUser;

  void getResidential() async {
    CollectionReference tblProduct =
        FirebaseFirestore.instance.collection('ResidentialProperty');
    await Future.delayed(Duration(seconds: 2));
    await tblProduct.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        store['documentId'] = doc.id;
        Residential.add(store);
      });

      isloading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    getResidential();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("LoginPage", (route) => false);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
        title: Center(child: Text('')),
      ),
      drawerEnableOpenDragGesture: false,
      drawerEdgeDragWidth: 0,
      drawer: Drawer(
        child: ListView(
  children: [
    UserAccountsDrawerHeader(
      accountName: Text('User Name'),
      accountEmail: Text(currentUser?.email ?? 'N/A'),
      currentAccountPicture: CircleAvatar(),
      decoration: BoxDecoration(
        color: Color.fromRGBO(118, 165, 209, 1),
      ),
    ),
    SizedBox(height: 50),
    ListTile(
      title: const Text('Edit your profile'),
      leading: Icon(Icons.edit),
      onTap: () {
        // Handle tap on Edit Profile
      },
    ),
    ListTile(
      title: const Text('Favorites'),
      leading: Icon(Icons.favorite),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Favorites()),
        );
      },
    ),
    ListTile(
      title: const Text('Notifications'),
      leading: Icon(Icons.notifications),
      onTap: () {
        // Handle tap on Notifications
      },
    ),
    ListTile(
      title: const Text('Contact Us'),
      leading: Icon(Icons.contact_support),
      onTap: () {
        // Handle tap on Contact Us
      },
    ),
    ListTile(
      title: const Text('Log Out'),
      leading: Icon(Icons.logout),
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil("LoginPage", (route) => false);
      },
    ),
  ],
),

      ),
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find your best ',
                      style: TextStyle(
                        color: Color.fromRGBO(56, 73, 106, 1),
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'Property ',
                      style: TextStyle(
                        color: Color.fromRGBO(56, 73, 106, 1),
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(213, 215, 219, 1),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Categories ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowResdential(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.house,
                              size: 40,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Residential',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 12,
                              ),
                            ),
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(160.0, 60.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowResdential(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.apartment,
                              size: 40,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Commercial',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 12,
                              ),
                            ),
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(160.0, 60.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Featured Properties ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {},
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 250, // You can adjust the height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Residential.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SingleProperty(data: Residential[index]),
                                ),
                              );
                            },
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    width: 200,
                                    color: Colors.grey[200],
                                    child: Image.network(
                                      '${Residential[index]['image']}',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${Residential[index]['propertyType']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '${Residential[index]['propertyStatus']}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          '${Residential[index]['propertyPrice']}',
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        )
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
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favourite',
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: isselected ? Colors.red : Colors.white,
        unselectedItemColor: Color.fromRGBO(65, 73, 106, 1),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Favorites()),
            );
          }
          setState(() {});
        },
      ),
    );
  }
}
