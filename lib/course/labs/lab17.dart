import 'package:flutter/material.dart';


class GridBuilderDemo extends StatelessWidget {
  const GridBuilderDemo({super.key});


  @override
  Widget build(BuildContext context) {
    // 建立長度 5 的 List<int>，內容為 0,1,2,3,4
    final numbers = List<int>.generate(5, (i) => i);
    // generate是List類別的工廠建構子，可以用來快速產生一個 List。它接受兩個參數：第一個是要產生的 List 長度，第二個是一個函數，這個函數會被呼叫多次，每次傳入當前索引 i，並返回對應的值。在這裡，我們產生了一個長度為 5 的 List<int>，內容是從 0 到 4 的整數。
    print(numbers);

    // 範例資料：20 張示意圖片 URL
    final imageUrls = List<String>.generate(
      20,
      (i) => 'https://picsum.photos/seed/${i + 1}/300/300',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('GridView.builder Demo')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: imageUrls.length,// itemCount 是 GridView.builder 的參數，用來指定網格中項目的總數。在這裡，我們將它設置為 imageUrls 的長度，這樣 GridView 就知道要顯示多少個項目。
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(// gridDelegate 是 GridView.builder 的參數，用來定義網格的佈局方式。SliverGridDelegateWithFixedCrossAxisCount 是其中一種實現，它允許我們指定每行（或每列）的項目數量。在這裡，我們設置 crossAxisCount 為 3，表示每行有 3 個項目，並且設定了項目之間的間距和寬高比。
            crossAxisCount: 3,// crossAxisCount 是 SliverGridDelegateWithFixedCrossAxisCount 的參數，用來指定每行（或每列）的項目數量。在這裡，我們設置 crossAxisCount 為 3，表示每行有 3 個項目。
            crossAxisSpacing: 0, // crossAxisSpacing 是 SliverGridDelegateWithFixedCrossAxisCount 的參數，用來指定項目之間的水平間距。在這裡，我們設置 crossAxisSpacing 為 8，表示每個項目之間有 8 像素的水平間距。
            mainAxisSpacing: 0,// mainAxisSpacing 是 SliverGridDelegateWithFixedCrossAxisCount 的參數，用來指定項目之間的垂直間距。在這裡，我們設置 mainAxisSpacing 為 8，表示每個項目之間有 8 像素的垂直間距。
            childAspectRatio: 0.8,// childAspectRatio 是 SliverGridDelegateWithFixedCrossAxisCount 的參數，用來指定每個項目的寬高比。在這裡，我們設置 childAspectRatio 為 1，表示每個項目是正方形。
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              // ClipRRect 是一個 Widget，用來對其子 Widget 進行圓角裁剪。在這裡，我們使用 ClipRRect 來將每個網格項目的圖片裁剪成圓角矩形，並且設定 borderRadius 為 BorderRadius.circular(12)，表示圓角的半徑為 12 像素。
              borderRadius: BorderRadius.circular(0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}