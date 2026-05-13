// import 'dart:io';

// import 'package:cake_lab/models/user_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// File? _avaterFile; //本機選擇/拍攝的檔案


// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key,required this.profile});
//   final UserProfile profile;

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   late final TextEditingController _nameCtrl;
//   late final TextEditingController _emailCtrl;
//   late final TextEditingController _phoneCtrl;
//   late String _avatarUrl;
//   bool _saving = false;

//   @override
//   void initState(){
//     super.initState();
//     _nameCtrl = TextEditingController(text:widget.profile.name);
//     _emailCtrl = TextEditingController(text:widget.profile.email);
//     _phoneCtrl = TextEditingController(text:widget.profile.phone);
//     _avatarUrl = widget.profile.avatarUrl;
//   }

//   Future<void> _changeAvatar()async{
//     final source = await showModalBottomSheet<ImageSource>(
//         context: context,
//         builder: (_)=>SafeArea(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.photo_camera),
//                   title:const Text('拍照'),
//                   onTap: ()=>Navigator.pop(context,ImageSource.camera),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title:const Text('從相簿選擇'),
//                   onTap: ()=>Navigator.pop(context,ImageSource.gallery),
//                 )
//               ],
//             )
//         )
//     );

//     if(source==null) return;

//     final ImagePicker picker = ImagePicker();
//     final XFile? picked = await picker.pickImage(
//         source: source,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 90,
//         preferredCameraDevice:CameraDevice.rear
//     );

//     if(picked==null) return;

//     setState(() {
//       _avaterFile = File(picked.path);
//     });


//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title:const Text('編輯資料',style:TextStyle(color:Color(0xFF333333),fontWeight: FontWeight.w600)),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//       ),
//       body:SafeArea(
//           child:ListView(
//             padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border:Border.all(color:Color(0xFFE7E7E7),width: 2),
//                           image: DecorationImage(
//                               image: _avaterFile!=null
//                                   ?FileImage(_avaterFile!)
//                                   :NetworkImage(_avatarUrl) as ImageProvider,
//                               fit:BoxFit.cover
//                           )
//                       ),
//                     ),
//                     Positioned(
//                         right: 0,
//                         bottom: 0,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(100),
//                           onTap:_changeAvatar,
//                           child: Container(
//                             width: 22,
//                             height: 22,
//                             decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.6),
//                                 shape: BoxShape.circle
//                             ),
//                             child: const Icon(Icons.camera_alt,size:14,color:Colors.white),
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12,),

//               // 表單
//               _Card(
//                   child: Form(
//                       child: Column(
//                         children: [
//                           _LabeledField(
//                               label: '姓名',
//                               isFirst: true,
//                               child: TextFormField(
//                                 controller: _nameCtrl,
//                                 textAlign: TextAlign.right,
//                                 decoration: const InputDecoration(border:InputBorder.none,isDense: true),
//                               )
//                           ),
//                           _LabeledField(
//                               label: '信箱',
//                               child: TextFormField(
//                                 controller: _emailCtrl,
//                                 textAlign: TextAlign.right,
//                                 decoration: const InputDecoration(border:InputBorder.none,isDense: true),
//                               )
//                           ),
//                           _LabeledField(
//                               label: '電話',
//                               child: TextFormField(
//                                 controller: _phoneCtrl,
//                                 textAlign: TextAlign.right,
//                                 decoration: const InputDecoration(border:InputBorder.none,isDense: true),
//                               )
//                           )
//                         ],
//                       )
//                   )
//               ),
              
//               const SizedBox(height: 16,),
              
//               SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                     onPressed: (){}, 
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black87,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
//                     ),
//                   child: _saving
//                       ?const SizedBox(
//                     width: 20,height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2,valueColor: AlwaysStoppedAnimation(Colors.white)),
//                   ):const Text('確定')
//                 ),
//               )
//             ],
//           )
//       )

//     );
//   }
// }


// class _Card extends StatelessWidget {
//   const _Card({
//     required this.child
//   });

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color:Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: const[BoxShadow(color: Color(0x26000000),blurRadius: 4,offset: Offset(0, 0))],
//       ),
//       child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),child: child,),
//     );
//   }
// }

