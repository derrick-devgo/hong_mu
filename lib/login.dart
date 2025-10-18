import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscureText = true;

  bool _isbusy = false;


  @override
  void dipose(){
    _accountController.dispose();
    _passwordController.dispose();
  }

  void _showSnack(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _singIn() async{

    final email = _accountController.text.trim();
    final pwd = _passwordController.text;


    if(email.isEmpty){
      _showSnack('請輸入Email');
      return;
    }

    if(pwd.length<6){
      _showSnack('密碼至少6碼');
      return;
    }

    setState(()=>_isbusy=true);

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pwd,
      );

    }on FirebaseAuthException catch(e){
      String msg;
      _showSnack(e.message.toString());

    }


  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width*0.9;


    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  // 標題
                  Text(
                      '紅木蛋糕',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  SizedBox(height: 8,),
                  // 副標題
                  Text(
                      'Hong Mu',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 60,),
                  // 帳號
                  SizedBox(
                    width: width,
                    child: TextFormField(
                      controller: _accountController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: '帳號',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  // 密碼
                  SizedBox(
                    width: width,
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          labelText: '密碼',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                        contentPadding:  const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                _obscureText = !_obscureText;
                              });

                            },
                            icon: Icon(_obscureText? Icons.visibility:Icons.visibility_off)
                        )
                      ),
                    ),

                  ),
                  SizedBox(height: 12,),
                  // 記住我、忘記密碼
                  SizedBox(
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: _rememberMe,
                                activeColor: Colors.red,
                                onChanged: (v){
                                  setState(() {
                                    _rememberMe = v??false;
                                  });
                                }
                            ),
                            Text('記住我'),
                          ],
                        ),
                        TextButton(
                            onPressed: (){},
                            child: const Text(
                              '忘記密碼',
                              style:TextStyle(color:Colors.red)
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24,),
                  SizedBox(
                    width: width,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                        onPressed: _isbusy?null:_singIn,
                        child: const Text(
                          '登入',
                          style: TextStyle(fontSize: 16,color:Colors.white),
                        )
                    ),
                  )

                ],
              ),
            )
          )
      )
    );
  }
}
