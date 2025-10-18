import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const dbUrl = 'https://cakelab-3152e-default-rtdb.firebaseio.com/';




class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  static const _textColor = Color(0xFF333333);
  static const _accentRed = Color(0xFFE7393E);
  static const _divider = Color(0xFFE7E3E3);
  static const _thumbSize = 87.0;

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late Future<List<_Order>> _future;

  @override
  void initState(){
    super.initState();
    _future = _fetchOrders();
  }



  Future<List<_Order>> _fetchOrders() async{
    // 1)匿名登入
    final cred = await FirebaseAuth.instance.signInAnonymously();
    final token = await cred.user!.getIdToken(true);

    // 2)GET
    final url = Uri.parse('$dbUrl/orders.json?auth=$token');
    final resp = await http.get(url);

    if(resp.statusCode!=200){
      throw Exception('RTDB ${resp.statusCode}:${resp.body}');
    }

    final data = jsonDecode(resp.body);
    if(data==null) return <_Order>[];
    if(data is! Map<String,dynamic>){
      throw Exception('Unexpected format:${resp.body}');
    }

    final list = <_Order>[];
    data.forEach((k,v){
      try{
        list.add(_Order.fromJson(v as Map<String,dynamic>));
      }catch(_){}
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title:const Text(
              '訂單紀錄',
              style:TextStyle(
                color:OrderHistoryPage._textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              )
          )
      ),
      body: FutureBuilder<List<_Order>>(
          future: _future,
          builder: (context,snap){
            if(snap.connectionState!=ConnectionState.done){
              return const Center(child: CircularProgressIndicator());
            }
            if(snap.hasError){
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('載入失敗'),
                    const SizedBox(height: 5,),
                    ElevatedButton(onPressed: (){}, child: const Text('重試'))
                  ],
                ),
              );
            }

            final orders = snap.data??const <_Order>[];
            if(orders.isEmpty){
              return const Center(child: Text('目前沒有訂單'));
            }

            return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                itemBuilder: (context,i) =>_OrderCard(
                  order: orders[i],
                ),
                separatorBuilder: (_,__)=>const SizedBox(height: 12,),
                itemCount:orders.length
            );
          }
      )
    );
  }
}










// -----------------------------------------------------------
class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order
  });

  final _Order order;

  static const _textColor = OrderHistoryPage._textColor;
  static const _accentRed = OrderHistoryPage._accentRed;
  static const _divider = OrderHistoryPage._divider;

  String _fmtDate(DateTime d) => '${d.year.toString().padLeft(4,'0')}/${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}';





  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,border:Border.all(color:_divider)
      ),
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 上半部
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _kv('訂單編號', order.number),
                          const SizedBox(height: 4,),
                          _kv('訂購日期',_fmtDate(order.date)),
                          const SizedBox(height: 4,),
                          _kv('總金額', 'NT ${order.total}'),
                          const SizedBox(height: 4,),
                          Text('共 ${order.items.length} 項',style: const TextStyle(color:_textColor,fontSize: 14,letterSpacing: 0.2),),
                        ],
                      )
                  ),
                  // 再訂一次按鈕
                  SizedBox(
                    width: 100,
                    height: 32,
                    child: OutlinedButton(
                        onPressed: (){},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color:_accentRed,width: 1),
                          foregroundColor: _accentRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('再訂一次',style: TextStyle(fontSize: 14,height: 1),)
                    ),
                  )

                ],
              ),
          ),

          // 下半部
          if(order.items.isNotEmpty)
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for(final it in order.items) ...[
                    _Thumb(image:it.image),
                    const SizedBox(width: 10,)
                  ]
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _kv(String k,String v){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(k,
          style:const TextStyle(
            color: _textColor,
            fontSize: 16,
            letterSpacing: 0.2
          ),
        ),
        const SizedBox(width: 8,),
        Text(v,
          style:const TextStyle(
              color: _textColor,
              fontSize: 16,
              letterSpacing: 0.2
          ),
        ),
      ],
    );
  }
}


class _Thumb extends StatelessWidget {
  const _Thumb({required this.image});
  final String image;
  static const _thumbSize = OrderHistoryPage._thumbSize;

  @override
  Widget build(BuildContext context) {
    final isNetwork = image.startsWith('http');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _thumbSize,
        height: _thumbSize,
        child: isNetwork
            ? Image.network(image, fit: BoxFit.cover)
            : Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}






class _Order{
  final String number;
  final DateTime date;
  final int total;
  final List<_OrderItem> items;

  const _Order({
    required this.number,
    required this.date,
    required this.total,
    required this.items,
  });

  factory _Order.fromJson(Map<String,dynamic> j)=>_Order(
      number: j['number'],
      date: DateTime.parse(j['date'] as String),
      total: (j['total'] as num).toInt(),
      items: (j['items'] as List<dynamic>? ?? const[])
      .map((e)=>_OrderItem.fromJson(e as Map<String,dynamic>)).toList(),);
}

class _OrderItem{
  final String image;
  const _OrderItem(this.image);
  factory _OrderItem.fromJson(Map<String,dynamic> j) =>_OrderItem(j['image'] as String);
}
