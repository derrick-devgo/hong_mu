import 'package:flutter/material.dart';

class P1 extends StatelessWidget {
  const P1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("傳參數練習")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonCard(name: "Amy", age: 20),
            SizedBox(height: 12,),
            PersonCard(name: "John", age: 25),
          ],
        ),
      ),
    );
  }
}




class PersonCard extends StatelessWidget {
  final String name;
  final int age;
  const PersonCard({super.key,required this.name,required this.age});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        border:Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Text(
        "名字:$name,年齡:$age歲"
      ),
    );
  }
}

