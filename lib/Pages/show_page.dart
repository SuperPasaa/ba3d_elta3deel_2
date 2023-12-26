// ignore_for_file: prefer_const_constructors, unused_import, missing_required_param, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/tour_request_page.dart';
import 'package:project_second/helper/ShowSnackBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SingleProperty extends StatefulWidget {
  final Map<String, dynamic> data;

  const SingleProperty({Key? key, this.data = const {}}) : super(key: key);

  @override
  State<SingleProperty> createState() => _CCState();
}

GlobalKey<ScaffoldState> _ss = GlobalKey();
final rentController = TextEditingController();
final nameController = TextEditingController();
final mailController = TextEditingController();
final numberController = TextEditingController();

///

///
double lat1 = -1.546696;
double long1 = 64.053505;
//////
double lat2 = 17.844916;
double long2 = 197.736456;
//
bool isFavorite = false;

///
GoogleMapController? gmc;

///
StreamSubscription<Position>? positionStream;

List<Marker> marker = [
  // Marker(markerId: MarkerId("1"), position: LatLng(26.559074, 31.695669))
];
CameraPosition camera = CameraPosition(
  target: LatLng(26.559074, 31.695669),
  zoom: 14.4746,
);

class _CCState extends State<SingleProperty> {
  initialstreem() async {
    LocationPermission permission;
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      print("Servcies location is not enabled ");
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("location permmision is denid");
      }
    }
    if (permission == LocationPermission.whileInUse) {
      positionStream =
          Geolocator.getPositionStream().listen((Position? position) {
        marker.add(Marker(
            markerId: MarkerId("1"),
            position: LatLng(position!.latitude, position!.longitude)));
        // gmc!.animateCamera(CameraUpdate.newLatLng(
        //     LatLng(position!.latitude, position!.longitude)));
        setState(() {});
      });
    }
  }
  //StreamSubscription<Position>? positionStream;
  ///////////////////////////////////////////////////////get current location //////////
//   getCurrentlocation() async {
// //bool serviceEnabled;
//     //LocationPermission permission;
//     // serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     // if (serviceEnabled==false) {
//     //   return;
//     // }
//     //  permission = await Geolocator.checkPermission();
//     // if (permission == LocationPermission.denied) {
//     //   permission = await Geolocator.requestPermission();
//     //   if (permission == LocationPermission.denied) {
//     //     print("denid");
//     //   }
//     // }
//     // if (permission == LocationPermission.whileInUse) {
//     //   Position position = await Geolocator.getCurrentPosition();
//     //   // positionStream =
//       //   Geolocator.getPositionStream().listen((Position? position) {
//       // print("===========================");
//       // print(position!.latitude) ;
//       // print(position!.longitude) ;
//       // print("===========================");
//       // });

