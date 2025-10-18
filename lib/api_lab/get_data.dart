import 'dart:convert';

import 'package:cake_lab/api_lab/post_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Spot{
  final int id;
  final String title;
  final String address;
  final int score;
  final String image;

  Spot({
    required this.id,
    required this.title,
    required this.address,
    required this.score,
    required this.image
  });


  factory Spot.fromJson(Map<String,dynamic> j)=>Spot(
    id: j['id'] as int,
    title:j['title'] as String,
    address: j['address'] as String,
    score: j['score'] as int,
    image:j['image'] as String,
  );
}




class SpotsPage extends StatefulWidget {
  const SpotsPage({super.key});

  @override
  State<SpotsPage> createState() => _SpotsPageState();
}

class _SpotsPageState extends State<SpotsPage> {

  late final Future<List<Spot>> _future;

  @override
  void initState(){
    super.initState();
    _future = _fetchSpots();
  }



  Future<List<Spot>> _fetchSpots() async{
    final cred = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await cred.user!.getIdToken(true);

    final url = Uri.parse('$dbUrl/spots.json?auth=$idToken');
    final resp = await http.get(url);

    if(resp.statusCode!=200){
      throw Exception('error:${resp.statusCode}:${resp.body}');
    }

    final dynamic body = json.decode(resp.body);
    if(body==null) return<Spot>[];

    if(body is! Map<String,dynamic>){
      throw Exception('Unexpected format:${resp.body}');
    }

    final List<Spot> list = [];

    body.forEach((k,v){
      try{
        final m = v as Map<String,dynamic>;
        list.add(Spot.fromJson(m));
      }catch(_){

      }
    });

    return list;


  }


  Future<void> _openAddSpot()async{
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_)=>const AddSpotPage()),
    );

    if(created==true){
      setState(() {
        _future = _fetchSpots();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:const Text('景點列表'),
            actions: [
              IconButton(
                  onPressed: _openAddSpot,
                  icon: const Icon(Icons.add),
                  tooltip: '新增景點',
              )
            ],
        ),
        body:FutureBuilder(
            future: _future,
            builder: (context,snap){
              if (snap.connectionState !=ConnectionState.done){
                return const Center(child: CircularProgressIndicator(),);
              }

              if(snap.hasError){
                return Center(child: Text('讀取失敗:${snap.error}'));
              }

              final spots = snap.data!;

              print(snap.data);

              if(spots.isEmpty){
                return const Center(child: Text('目前沒有景點'),);
              }

              return ListView.builder(
                  itemCount: spots.length,
                  itemBuilder: (context,i){
                    final s = spots[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16/10,
                            child: Image.network(s.image,fit:BoxFit.cover),
                          ),
                          ListTile(
                            title:Text(s.title,style:const TextStyle(fontWeight:FontWeight.w600)),
                            subtitle: Text(s.address),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,size:18),
                                const SizedBox(width: 4,),
                                Text('${s.score}'),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
              );
            }
        )
    );
  }
}
