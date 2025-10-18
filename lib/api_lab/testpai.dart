import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const dbUrl = 'https://cakelab-3152e-default-rtdb.firebaseio.com/';

class PostDataPage extends StatefulWidget {
  const PostDataPage({super.key});

  @override
  State<PostDataPage> createState() => _PostDataPageState();
}

class _PostDataPageState extends State<PostDataPage> {

  bool _busy = false;
  String? _lastId;

  Future<void> _postSample()async{
    setState(()=>_busy = true);

    try{
      // 1)用匿名登入拿到ID Token
      final cred = await FirebaseAuth.instance.signInAnonymously();
      final idToken = await cred.user!.getIdToken();

      print(idToken);

      // 2)準備要送的json
      final payload= {
        "name":"Alice",
        "exam":"Math",
        "socre":87,
      };

      // 3)post

      final url = Uri.parse('$dbUrl/submitssions.json?auth=$idToken');
      final resp = await http.post(
          url,
          headers: {'Content-Type':'application/json'},
          body:jsonEncode(payload)
      );

      // 4)回傳

      if(resp.statusCode ==200){
        final data = jsonDecode(resp.body);
        setState(()=>_lastId = data['name']);
      }else{
        throw 'Http ${resp.statusCode}:${resp.body}';
      }
    }catch (e){
      debugPrint('POST 失敗:$e');
    }

    finally{
      setState(()=>_busy = false);
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('測試firebase realtime')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: _busy?null:_postSample,
                child: Text(_busy?'送出中...':'送出')
            ),

            if(_lastId!=null)...[
              const SizedBox(height: 12,),
              Text('成功建立節點 id:$_lastId')
            ],
          ],
        ),
      ),
    );
  }
}