//       double distanceInMeters =
//           Geolocator.distanceBetween(lat1, long1, lat2, long2);
//       print("============================");
//       print(distanceInMeters / 1000);
//       print("============================");
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//   }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    super.dispose();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    //getCurrentlocation();
    initialstreem();
    checkFavoriteStatus();
    super.initState();
  }

  void launchWhatsapp({@required number, @required message}) async {
    String whatsAppURL = "whatsapp://send?+2001211406202";
    launchUrl(Uri.parse(whatsAppURL));
  }

  launchPhoneDialer(String phoneNumber) async {
    String url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }

  void checkFavoriteStatus() async {
    try {
      CollectionReference collRef =
          FirebaseFirestore.instance.collection('favourites');

      QuerySnapshot existingFavorites = await collRef
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('propertyType', isEqualTo: '${widget.data['propertyType']}')
          .where('latitude', isEqualTo: '${widget.data['latitude']}')
          .where('longitude', isEqualTo: '${widget.data['latitude']}')
          .where('address', isEqualTo: '${widget.data['propertyAdress']}')
          .where('oldphoneNumber', isEqualTo: '${widget.data['phoneNumber']}')
          .where('propertyDetails',
              isEqualTo: '${widget.data['propertyDetails']}')
          .where('propertyPrice', isEqualTo: '${widget.data['propertyPrice']}')
          .where('propertyRentDuration',
              isEqualTo: '${widget.data['propertyRentDuration']}')
          .where('propertyStatus',
              isEqualTo: '${widget.data['propertyStatus']}')
          .get();

      setState(() {
        isFavorite = existingFavorites.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking data in Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      key: _ss,
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromRGBO(118, 165, 209, 1),
          // Adjust the size as needed
        ),
        //  backgroundColor: Colors.white,
      ),
      body: Column(
        //mainAxisAlignment:MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.grey[200],
            child: Image.network(
              '${widget.data['image']}',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                CollectionReference collRef =
                    FirebaseFirestore.instance.collection('favourites');
      
                if (!isFavorite) {
                  // The property is not in favorites, so add it
                  await collRef.add({
                    "id": FirebaseAuth.instance.currentUser!.uid,
                    'image': '${widget.data['image']}',
                    'propertyType': '${widget.data['propertyType']}',
                    'latitude': '${widget.data['latitude']}',
                    'longitude': '${widget.data['latitude']}',
                    'address': '${widget.data['propertyAdress']}',
                    'oldphoneNumber': '${widget.data['phoneNumber']}',
                    'propertyDetails': '${widget.data['propertyDetails']}',
                    'propertyPrice': '${widget.data['propertyPrice']}',
                    'propertyRentDuration':
                        '${widget.data['propertyRentDuration']}',
                    'propertyStatus': '${widget.data['propertyStatus']}',
                  });
      
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Favorite Added Successfully'),
                    ),
                  );
                } else {
                  // The property is already in favorites
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content:
                          Text('This property is already in your favorites.'),
                    ),
                  );
                }
      
                setState(() {
                  isFavorite = !isFavorite; // Toggle the favorite status
                });
              } catch (e) {
                print('Error adding/checking data in Firestore: $e');
              }
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 40, top: 16),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 40,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "A ${widget.data['propertyType']} for ${widget.data['propertyStatus']} in ${widget.data['propertyAdress']} with an area  \n of 300 square meters consisting of : \n ${widget.data['propertyDetails']} \n the ${widget.data['propertyStatus']} price is: ${widget.data['propertyPrice']} \$ \n is empty for ${widget.data['propertyRentDuration']} Months ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 150,
            child: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onTap: (LatLng latLng) {
                      marker.add(Marker(
                          markerId: MarkerId("1 "),
                          position:
                              LatLng(latLng.latitude, latLng.longitude)));
                      setState(() {});
                    },
                    initialCameraPosition: camera,
                    mapType: MapType.normal,
                    markers: marker.toSet(),
                    onMapCreated: (mapcontroller) {
                      gmc = mapcontroller;
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  onPrimary: Colors.black,
                  side: BorderSide(width: 0, color: Colors.white),
                  backgroundColor: Color.fromRGBO(118, 165, 209, 1),
                ),
                onPressed: () {
                  _ss.currentState!.showBottomSheet(
                    (context) => SingleChildScrollView(
                      child: SizedBox(
                        height: 600,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                "Make Offer",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: GestureDetector(
                                    onTap: (){
                                    applyDiscount(5);
                                    } ,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(0xffEEF1F6),
                                      ),
                                      height: 40,
                                      width: 125,
                                      child: Center(
                                        child: Text(
                                          " -5%",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    applyDiscount(10);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: .1,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xffEEF1F6),
                                    ),
                                    height: 40,
                                    width: 125,
                                    child: Center(
                                      child: Text(
                                        "-10%",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    
                                    onTap: () {
                                      applyDiscount(5);
                                      '${widget.data['propertyPrice']}' ;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: .1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Color(0xffEEF1F6),
                                      ),
                                      height: 40,
                                      width: 125,
                                      child: Center(
                                        child: Text(
                                          " -15%",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  " ${widget.data['propertyStatus']} you want",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            /////////////////////////////
                            
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: rentController,
                                decoration: InputDecoration(
                                  counterText: '${widget.data['propertyPrice']}' ,                                  labelText:'${widget.data['propertyPrice']}' ,
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 123, 24, 24),
                                      width: 1,


                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your Name",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your Email",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: mailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "Enter your number",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                              width: 400,
                              child: TextFormField(
                                controller: numberController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                            
                                /////////////////////////////////////make offer///////////////////////////////
                                ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        CollectionReference collRef =
                                            FirebaseFirestore.instance
                                                .collection('offers');
                                        await collRef.add({
                                          "id": FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'rent': rentController.text,
                                          'name': nameController.text,
                                          'mail': mailController.text,
                                          'new phoneNumber':
                                              numberController.text,
                                          'image': '${widget.data['image']}',
                                          'propertyType':
                                              '${widget.data['propertyType']}',
                                          'latitude':
                                              '${widget.data['latitude']}',
                                          'longitude':
                                              '${widget.data['latitude']}',
                                          'address':
                                              '${widget.data['propertyAdress']}',
                                          'oldphoneNumber':
                                              '${widget.data['phoneNumber']}',
                                          'propertyDetails':
                                              '${widget.data['propertyDetails']}',
                                          'propertyPrice':
                                              '${widget.data['propertyPrice']}',
                                          'propertyRentDuration':
                                              '${widget.data['propertyRentDuration']}',
                                          'propertyStatus':
                                              '${widget.data['propertyStatus']}',
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content:
                                                Text('Data Added Successfuly'),
                                          ),
                                        );
                                      } catch (e) {
                                        print(
                                            'Error adding data to Firestore: $e');
                                      }
                                    },
                                    child: Text(
                                      "make offer",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                Spacer(
                                  flex: 1,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.local_offer_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  "Make Offer ",
                ),
              ),
              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  onPrimary: Colors.black,
                  side: BorderSide(width: 0, color: Colors.white),
                  backgroundColor: Color.fromRGBO(118, 165, 209, 1),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourRequestPage(),
                      ));
                },
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  " Tour Request ",
                ),
              ),
            ],
          ),
          SizedBox(height: 19),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  launchWhatsapp();
                },
                child: Image.asset(
                  'Assets/whatsapp.png',
                  height: 46.5,
                  width: 50,
                ),
              ),
              InkWell(
                onTap: () {
                  launchPhoneDialer("+201211406202");
                },
                child: Image.asset(
                  'Assets/44.jpg',
                  height: 50,
                  width: 50,
                ),
              ),
            ],
          ),
        ],
      ),
      //   ),
      // ),
    );
  }
  void applyDiscount(double discountPercentage) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('ResidentialProperty') // Replace with your actual collection name
        .doc('${widget.data['propertyPrice']}')    // Use widget.data['ss'] as the document ID
        .get();

    Map<String, dynamic> data = snapshot.data() ?? {};
    double originalPrice = (data['propertyPrice'] ?? 0).toDouble();

      
    double discountedPrice = originalPrice - (originalPrice * (discountPercentage / 100));

    // Show an AlertDialog with the discounted price
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discounted Price'),
        content: Text('Discounted Price: \$${discountedPrice.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (error) {
    print('Error applying discount: $error');
  }
}

}

// void ShowSnackBar(BuildContext context, String message, Color color) {
//   final snackBar = SnackBar(
//     content: Text(message),
//     backgroundColor: Colors.green, // Set the background color here
//   );

//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }
