import 'dart:io';

import 'package:cake_lab/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File? _avaterFile; //本機選擇/拍攝的檔案


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key,required this.profile});
  final UserProfile profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late String _avatarUrl;
  bool _saving = false;

  @override
  void initState(){
    super.initState();
    _nameCtrl = TextEditingController(text:widget.profile.name);
    _emailCtrl = TextEditingController(text:widget.profile.email);
    _phoneCtrl = TextEditingController(text:widget.profile.phone);
    _avatarUrl = widget.profile.avatarUrl;
  }

  Future<void> _changeAvatar()async{
    final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (_)=>SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title:const Text('拍照'),
                  onTap: ()=>Navigator.pop(context,ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title:const Text('從相簿選擇'),
                  onTap: ()=>Navigator.pop(context,ImageSource.gallery),
                )
              ],
            )
        )
    );

    if(source==null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
        preferredCameraDevice:CameraDevice.rear
    );

    if(picked==null) return;

    setState(() {
      _avaterFile = File(picked.path);
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:const Text('編輯資料',style:TextStyle(color:Color(0xFF333333),fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:SafeArea(
          child:ListView(
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
                          border:Border.all(color:Color(0xFFE7E7E7),width: 2),
                          image: DecorationImage(
                              image: _avaterFile!=null
                                  ?FileImage(_avaterFile!)
                                  :NetworkImage(_avatarUrl) as ImageProvider,
                              fit:BoxFit.cover
                          )
                      ),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap:_changeAvatar,
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
                                decoration: const InputDecoration(border:InputBorder.none,isDense: true),
                              )
                          ),
                          _LabeledField(
                              label: '信箱',
                              child: TextFormField(
                                controller: _emailCtrl,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(border:InputBorder.none,isDense: true),
                              )
                          ),
                          _LabeledField(
                              label: '電話',
                              child: TextFormField(
                                controller: _phoneCtrl,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(border:InputBorder.none,isDense: true),
                              )
                          )
                        ],
                      )
                  )
              ),
              
              const SizedBox(height: 16,),
              
              SizedBox(
                height: 48,
                child: ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                    ),
                  child: _saving
                      ?const SizedBox(
                    width: 20,height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2,valueColor: AlwaysStoppedAnimation(Colors.white)),
                  ):const Text('確定')
                ),
              )
            ],
          )
      )

    );
  }
}


class _Card extends StatelessWidget {
  const _Card({
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const[BoxShadow(color: Color(0x26000000),blurRadius: 4,offset: Offset(0, 0))],
      ),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),child: child,),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,required this.child,this.isFirst = false
  });

  final String label;
  final Widget child;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        border:Border(top:BorderSide(color:isFirst?Colors.transparent:Color(0xFFF7E7E7),width: 1)),
      ),
      child: Row(
        children: [
          Text(label,style: const TextStyle(color: Color(0xFF333333),fontSize: 14,height: 1.5)),
          const Spacer(),
          Flexible(child: child,)
        ]
      ),
    );
  }
}


