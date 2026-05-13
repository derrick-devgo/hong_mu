import 'dart:convert';

import 'package:cake_lab/cart.dart';
import 'package:cake_lab/cart_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

const dbUrl = 'https://cakelab-3152e-default-rtdb.firebaseio.com/';

const productCategories = ['熱門商品', '節慶蛋糕', '長條蛋糕', '生乳捲'];

class CakeHomePage extends ConsumerStatefulWidget {
  const CakeHomePage({super.key});

  @override
  ConsumerState<CakeHomePage> createState() => _CakeHomePageState();
}

class _CakeHomePageState extends ConsumerState<CakeHomePage> {
  late Future<List<Product>> _future;
  String _selectedCategory = productCategories.first;

  @override
  void initState() {
    super.initState();
    _future = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    // 1. 先登入 Firebase，取得可以讀資料庫的 token。
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final token = await credential.user!.getIdToken(true);

    // 2. 組出 Realtime Database 的網址。
    final url = Uri.parse('$dbUrl/products.json?auth=$token');

    // 3. 用 GET 讀取商品資料。
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('讀取商品失敗');
    }

    // 4. 把 JSON 字串轉成 Dart 資料。
    final data = jsonDecode(response.body);

    if (data == null) {
      return <Product>[];
    }

    final productsMap = data as Map<String, dynamic>;
    final products = <Product>[];

    productsMap.forEach((key, value) {
      final productMap = value as Map<String, dynamic>;
      final product = Product.fromJson(productMap);
      products.add(product);
    });

    return products;
  }

  void _retry() {
    setState(() {
      _future = _fetchProducts();
    });
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void _addToCart(Product product) {
    ref.read(cartProvider.notifier).add(
          CartItem(
            productId: product.title,
            title: product.title,
            price: product.price,
            image: product.image,
            qty: 1,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            '已加入:${product.title}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCartButton(int cartCount) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          tooltip: '購物車',
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: _openCart,
        ),
        if (cartCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: AnimatedSwitcher(
              duration: const Duration(microseconds: 200),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Container(
                key: ValueKey(cartCount),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: ShapeDecoration(
                  color: const Color(0xFFE7393E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  '$cartCount',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('載入失敗'),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: _retry,
            child: const Text('重試'),
          ),
        ],
      ),
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_selectedCategory == '熱門商品') {
      return products;
    }

    return products.where((product) {
      return product.category == _selectedCategory;
    }).toList();
  }

  Widget _buildCategoryBar() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemCount: productCategories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final category = productCategories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            label: Text(category),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF333333),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
            selectedColor: const Color(0xFFE7393E),
            backgroundColor: const Color(0xFFEFEFEF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide.none,
            ),
            onSelected: (selected) {
              setState(() {
                _selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 22,
        mainAxisExtent: 300,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          product: product,
          onAdd: () {
            _addToCart(product);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '紅木蛋糕',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          _buildCartButton(cartCount),
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return _buildErrorView();
          }

          final products = snap.data ?? <Product>[];

          if (products.isEmpty) {
            return const Center(child: Text('目前沒有商品'));
          }

          final visibleProducts = _filterProducts(products);

          return Column(
            children: [
              _buildCategoryBar(),
              Expanded(
                child: visibleProducts.isEmpty
                    ? const Center(child: Text('目前沒有商品'))
                    : _buildProductGrid(visibleProducts),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAdd});

  final Product product;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NT ${product.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
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
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String title;
  final int price;
  final String image;
  final String category;

  Product({
    required this.title,
    required this.price,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final category = json['category'] == null
        ? '熱門商品'
        : json['category'] as String;

    return Product(
      title: json['title'] as String,
      price: (json['price'] as num).toInt(),
      image: json['image'] as String,
      category: category,
    );
  }
}

