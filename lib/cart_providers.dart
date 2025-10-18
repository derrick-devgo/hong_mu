import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem{
  final String productId;
  final String title;
  final int price;
  final String image;
  final int qty;

  const CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.qty,
  });

  CartItem copyWith({int? qty}) =>CartItem(
      productId: productId,
      title: title,
      price: price,
      image: image,
      qty: qty??this.qty
  );

}

class CartNotifier extends Notifier<List<CartItem>>{
  @override
  List<CartItem> build()=>const[];

  void add(CartItem item){
    final i = state.indexWhere((e)=>e.productId==item.productId);
    if(i==-1){
      state = [...state,item];
    }else{
      final cur = state[i];
      state = [
        for(final e in state)
          if(e.productId == item.productId)
            e.copyWith(qty:cur.qty+item.qty)
          else
            e
      ];
    }

  }

  void increment(String productId,[int step=1]){
    state = [
      for(final e in state)
        if(e.productId == productId) e.copyWith(qty:e.qty+step) else e
    ];
  }

  void decrement(String productId,[int step =1]){
    state = [
      for(final e in state)
        if(e.productId == productId)
          if(e.qty - step<=0) ...[] else e.copyWith(qty:e.qty-step)
        else
          e
    ];
  }

  void remove(String productId){
    state = state.where((e)=>e.productId!=productId).toList();
  }

  void clear()=>state = const[];


}


final cartProvider  = NotifierProvider<CartNotifier,List<CartItem>>(CartNotifier.new);

final cartCountProvider = Provider<int>((ref){
  final items = ref.watch(cartProvider);
  return items.fold(0,(sum,e)=>sum+e.qty);
});

final cartTotalProvider = Provider<int>((ref){
  final items = ref.watch(cartProvider);
  return items.fold(0,(sum,e)=>sum+e.price*e.qty);
});
