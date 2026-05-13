import 'package:cake_lab/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

import 'product_local.dart';
import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupFCM();



  // runApp(const MyApp());
  runApp(const ProviderScope(child:MyApp()));
}

Future<void> setupFCM() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //ios 需要請求通知權限

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');


  // FCM token
  //String? token = await messaging.getToken();
  //print('FCM Token:$token');

  // 監聽token變動
  FirebaseMessaging.onMessage.listen((newToken){
    print('Refresh FCM TOKEN');
    // 後端更新
  });

  // 監聽前景推播
  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print('Received a foreground message');
  });
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cake',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
    );
  }
}




class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          // 初始化
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
          // 已登入
          if(snapshot.hasData){
            return BottomNavigationController();
          }
          // 未登入
          return const LoginPage();
        }
    );
  }
}





class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({super.key});

  @override
  State<BottomNavigationController> createState() => _BottomNavigationControllerState();
}

class _BottomNavigationControllerState extends State<BottomNavigationController> {
  int _currentIndex = 0;
  final pages = [CakeHomePage(),ProfilePage()];

  void _onTap(int index){
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:pages[_currentIndex],
      bottomNavigationBar: _BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTap
      ),
    );
  }
}




class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        height: 49.0+MediaQuery.of(context).padding.bottom,
        decoration: const BoxDecoration(
            color:Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0x2600000),
                  blurRadius: 4,
                  offset: Offset(0, -1),
                  spreadRadius: 0
              )
            ]
        ),
        child: SafeArea(
            child: Row(
              children: [
                _NavItem(
                    label: '首頁',
                    isActive: currentIndex==0,
                    activeColor: Color(0xFFE7393E),
                    inactiveColor: Color(0xFF888888),
                    activeIcon: Icons.home,
                    inactiveIcon: Icons.home_outlined,
                    onTap: ()=>onTap(0)
                ),
                _NavItem(
                    label: '我的',
                    isActive: currentIndex==1,
                    activeColor: Color(0xFFE7393E),
                    inactiveColor: Color(0xFF888888),
                    activeIcon: Icons.account_circle,
                    inactiveIcon: Icons.account_circle_outlined,
                    onTap: ()=>onTap(1)
                )
              ],
            )
        ),
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
          onTap: onTap,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top:7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    isActive?activeIcon:inactiveIcon,
                    size:20,
                    color: isActive?activeColor:inactiveColor,
                  ),
                ),
                const SizedBox(height: 4,),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive?activeColor:inactiveColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
