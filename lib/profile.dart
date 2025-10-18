import 'package:cake_lab/edit_profile_page.dart';
import 'package:cake_lab/order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isBusy = false;

  UserProfile _profile = const UserProfile(
      name: 'Derrick',
      email: 'derrick@gmail.com',
      phone: '0912345678',
      avatarUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQucKkYQbFe5AM86E1xAEdBMQRGUOIvVcuHmw&s'
  );

  Future<void> _logout() async{
    if(_isBusy) return;
    setState(() {
      _isBusy = true;
    });

    try{
      await FirebaseAuth.instance.signOut();
      if(mounted) Navigator.of(context).maybePop();
    }on FirebaseAuthException catch (e){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(e.message??'登出失敗')),
      );
    }catch(_){
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text('發生未知錯誤')),
      );
    }finally{
      if(mounted) setState(()=>_isBusy = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
            '會員資料',
          style:TextStyle(color:Color(0xFF333333),fontSize: 18,fontWeight: FontWeight.w600)
        ),
      ),
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            children: [
              _HeaderRow(
                  name: _profile.name,
                  avatarUrl: _profile.avatarUrl,
                  onEdit: ()async{
                    final updated = await Navigator.push<UserProfile>(
                      context,
                      MaterialPageRoute(
                          builder: (_)=>EditProfilePage(profile:_profile)
                      ),
                    );
                    if(!mounted) return;
                    if(updated!=null){
                      setState(()=>_profile = updated);
                      _toast(context, '已更新資料');
                    }
                  },
                  onChangeAvatar: ()=>_toast(context,'更換頭像')
              ),
              _SectionCard(
                  child: Column(
                    children: [
                      _KVCell(label: '姓名', value: _profile.name,isFirst: true,),
                      _KVCell(label: '信箱', value: _profile.email),
                      _KVCell(label: '電話', value: _profile.phone,valueColor: Color(0xFF838383),),
                      // _KVCell(label: '地址', value: '台北市中正區'),
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
                              style:TextStyle(
                                color:Color(0xFF333333),
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              )
                          ),
                      ),
                      _ActionCell(
                        text:'訂單紀錄',
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_)=>const OrderHistoryPage())
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
                    onPressed: _isBusy?null:_logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                    child: _isBusy?const SizedBox(
                      width: 20,height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ):const Text('登出',style: TextStyle(fontSize: 16),)
                ),
              )
            ],
          )
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
    required this.onChangeAvatar,
  });

  final String name;
  final String avatarUrl;
  final VoidCallback onEdit;
  final VoidCallback onChangeAvatar;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Row(
        children: [
          Stack(
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
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: (){
                      print('hello world!');
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.camera_alt,size:14,color:Colors.white),
                    ),
                  )
              )
            ],
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




