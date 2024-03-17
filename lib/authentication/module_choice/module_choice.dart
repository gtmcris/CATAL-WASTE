import 'package:flutter/material.dart';
import 'package:login/authentication/signIn/org_login.dart';
import 'package:login/authentication/signIn/user_login.dart';
import 'package:login/organisation/main_org.dart';
import 'package:login/user/user_main.dart';
import 'package:login/user/user_schedule/user_schedule.dart';

class ModuleChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'YourFontFamily'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          displayLarge: TextStyle(
              fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold),
          // Add more text styles as needed
        ),
        // Other theme configurations
      ),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 21, 24, 29),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title: Text(
                "Catalyzing Change",
                style: TextStyle(
                    color: Colors.white, fontSize: 35, fontFamily: 'Noir'),
              ),
              backgroundColor: Color.fromARGB(255, 21, 24, 29),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Profile Selection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                HoverContainer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 140,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/mod_choice/team.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "User Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 251, 255, 214),
                  ),
                ),
                HoverContainer(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrgLoginScreen()),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      //color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/mod_choice/corporation.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "Organization Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 251, 255, 214),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String imageName;

  DetailPage(this.imageName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageName),
      ),
      body: Center(
        child: Text(
          'This is the detail page for $imageName',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class HoverContainer extends StatefulWidget {
  final Widget child;
  final Function() onTap;

  HoverContainer({required this.child, required this.onTap});

  @override
  _HoverContainerState createState() => _HoverContainerState();
}

class _HoverContainerState extends State<HoverContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(150),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
