import 'dart:convert';

import 'package:cake_lab/cart.dart';
import 'package:cake_lab/cart_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

const dbUrl = 'https://cakelab-3152e-default-rtdb.firebaseio.com/';

class CakeHomePage extends ConsumerStatefulWidget {
  const CakeHomePage({super.key});

  @override
  ConsumerState<CakeHomePage> createState() => _CakeHomePageState();
}

class _CakeHomePageState extends ConsumerState<CakeHomePage> {
  final List<String> _categories = const ['熱門商品','節慶蛋糕','長條蛋糕','生乳捲'];
  int _selectedCategory = 0;
  int _cartCount = 0;


  late Future<List<Product>> _future;

  @override
  void initState(){
    super.initState();
    _future = _fetchProducts();
  }
  
  Future<List<Product>> _fetchProducts() async{
    // 1)匿名登入
    final cred = await FirebaseAuth.instance.signInAnonymously();
    final token = await cred.user!.getIdToken(true);
    
    // 2)GET
    final url = Uri.parse('$dbUrl/products.json?auth=$token');
    final resp = await http.get(url);

    if(resp.statusCode!=200){
      throw Exception('RTDB ${resp.statusCode}:${resp.body}');
    }

    final data = jsonDecode(resp.body);
    if(data==null) return <Product>[];
    if(data is! Map<String,dynamic>){
      throw Exception('Unexpected format:${resp.body}');
    }

    final list = <Product>[];
    data.forEach((k,v){
      try{
        list.add(Product.fromJson(v as Map<String,dynamic>));
      }catch(_){}
    });

    return list;
  }






  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          '紅木蛋糕',
          style:TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                tooltip: '購物車',
                  icon:const Icon(Icons.shopping_cart_outlined),
                  onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_)=>const CartPage())
                  );
                  }
              ),
              if(cartCount>0)
              Positioned(
                right: 8,
                top:8,
                child: AnimatedSwitcher(
                  duration: const Duration(microseconds: 200),
                  transitionBuilder: (child,anim)=>
                  ScaleTransition(scale: anim,child:child),
                  child: Container(
                    key: ValueKey(cartCount),
                    padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE7393E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                      )
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        fontSize: 10,
                        color:Colors.white
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _future,
          builder: (context,snap){
            if(snap.connectionState==ConnectionState.waiting){
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
            final items = snap.data??const[];
            if (items.isEmpty) return const Center(child:Text('目前沒有商品'));

            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,mainAxisSpacing: 12,crossAxisSpacing: 22,mainAxisExtent: 300),
                itemCount: items.length,
                itemBuilder: (context,index){
                  final p = items[index];
                  return _ProductCard(
                      product: p,
                      onAdd: (){
                        ref.read(cartProvider.notifier).add(
                          CartItem(
                              productId: p.title,
                              title: p.title,
                              price: p.price,
                              image: p.image,
                              qty: 1
                          )
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Center(
                            child: Text('已加入:${p.title}',style:const TextStyle(color:Colors.white))),
                            behavior: SnackBarBehavior.floating,
                          )
                        );
                      }
                  );

                }
                );
          },

      )
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product,required this.onAdd});

  final Product product;
  final VoidCallback onAdd;


  @override
  Widget build(BuildContext context) {
    print(product.image);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:Colors.black.withValues(alpha:0.06),
            blurRadius:12,
            offset:const Offset(0,6),
            spreadRadius:-1,
          ),
          BoxShadow(
            color:Colors.black.withValues(alpha:0.025),
            blurRadius:2,
            offset:const Offset(0,1),
            spreadRadius:0,
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.image,fit:BoxFit.cover),
              )
            ),
            const SizedBox(height: 12,),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,height: 1.2,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333)
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'NT ${product.price}',
                  style: const TextStyle(
                    fontSize: 16,fontWeight: FontWeight.w800,letterSpacing: 0.2,
                  ),
                ),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE7393E),
                        shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.shopping_cart,size:18,color: Colors.white,),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Product{
  final String title;
  final int price;
  final String image;

  Product({
    required this.title,
    required this.price,
    required this.image
  });

  factory Product.fromJson(Map<String,dynamic> j) =>Product(
    title:j['title'] as String,
    price:(j['price'] as num).toInt(),
    image:j['image'] as String,
  );
}
