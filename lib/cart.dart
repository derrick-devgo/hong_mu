import 'dart:convert';

import 'package:cake_lab/cart_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

const dbUrl = 'https://cakelab-3152e-default-rtdb.firebaseio.com';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {

//-----------------------------------------
  Future<String> submitOrderToRTDB({
    required List<CartItem> items,
    required int totalPrice,
    String? note, // 可選，想加備註時用
  }) async {
    // 1) 取得登入身分（若未登入就匿名登入）
    final user = FirebaseAuth.instance.currentUser
        ?? (await FirebaseAuth.instance.signInAnonymously()).user!;
    final token = await user.getIdToken(true);

    // 2) 準備訂單資料
    final orderNo = (DateTime.now().millisecondsSinceEpoch % 10000000)
        .toString().padLeft(7, '0');

    final payload = {
      "number": orderNo,
      "uid": user.uid,
      "date": DateTime.now().toUtc().toIso8601String(),
      "total": totalPrice,
      "items": items.map((e) => {
        "title": e.title,
        "price": e.price,
        "image": e.image,
        "qty": e.qty,
      }).toList(),
      "ts": {".sv": "timestamp"},
      if (note != null) "note": note,
    };

    // 3) POST /orders.json
    final url = Uri.parse('$dbUrl/orders.json?auth=$token');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (resp.statusCode != 200) {
      throw Exception('RTDB ${resp.statusCode}: ${resp.body}');
    }

    // 回傳訂單編號（成功時 RTDB 會回 {"name":"-Nx..."} 當 push key）
    return orderNo;
  }


  //----------------






  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final totalQty = ref.watch(cartCountProvider);
    final totalPrice = ref.watch(cartTotalProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new),
          tooltip: '返回',
        ),
        title:const Text(
            '購物車',
            style:TextStyle(
              color: Color(0xFF333333),
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.2 //字元之間的間距
            )
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
          bottom: false,
        child: items.isEmpty?const _EmptyView():ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            itemBuilder: (_,i){
            final item = items[i];
            return _CartTile(
                item: item,
                onMinus: (){
                  if(item.qty<=1){
                    ref.read(cartProvider.notifier).remove(item.productId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Center(child: Text('已從購物車移除')),
                      )
                    );
                  }else{
                    ref.read(cartProvider.notifier).decrement(item.productId);
                  }
                },
                onPlus: ()=>ref.read(cartProvider.notifier).increment(item.productId),
            );
            },
            separatorBuilder: (_,__)=>const SizedBox(height: 20,),
            itemCount: items.length
        )
      ),
      bottomNavigationBar: _SummaryBar(
        totalQty: totalQty,
        totalPrice: totalPrice,
        onCheckout: () async {
          final items = ref.read(cartProvider);
          if (items.isEmpty) return;

          final total = ref.read(cartTotalProvider);

          try {
            // 送出到 RTDB
            final orderNo = await submitOrderToRTDB(
              items: items,
              totalPrice: total,
            );

            // 成功：清空購物車 + 可回到上一頁或顯示成功彈窗
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Center(child: Text('下單成功：編號 $orderNo')),
              ),
            );
            ref.read(cartProvider.notifier).clear();
            if (mounted) Navigator.of(context).maybePop(); // 回上一頁（可依需求調整）
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('下單失敗：$e'),
              ),
            );
          }
        },
      ),
    );
  }
}



// 加減按鈕
class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon,required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1,color: Color(0xFFBABABA)),
            borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon,size:16,color: Color(0xFF333333),),
      ),
    );
  }
}



// 每一個item的樣式
class _CartTile extends StatelessWidget {
  const _CartTile({
    required this.item,
    required this.onMinus,
    required this.onPlus,
  });

  final CartItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 商品圖片
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 87.0,
            height: 87.0,
            child: Image.network(item.image,fit:BoxFit.cover)
          ),
        ),
        const SizedBox(width: 16,),
        // 右側資訊
        Expanded(
            child: SizedBox(
              height: 87.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:const TextStyle(
                      color:Color(0xFF333333),
                      fontSize: 16,
                      height: 1.25,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w400
                    )
                  ),
                  const SizedBox(height: 5,),
                  Text(
                      'NT ${item.price}',
                    style:const TextStyle(
                      color:Color(0xFF333333),
                      fontSize: 16,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w700
                    )
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _SquareIconButton(
                        icon:Icons.remove,
                        onTap: onMinus,
                      ),
                      const SizedBox(width: 12,),
                      Text('${item.qty}'),
                      const SizedBox(width: 12,),
                      _SquareIconButton(
                        icon:Icons.add,
                        onTap: onPlus,
                      )
                    ],
                  ),
                ],
              ),
            )
        )
      ],
    );
  }
}


class _EmptyView extends StatelessWidget {
  const _EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('購物車是空的',style:TextStyle(color: Color(0xFF6B7280))),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.totalQty,
    required this.totalPrice,
    required this.onCheckout,
  });

  final int totalQty;
  final int totalPrice;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20,top:10,bottom: 10+MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color:Colors.white,
          boxShadow: [
            BoxShadow(
              color:const Color(0x26000000),
              blurRadius: 4,
              offset: const Offset(0, -1),
            )
          ],
      ),
      child: Row(
        children: [
          Expanded(
              child: Row(
                children: [
                  Text(
                      '共 $totalQty 件商品',
                      style:const TextStyle(
                        color:Color(0xFF333333),
                        fontSize:14,
                        height:1.43,
                        letterSpacing: 0.2,
                      )
                  ),
                  const Spacer(),
                  Text(
                    'NT $totalPrice',
                    textAlign: TextAlign.right,
                    style:const TextStyle(
                      color:Color(0xFF333333),
                      fontSize: 16,
                      height: 1.25,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w700
                    )
                  )


                ],
              )
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE7393E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(12),
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
                onPressed: totalQty == 0 ? null : onCheckout,
                child: const Text(
                  '去結帳',
                  style:TextStyle(
                    fontSize: 16,
                    height: 1
                  )
                )
            ),
          )
        ],
      ),
    );
  }
}



