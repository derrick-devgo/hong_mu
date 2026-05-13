import 'package:cake_lab/edit_profile_page.dart';
import 'package:cake_lab/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/user_profile.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool _isBusy = false;

//   UserProfile _profile = const UserProfile(
//       name: 'Derrick',
//       email: 'derrick@gmail.com',
//       phone: '0912345678',
//       avatarUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQucKkYQbFe5AM86E1xAEdBMQRGUOIvVcuHmw&s'
//   );

//   Future<void> _logout() async{
//     if (_isBusy) return;
//     setState(() { _isBusy = true; }); // 1. 更新畫面轉圈圈

//     try {
//       // 2. 這是一個耗時操作，需要等待網路回應
//       await FirebaseAuth.instance.signOut();

//       // ---------------------------------------------------
//       // 在上面這行等待的時間內，使用者可能覺得太慢，
//       // 按下了「上一頁」或直接關閉了這個畫面。
//       // 如果使用者離開了，這個 ProfilePage 就被銷毀 (dispose) 了。
//       // ---------------------------------------------------

//       // 3. 網路回應回來了，程式碼繼續往下執行
//       if (mounted) Navigator.of(context).maybePop();

//     } on FirebaseAuthException catch (e) {

//       // 4. 安全檢查！
//       if (!mounted) return;

//       // 5. 如果沒有上面那行檢查，而頁面已經關閉，
//       // 這裡使用 `context` 就會導致錯誤，因為 context 已經失效了。
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? '登出失敗')),
//       );
//     }catch(_){
//       if(!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content:Text('發生未知錯誤')),
//       );
//     }finally{
//       if(mounted) setState(()=>_isBusy = false);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text(
//             '會員資料',
//           style:TextStyle(color:Color(0xFF333333),fontSize: 18,fontWeight: FontWeight.w600)
//         ),
//       ),
//       body: SafeArea(
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
//             children: [
//               _HeaderRow(
//                   name: _profile.name,
//                   avatarUrl: _profile.avatarUrl,
//                   onEdit: ()async{
//                     final updated = await Navigator.push<UserProfile>(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_)=>EditProfilePage(profile:_profile)
//                       ),
//                     );
//                     if(!mounted) return;
//                     if(updated!=null){
//                       setState(()=>_profile = updated);
//                       _toast(context, '已更新資料');
//                     }
//                   },

//               ),
//               _SectionCard(
//                   child: Column(
//                     children: [
//                       _KVCell(label: '姓名', value: _profile.name,isFirst: true,),
//                       _KVCell(label: '信箱', value: _profile.email),
//                       _KVCell(label: '電話', value: _profile.phone,valueColor: Color(0xFF838383),),
//                       // _KVCell(label: '地址', value: '台北市中正區'),
//                     ],
//                   )
//               ),
//               const SizedBox(height: 12,),

//               _SectionCard(
//                   padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Padding(
//                           padding: EdgeInsets.only(bottom: 6),
//                           child: Text(
//                               '其他',
//                               style:TextStyle(
//                                 color:Color(0xFF333333),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700
//                               )
//                           ),
//                       ),
//                       _ActionCell(
//                         text:'訂單紀錄',
//                         onTap: (){
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_)=>const OrderHistoryPage())
//                           );
//                         },
//                       )
//                     ],
//                   ),
//               ),

//               const SizedBox(height: 20,),