// class _LabeledField extends StatelessWidget {
//   const _LabeledField({
//     required this.label,required this.child,this.isFirst = false
//   });

//   final String label;
//   final Widget child;
//   final bool isFirst;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56,
//       alignment: Alignment.centerRight,
//       decoration: BoxDecoration(
//         border:Border(top:BorderSide(color:isFirst?Colors.transparent:Color(0xFFF7E7E7),width: 1)),
//       ),
//       child: Row(
//         children: [
//           Text(label,style: const TextStyle(color: Color(0xFF333333),fontSize: 14,height: 1.5)),
//           const Spacer(),
//           Flexible(child: child,)
//         ]
//       ),
//     );
//   }
// }

import 'package:cake_lab/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart'; // [必要] 驗證身分
import 'package:firebase_database/firebase_database.dart'; // [必要] 資料庫操作
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});
  final UserProfile profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  
  // 即使不能改圖，我們還是要顯示舊圖，所以保留這變數
  late String _avatarUrl; 
  
  bool _saving = false;

  // 取得 Firebase 實體
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _emailCtrl = TextEditingController(text: widget.profile.email);
    _phoneCtrl = TextEditingController(text: widget.profile.phone);
    _avatarUrl = widget.profile.avatarUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  // --- [核心修改] 只更新文字資料的函式 ---
  Future<void> _saveTextProfile() async {
    // 1. 確認當前使用者
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('錯誤：未登入')));
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      // 2. 定義資料庫路徑
      // 假設結構是: users -> {uid} -> profile
      final String uid = user.uid;
      final DatabaseReference profileRef = _db.ref().child('users').child(uid).child('profile');

      // 3. 準備要更新的資料 (Map)
      // 注意：這裡不包含 avatarUrl，因為我們沒有修改它
      final Map<String, dynamic> updateData = {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(), 
        'phone': _phoneCtrl.text.trim(),
        // 'updatedAt': ServerValue.timestamp, // 若想記錄更新時間可加這行
      };

      // 4. 送出更新
      await profileRef.update(updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('資料更新成功！')));
        Navigator.pop(context); // 成功後回上一頁
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('儲存失敗: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }
  // -------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('編輯資料', style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE7E7E7), width: 2),
                      image: DecorationImage(
                          // 因為不處理本地檔案，這裡只顯示網頁圖片
                          image: NetworkImage(_avatarUrl),
                          fit: BoxFit.cover)),
                ),
                // --- [修改] 這裡拿掉了相機按鈕的 InkWell 點擊事件，甚至可以直接隱藏相機圖示 ---
                /* Positioned(...) // 如果你想完全隱藏相機圖示，這整段 Positioned 都可以註解掉
                */
              ],
            ),
          ),
          const SizedBox(height: 12,),

          // 表單
          _Card(
              child: Form(
                  child: Column(
            children: [
              _LabeledField(
                  label: '姓名',
                  isFirst: true,
                  child: TextFormField(
                    controller: _nameCtrl,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  )),
              _LabeledField(
                  label: '信箱',
                  child: TextFormField(
                    controller: _emailCtrl,
                    textAlign: TextAlign.right,
                    // 提示：通常 Email 是登入帳號，不建議隨意讓使用者改，這裡僅供參考
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  )),
              _LabeledField(
                  label: '電話',
                  child: TextFormField(
                    controller: _phoneCtrl,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  ))
            ],
          ))),

          const SizedBox(height: 16,),

          SizedBox(
            height: 48,
            child: ElevatedButton(
                // 綁定新的儲存函式
                onPressed: _saving ? null : _saveTextProfile,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : const Text('確定')),
          )
        ],
      )),
    );
  }
}

// ... _Card 和 _LabeledField 保持原本的樣子，不需要動 ...
class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 4, offset: Offset(0, 0))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: child,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child, this.isFirst = false});
  final String label;
  final Widget child;
  final bool isFirst;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: isFirst ? Colors.transparent : const Color(0xFFF7E7E7), width: 1)),
      ),
      child: Row(children: [
        Text(label, style: const TextStyle(color: Color(0xFF333333), fontSize: 14, height: 1.5)),
        const Spacer(),
        Flexible(
          child: child,
        )
      ]),
    );
  }
}
