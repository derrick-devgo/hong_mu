import 'package:flutter/material.dart';

import '../demo_block.dart';
import '../vstack.dart';

class ImageDemo extends StatelessWidget {
  const ImageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Widget 教學範例')),
      body: VStack(
        children: [
          // 1. 本地資產圖片
          DemoBlock(
            number: 1,
            title: 'Assets Image（本地資產）',
            children: [
              Text('用 Image.asset 載入，常見會搭配 fit 來控制裁切。', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              // 用 SizedBox 限制高度，讓圖片不會撐爆畫面
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/room.png',
                  fit: BoxFit.cover, // 填滿並裁切
                  // fit: BoxFit.contain, // 完整顯示並留白
                  // fit: BoxFit.fill, // 拉伸填滿（可能變形）
                  // fit: BoxFit.none, // 原尺寸顯示（可能留白或被裁切）
                ),
              ),
            ],
          ),

          // 2. 網路圖片
          DemoBlock(
            number: 2,
            title: 'Network Image（網路圖片）',
            children: [
              Text('loadingBuilder / errorBuilder 能顯示載入進度與錯誤。', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  'https://www.niusnews.com/upload/imgs/default/202407_Noah/0719/wc/whitecharacter_8.jpg',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    final value = progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes!)
                        : null;
                    return Center(
                      child: CircularProgressIndicator(value: value),
                    );
                  },
                  errorBuilder: (context, error, stack) => const Center(child: Text('載入圖片失敗')),
                ),
              ),
            ],
          ),

          // 3. 大小與裁切模式（fit）
          DemoBlock(
            number: 3,
            title: '大小與裁切（fit）',
            children: [
              Text('BoxFit.cover 會裁切填滿；BoxFit.contain 會完整顯示但留白。', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/room.png',
                  fit: BoxFit.cover, // 填滿並裁切
                ),
              ),
            ],
          ),

          DemoBlock(
            number: 4,
            title: 'BoxFit.contain 範例',
            children: [
              Text('BoxFit.contain 會完整顯示但留白。', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/room.png',
                  fit: BoxFit.contain, // 完整顯示並留白
                ),
              ),
            ],
          ),
          DemoBlock(
            number: 5,
            title: 'BoxFit.fill  範例',
            children: [
              Text('BoxFit.fill 會拉伸填滿（可能變形）。', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/room.png',
                  fit: BoxFit.fill, // 拉伸填滿（可能變形）
                ),
              ),
            ],
          ),
          DemoBlock(
            number: 6,
            title: 'BoxFit.none  範例',
            children: [
              Text('BoxFit.none 會以原尺寸顯示（可能留白或被裁切）。', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/room.png',
                  fit: BoxFit.none, // 原尺寸顯示（可能留白或被裁切）
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}