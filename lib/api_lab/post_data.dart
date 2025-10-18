import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const dbUrl = 'https://cakelab-3152e-default-rtdb.firebaseio.com/';

class AddSpotPage extends StatefulWidget {
  const AddSpotPage({super.key});

  @override
  State<AddSpotPage> createState() => _AddSpotPageState();
}

class _AddSpotPageState extends State<AddSpotPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _scoreCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose(){
    _idCtrl.dispose();
    _titleCtrl.dispose();
    _addrCtrl.dispose();
    _scoreCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    if(!_formKey.currentState!.validate()) return;
    setState(()=>_busy=true);

    try{
      // 1) 匿名登入並強製刷新token
      final cred = await FirebaseAuth.instance.signInAnonymously();
      final token = await cred.user!.getIdToken(true);

      // 2) 組payload
      final id = int.parse(_idCtrl.text.trim());
      final score = int.parse(_scoreCtrl.text.trim());
      final payload = {
        "id":id,
        "title":_titleCtrl.text.trim(),
        "address":_addrCtrl.text.trim(),
        "score":score,
        "image":_imageCtrl.text.trim(),
      };

      // 3)POST到/spots
      final url = Uri.parse('$dbUrl/spots.json?auth=$token');
      final resp = await http.post(
        url,
        headers: {'Content-Type':'application/json'},
        body:jsonEncode(payload),
      );

      if(resp.statusCode ==200){
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('新增成功!'))
        );
        Navigator.of(context).maybePop(true);
      }else{
        throw 'HTTP ${resp.statusCode}:${resp.body}';
      }

    }catch(e){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('新增失敗!'))
      );
    }finally{
      if(mounted) setState(()=>_busy = false);
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('新增景點')),
      body:Padding(
          padding: const EdgeInsets.all(16),
        child: Form(
          key:_formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idCtrl,
                decoration: const InputDecoration(labelText: 'ID(int)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: '標題'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _addrCtrl,
                decoration: const InputDecoration(labelText: '地址'),
                keyboardType: TextInputType.number,
              ),TextFormField(
                controller: _scoreCtrl,
                decoration: const InputDecoration(labelText: '評分'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: '圖片網址'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20,),
              FilledButton.icon(
                  onPressed: _busy?null:_submit,
                  icon:const Icon(Icons.send),
                  label: Text(_busy?'送出中':'送出'),
              )
            ],
          ),
        ),
      )
    );
  }
}

