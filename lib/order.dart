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


// 以下純UI


// import 'package:flutter/material.dart';

// class OrderHistoryPage extends StatefulWidget {
//   const OrderHistoryPage({super.key});

//   // 統一定義顏色與常數
//   static const _textColor = Color(0xFF333333);
//   static const _accentRed = Color(0xFFE7393E);
//   static const _divider = Color(0xFFE7E3E3);
//   static const _thumbSize = 87.0;

//   @override
//   State<OrderHistoryPage> createState() => _OrderHistoryPageState();
// }

// class _OrderHistoryPageState extends State<OrderHistoryPage> {
  
//   // ------------------------------------------------------
//   // 這裡就是「寫死」的本地資料，完全對應你的截圖內容
//   // 請確保你的 assets/images 資料夾下有這些圖片，或修改下方的路徑
//   // ------------------------------------------------------
//   final List<_Order> _orders = [
//     _Order(
//       number: '3345699',
//       date: DateTime(2025, 7, 1),
//       total: 1965,
//       items: const [
//         _OrderItem(image: 'assets/images/cake1.png'),      // 切片蛋糕
//         _OrderItem(image: 'assets/images/cake2.png'),  // 巧克力蛋糕
//         _OrderItem(image: 'assets/images/cake3.png'), // 原味生乳捲
//       ],
//     ),
//     _Order(
//       number: '6218041',
//       date: DateTime(2025, 10, 18),
//       total: 1515,
//       items: const [
//         _OrderItem(image: 'assets/images/strawberry_cake.png'), // 草莓蛋糕
//         _OrderItem(image: 'assets/images/roll_cake_choco.png'), // 巧克力捲
//       ],
//     ),
//     _Order(
//       number: '6271680',
//       date: DateTime(2025, 10, 18),
//       total: 1350,
//       items: const [
//         _OrderItem(image: 'assets/images/roll_cake_orange.png'), // 芒果/橘子捲
//       ],
//     ),
//     _Order(
//       number: '4873788',
//       date: DateTime(2025, 12, 5),
//       total: 3105,
//       items: const [
//         _OrderItem(image: 'assets/images/cake_party.png'),
//         _OrderItem(image: 'assets/images/cake_special.png'),
//       ],
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F9F9),
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           title: const Text(
//               '訂單紀錄',
//               style: TextStyle(
//                 color: OrderHistoryPage._textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.2,
//               )
//           )
//       ),
//       // 不需要 FutureBuilder 了，直接顯示 List
//       body: _orders.isEmpty 
//           ? const Center(child: Text('目前沒有訂單'))
//           : ListView.separated(
//               padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//               itemBuilder: (context, i) => _OrderCard(
//                 order: _orders[i],
//               ),
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemCount: _orders.length,
//             ),
//     );
//   }
// }

// // -----------------------------------------------------------
// // 訂單卡片 UI 組件
// // -----------------------------------------------------------
// class _OrderCard extends StatelessWidget {
//   const _OrderCard({
//     required this.order
//   });

//   final _Order order;

//   // 為了方便直接使用上層定義的顏色
//   static const _textColor = OrderHistoryPage._textColor;
//   static const _accentRed = OrderHistoryPage._accentRed;
//   static const _divider = OrderHistoryPage._divider;

//   String _fmtDate(DateTime d) =>
//       '${d.year.toString().padLeft(4, '0')}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white, 
//           border: Border.all(color: _divider)
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 上半部：文字資訊 + 按鈕
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Row(
//               children: [
//                 Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _kv('訂單編號', order.number),
//                         const SizedBox(height: 4),
//                         _kv('訂購日期', _fmtDate(order.date)),
//                         const SizedBox(height: 4),
//                         _kv('總金額', 'NT ${order.total}'),
//                         const SizedBox(height: 4),
//                         Text(
//                           '共 ${order.items.length} 項',
//                           style: const TextStyle(
//                               color: _textColor, 
//                               fontSize: 14, 
//                               letterSpacing: 0.2),
//                         ),
//                       ],
//                     )
//                 ),
//                 // 再訂一次按鈕
//                 SizedBox(
//                   width: 100,
//                   height: 32,
//                   child: OutlinedButton(
//                       onPressed: () {
//                         // TODO: 實作再訂一次的邏輯
//                         debugPrint('點擊了再訂一次: ${order.number}');
//                       },
//                       style: OutlinedButton.styleFrom(
//                         side: const BorderSide(color: _accentRed, width: 1),
//                         foregroundColor: _accentRed,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                         padding: EdgeInsets.zero,
//                       ),
//                       child: const Text(
//                         '再訂一次',
//                         style: TextStyle(fontSize: 14, height: 1),
//                       )
//                   ),
//                 )
//               ],
//             ),
//           ),

//           // 下半部：商品縮圖列表
//           if (order.items.isNotEmpty) ...[
//              const SizedBox(height: 10), // 增加一點間距
//              SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   for (final it in order.items) ...[
//                     _Thumb(image: it.image),
//                     const SizedBox(width: 10)
//                   ]
//                 ],
//               ),
//             ),
//           ]
//         ],
//       ),
//     );
//   }

//   // 輔助方法：產生 Key-Value 文字列
//   Widget _kv(String k, String v) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(k,
//           style: const TextStyle(
//               color: _textColor,
//               fontSize: 16,
//               letterSpacing: 0.2
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(v,
//           style: const TextStyle(
//               color: _textColor,
//               fontSize: 16,
//               letterSpacing: 0.2
//           ),
//         ),
//       ],
//     );
//   }
// }

// // 圖片縮圖組件
// class _Thumb extends StatelessWidget {
//   const _Thumb({required this.image});
//   final String image;
//   static const _thumbSize = OrderHistoryPage._thumbSize;

//   @override
//   Widget build(BuildContext context) {
//     // 這裡優先假設是本地 asset 圖片
//     // 如果未來還有可能有網址，可保留判斷邏輯
//     final isNetwork = image.startsWith('http');
    
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: SizedBox(
//         width: _thumbSize,
//         height: _thumbSize,
//         child: isNetwork
//             ? Image.network(image, fit: BoxFit.cover)
//             : Image.asset(
//                 image, 
//                 fit: BoxFit.cover,
//                 // 如果找不到圖片，顯示灰色方塊避免報錯
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(color: Colors.grey[300]);
//                 },
//               ),
//       ),
//     );
//   }
// }

// // -----------------------------------------------------------
// // 資料模型 (移除 fromJson 因為不需要解析 API 了)
// // -----------------------------------------------------------
// class _Order {
//   final String number;
//   final DateTime date;
//   final int total;
//   final List<_OrderItem> items;

//   const _Order({
//     required this.number,
//     required this.date,
//     required this.total,
//     required this.items,
//   });
// }

// class _OrderItem {
//   final String image;
//   const _OrderItem({required this.image});
// }