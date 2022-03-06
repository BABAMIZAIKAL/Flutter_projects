
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';


import 'package:diplomnav1/src/Pitch/pitch.dart';
import 'package:diplomnav1/src/Request/sendRequest.dart';
import 'package:diplomnav1/src/Request/sendRequestComment.dart';
import 'package:diplomnav1/src/Storage/secureStorage.dart';
import 'package:diplomnav1/src/screens/login_screen.dart';
import 'package:diplomnav1/src/widgets/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
//import 'package:comment_box/comment/comment.dart';
import 'package:comment_box/comment/test.dart';
import 'package:comment_box/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'homepage.dart';

class PitchView extends StatefulWidget{
  final Pitch sentPitch;
  PitchView({required this.sentPitch});

  createState(){
    return PitchViewState();
  }
}
class PitchViewState extends State<PitchView>{

  //final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List<Comment> comments = [
  ];

  late Pitch currentPitch;
  double rating = 0;
  File? image;

  void getRequestPitch() async{
    String url = apiUrl + "comment/all?pitchId=" + currentPitch.id;
    var jsonData = await sendRequest(url, 'get', null);
    for(var p in jsonData){

    }
  }

  @override
  void initState() {
    super.initState();
    currentPitch = widget.sentPitch;
  }

  Widget build(context){

    String currComment = "";
    image = null;

    print(oid);


    return Scaffold(
      // ignore: unnecessary_new
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("Pitch view"),
                decoration: BoxDecoration(color: Colors.blueGrey),
              ),
              ListTile(
                title: Text('Back to Map'),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()));
                }
              ),
            ],
          ),
        ),
        appBar: AppBar(
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Table(
                    children: [
                      TableRow(
                          children: [
                            Text("Id: " + currentPitch.id),
                            Text("Name: " + currentPitch.name),
                            Text("Type: " + currentPitch.type),
                            Text("Location: " + currentPitch.stringLocation()),
                            //Text("WayId: " + currentPitch.stringWayIdtest()),

                          ]
                      ),

                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Rating: $rating',
                        style: TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 32,),
                      //buildRating(),
                      //const SizedBox(height: 32,),
                      TextButton(
                          onPressed: () => showRating(),
                          child: Text(
                            'Rate us',
                            style: TextStyle(fontSize: 32),
                          ),
                      )

                    ],
                  )
                ),
                Container(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final com = comments[index];
                          return Container(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(com.comment_name),
                                  subtitle: Text(com.comment_text),
                                ),
                                com.comment_image != null ? Image.file(com.comment_image!) : Container(),
                              ],
                            ),
                          );
                        },
                      ),
                      TextField(
                        onChanged: (com){
                          currComment = com;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {

                            String url = apiUrl + 'comment';
                            if(image != null){
                              print("here");
                              comments.add(new Comment(apiUsername, currComment, image));
                              print("here");
                            }else{
                              comments.add(new Comment(apiUsername, currComment));
                            }
                            Map<String, dynamic> data = {
                              'user_id': oid,
                              'pitch_id': currentPitch.id,
                              'content' : currComment
                              //'attachment' :
                            };
                            //encode Map to JSON
                            //var body = json.encode(data);

                            /*var dio = Dio();
                            try {
                              var headers = {
                                "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
                                "Content-type": "multipart/form-data",
                              };
                              FormData formData = new FormData.fromMap(data);
                              var response = await dio.post(url, data: formData, options: Options(headers: {"Authorization": "Bearer " + (await SecureStorage.getToken() as String)},));
                              print(response.data);
                            } catch (e) {
                              print(e);
                            }*/


                            //var jsonData = await sendRequestComment(url, 'post', data);
                          });

                        },
                        child: Text("Add Comment"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text("Pick image"),
                      ),
                      /*ListView(
                        children: comments,
                      )*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget buildRating() => RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      itemSize: 46,
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber,),
      updateOnDrag: true,
      onRatingUpdate: (rating) {
        setState(() {
          this.rating = rating;
        });
      }
  );
  void showRating() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rate This App'),
        content: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please leave a star rating.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32,),
            buildRating(),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                String url = apiUrl + 'rating';


                Map data = {
                  "user_id": oid,
                  "pitch_id": currentPitch.id,
                  "grade": rating,
                };
                //encode Map to JSON
                var body = json.encode(data);

                var jsonData = await sendRequest(url, 'post', body);

              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20),
              )
          ),
        ],
      ),
  );

  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;

      final imageTemponary = File(image.path);

      this.image = imageTemponary;


    }on PlatformException catch (e){
      print("Failed to pick image: $e");
    }
  }

}