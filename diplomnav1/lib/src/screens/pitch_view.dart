
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:mime/mime.dart';


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
  String? pitch_image;
  String currComment = "";
  var headersImg;


  void getRequestPitchComments() async{
    String url = apiUrl + "/comment/all?pitchId=" + currentPitch.id;
    var jsonData = await sendRequest(url, 'get', null);
    comments = [];

    for(var p in jsonData){
      String url = apiUrl + '/user/' + p['user_id'];

      var jsonData = await sendRequest(url, 'get', 'null');

      String commentUsername = jsonData["username"];

      if(p["attachment_uri"] != null){
        setState(() {
          comments.add(new Comment(commentUsername, p["content"], p["attachment_uri"]));
        });
      }else{
        setState(() {
          comments.add(new Comment(commentUsername, p["content"], p["attachment_uri"]));
        });
      }
    }
  }
  void getRequestPitchRating() async{
    String url = apiUrl + "/rating/average?pitchId=" + currentPitch.id;
    var jsonData = await sendRequest(url, 'get', null);
    double average_rating = jsonData["average_rating"];
    print("average_rating = $average_rating" );
    setState(() {
      rating = average_rating;
    });
  }
  void getPitchImage() async {
    String url = apiUrl + "/pitch/" + currentPitch.id;
    var jsonData = await sendRequest(url, 'get', null);
    setState(() {
      pitch_image = jsonData["attachment_uri"];
    });
  }

  void setCommentHeaders() async{
    headersImg = {
      "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
      "Content-type": "image/jpeg",
    };
  }

  @override
  void initState() {
    super.initState();
    currentPitch = widget.sentPitch;
    getRequestPitchComments();
    getRequestPitchRating();
    setCommentHeaders();
    getPitchImage();
  }

  Widget build(context){

    final ScrollController _scrollController = ScrollController();
    image = null;

    print("rating");
    print(rating);
    print("rating");

    print(currentPitch.id );


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
                            //Text("Id: " + currentPitch.id),
                            Text("Name: " + currentPitch.name),
                            Text("Type: " + currentPitch.type),
                          ]
                      ),
                    ],
                  ),
                ),
                Container(
                  child:
                    pitch_image != null ?
                    Image.network(apiUrl + pitch_image!, headers: headersImg) : SizedBox(height: 15),
                ),

                Container(
                  child: Column(
                    children: [
                      Text(
                        'Rating: $rating',
                        style: TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 32,),
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
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final com = comments[index];
                          return Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(com.comment_name),
                                  subtitle: Text(com.comment_text),
                                ),
                                com.comment_image != null ?
                                Image.network(apiUrl + com.comment_image!, headers: headersImg) : Container(
                                  child: SizedBox(height: 15),
                                ),
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
                        onPressed: () async {
                          if(image == null){
                            String url = apiUrl + '/comment/?user_id=' + oid + '&pitch_id=' + currentPitch.id + '&content=' + currComment;
                            var dio = Dio();
                            try {
                              var response = await dio.post(url, data: null, options: Options(headers: {"Authorization": "Bearer " + (await SecureStorage.getToken() as String)},));
                              print(response.data);
                            } catch (e) {
                              print(e);
                            }
                          }else{
                            String url = apiUrl + '/comment/?user_id=' + oid + '&pitch_id=' + currentPitch.id + '&content=' + currComment;
                            var dio = Dio();
                            var imageBytes = await image!.readAsBytesSync();

                            try {
                              var headers = {
                                "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
                                "Content-type": "image/jpeg",
                                'Connection': 'keep-alive',
                                'Content-Length': imageBytes!.length,
                              };
                              var response = await dio.post(url,
                                  data: Stream.fromIterable(imageBytes.map((e) => [e])),
                                  options: Options(contentType: lookupMimeType(image!.path),headers: headers));
                              print(response.statusCode);
                            } catch (e) {
                              print(e);
                            }
                          }

                          setState(() {
                            getRequestPitchComments();
                          });

                        },
                        child: Text("Add Comment"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if(role == "ADMIN"){
                            if(image != null){
                              String url = apiUrl + '/pitch/' + currentPitch.id + '/blob';
                              var dio = Dio();
                              var imageBytes = await image!.readAsBytesSync();

                              try {
                                var headers = {
                                  "Authorization": "Bearer " + (await SecureStorage.getToken() as String),
                                  "Content-type": "image/jpeg",
                                  'Connection': 'keep-alive',
                                  'Content-Length': imageBytes!.length,
                                };
                                //File file = File.fromUri(Uri.parse(image!.path));
                                var response = await dio.patch(url,
                                    data: Stream.fromIterable(imageBytes.map((e) => [e])),
                                    options: Options(contentType: lookupMimeType(image!.path),headers: headers));
                                print(response.statusCode);
                              } catch (e) {
                                print(e);
                              }
                              setState(() {
                                getPitchImage();
                              });
                            }
                          }
                        },
                        child: Text("Add Pitch image"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text("Pick image"),
                      ),

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
      onRatingUpdate: (currRating) {
        setState(() {
          this.rating = currRating;
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
                String url = apiUrl + '/rating';


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