//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                     onPressed: _isBusy?null:_logout,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
//                     ),
//                     child: _isBusy?const SizedBox(
//                       width: 20,height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation(Colors.white),
//                       ),
//                     ):const Text('登出',style: TextStyle(fontSize: 16),)
//                 ),
//               )
//             ],
//           )
//       ),
//     );
//   }
// }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isBusy = false;
  
  // [新增] 取得當前使用者與定義資料流
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late final Stream<DatabaseEvent> _profileStream;

  @override
  void initState() {
    super.initState();
    // [新增] 初始化監聽器
    if (currentUser != null) {
      _profileStream = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(currentUser!.uid)
          .child('profile')
          .onValue; // onValue 代表持續監聽
    }
  }

  Future<void> _logout() async {
    if (_isBusy) return;
    setState(() { _isBusy = true; });

    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) Navigator.of(context).maybePop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '登出失敗')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('發生未知錯誤')),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 安全檢查：如果沒登入，顯示空白或錯誤
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("未登入使用者")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
            '會員資料',
            style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.w600)
        ),
      ),
      // [核心修改] 使用 StreamBuilder 包裹整個頁面內容
      body: StreamBuilder<DatabaseEvent>(
        stream: _profileStream,
        builder: (context, snapshot) {
          // 1. 處理連線狀態
          if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. 解析 Firebase 資料
          // 如果資料庫是空的 (新帳號)，給預設值
          final data = snapshot.data?.snapshot.value as Map?;
          
          final userProfile = UserProfile(
            name: data?['name'] ?? '請設定姓名',
            email: data?['email'] ?? currentUser?.email ?? '無信箱',
            phone: data?['phone'] ?? '請設定電話',
            // 如果沒有大頭貼，給一張預設圖
            avatarUrl: data?['avatarUrl'] ?? 'https://hips.hearstapps.com/hmg-prod/images/fotojet-8-649c17cba07fe.jpg?crop=0.493xw:0.987xh;0,0&resize=640:*',
          );

          // 3. 顯示 UI (原本的 ListView 移到這裡)
          return SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                children: [
                  _HeaderRow(
                    name: userProfile.name,
                    avatarUrl: userProfile.avatarUrl,
                    onEdit: () {
                      // [修改] 這裡簡化了！不用 await 也不用 setState
                      // 因為下一頁存檔後，Firebase 會通知上面的 StreamBuilder 自動重繪
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditProfilePage(profile: userProfile)
                        ),
                      );
                    },
                  ),
                  _SectionCard(
                      child: Column(
                        children: [
                          _KVCell(label: '姓名', value: userProfile.name, isFirst: true,),
                          _KVCell(label: '信箱', value: userProfile.email),
                          _KVCell(label: '電話', value: userProfile.phone, valueColor: const Color(0xFF838383),),
                        ],
                      )
                  ),
                  const SizedBox(height: 12,),

                  _SectionCard(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                              '其他',
                              style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ),
                        _ActionCell(
                          text: '訂單紀錄',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const OrderHistoryPage())
                            );
                          },
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                        onPressed: _isBusy ? null : _logout,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        child: _isBusy ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ) : const Text('登出', style: TextStyle(fontSize: 16),)
                    ),
                  )
                ],
              )
          );
        },
      ),
    );
  }
}




void _toast(BuildContext ctx,String msg){
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(behavior: SnackBarBehavior.floating,content:Center(child: Text(msg),))
  );
}


class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.name,
    required this.avatarUrl,
    required this.onEdit,

  });

  final String name;
  final String avatarUrl;
  final VoidCallback onEdit;



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:Color(0xFFE7E7E7)),
                image:DecorationImage(image: NetworkImage(avatarUrl),fit:BoxFit.cover)
            ),
          ),
          const SizedBox(width: 16,),
          Expanded(
              child: Row(
                children: [
                  Text(
                      name,
                    style:const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5
                    )
                  ),
                  const Spacer(),
                  TextButton.icon(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(0,24),
                      ),
                      icon:const Icon(Icons.edit_outlined,size: 18,),
                      label:const Text('編輯',style:TextStyle(fontSize: 14,height: 1.25))
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}


class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding
  });

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color:Color(0x26000000),blurRadius: 4,offset: Offset(0,0))],
      ),
      child: Padding(
          padding: padding?? const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        child: child,
      ),
    );
  }
}

class _KVCell extends StatelessWidget {
  const _KVCell({
    required this.label,
    required this.value,
    this.isFirst = false,
    this.valueColor = const Color(0xFF333333),
  });

  final String label;
  final String value;
  final bool isFirst;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        border:Border(
          top:BorderSide(color:isFirst?Colors.transparent:Color(0xFFE7E7E7),width: 1),
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              height: 1.5
            )
          ),
          const Spacer(),
          Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color:valueColor,
                  fontSize: 14,
                  height: 1.5
                ),
              )
          )
        ],
      ),
    );
  }
}

class _ActionCell extends StatelessWidget {
  const _ActionCell({
    required this.text,
    this.onTap,
    this.showChevron = true,
    this.textColor = const Color(0xFF333333),
    this.hasTopBorder = false,

  });

  final String text;
  final VoidCallback? onTap;
  final bool showChevron;
  final Color textColor;
  final bool hasTopBorder;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Expanded(
            child: Text(
                text,
                style:TextStyle(
                  color:textColor,
                  fontSize: 14,
                  height: 1.5
                )
            )
        ),
        if(showChevron) const Icon(Icons.chevron_right,color:Color(0xFF333333))
      ],
    );

    final inner = Container(
      height: 56,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border:Border(top:BorderSide(color:hasTopBorder?Color(0xFFE7E7E7):Colors.transparent)),
      ),
      child: row,
    );

    if(onTap==null) return inner;
    return InkWell(onTap: onTap,child: inner);
  }
}




