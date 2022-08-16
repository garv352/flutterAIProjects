import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIservice {
  static const _api_key = '09cc515529mshee1915a2be890cdp1d1930jsn8dbe5046f927';
  static const String _baseUrl =
      'https://twinword-emotion-analysis-v1.p.rapidapi.com/analyze/';
  static const Map<String, String> _header = {
    'content-type': 'application/x-www-form-urlencoded',
    'x-rapidapi-host': 'twinword-emotion-analysis-v1.p.rapidapi.com',
    'x-rapidapi-key': _api_key,
    'useQueryString': 'true',
  };

  Future<SentAna> post({@required Map<String, String> query}) async {
    final response = await http.post(_baseUrl, headers: _header, body: query);

    if (response.statusCode == 200) {
      print('sucess' + response.body);
      return SentAna.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to load data');
    }
  }
}

class SentAna {
  final String emotions;

  SentAna({this.emotions});

  factory SentAna.fromJson(Map<String, dynamic> json) {
    return SentAna(emotions: json['emotions_deteched'][0]);
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  final mycontroller = TextEditingController();

  APIservice apIservice = APIservice();
  Future<SentAna> analysis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                'Senti analysis',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              SizedBox(height: 60),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: mycontroller,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                          labelText: 'Enter'),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // _loading = false;
                                print(mycontroller.text);
                                analysis = apIservice
                                    .post(query: {'text': mycontroller.text});
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 250,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                'Find Emotion',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 21),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<SentAna>(
                            future: analysis,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  'prd' + snapshot.data.emotions,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 29),
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              return CircularProgressIndicator();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
