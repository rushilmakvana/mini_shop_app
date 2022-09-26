import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/exception.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body:
          //  Stack(
          //   children: [
          //     Container(
          //       // height: 1200 ,
          //       decoration: BoxDecoration(
          //         gradient: LinearGradient(
          //           colors: [
          //             Colors.deepPurple.withOpacity(0.8),
          //             Color.fromARGB(255, 235, 225, 116).withOpacity(0.8),
          //           ],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //           stops: [0, 1],
          //         ),
          //       ),
          //     ),
          SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.withOpacity(0.8),
                Color.fromARGB(255, 235, 225, 116).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.purple.shade900,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'MyShop',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      // fontFamily: 'Anton',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: AuthCard(),
              )
            ],
          ),
          // ),
        ),
        // ],
      ),
    );
    // return Container(
    //   height: deviceSize.height,
    //   width: deviceSize.width,

    // );
  }
}

class AuthCard extends StatefulWidget {
  @override
  AuthCardState createState() {
    return AuthCardState();
  }
}

class AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final Map<String, String> _authdata = {
    'email': '',
    'pass': '',
  };
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode mode = AuthMode.login;
  var isloading = false;
  AnimationController? _controller;
  Animation<Offset>? _slideTr;
  Animation<double>? _opacity;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideTr = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );
    // _heightanimation!.addListener(
    //   () {
    //     setState(
    //       () {},
    //     );
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<void> showErr(String err) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Oops!'),
        content: Text(err),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    print('called');
    setState(() {
      isloading = true;
    });
    if (!_formKey.currentState!.validate()) {
      print('here');
      return;
    }
    _formKey.currentState!.save();
    print('passed');
    try {
      if (mode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authdata['email'] as String, _authdata['pass'] as String);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authdata['email'] as String, _authdata['pass'] as String);
      }
    } on httpException catch (err) {
      var msg = 'Authentication failed';
      if (err.toString().contains('EMAIL_EXIST')) {
        msg = 'Email already exist';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        msg = 'Invalid email';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        msg = 'password is weak';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        msg = 'could not find user';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        msg = 'Invalid password';
      }
      showErr(msg);
    } catch (err) {
      const msg = 'Could not authenticate. try again after some time';
      showErr(msg);
    }
    setState(() {
      isloading = false;
    });
  }

  void switchMode() {
    if (mode == AuthMode.login) {
      setState(() {
        mode = AuthMode.signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        mode = AuthMode.login;
      });
      _controller!.reverse();
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      // child: Container(
      //   // animation: _heightanimation!,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
        height: mode == AuthMode.signup ? 320 : 260,
        // height: _heightanimation!.value.height,
        constraints:
            BoxConstraints(minHeight: mode == AuthMode.signup ? 320 : 260),
        width: size.width * 0.80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    print(value);
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Enter valid Email';
                    }
                  },
                  onSaved: ((newValue) {
                    _authdata['email'] = newValue as String;
                  }),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  // keyboardType: TextInputType.,
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    print(value);
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be 6 characters long';
                    }
                  },
                  onSaved: (value) {
                    _authdata['pass'] = value as String;
                  },
                  // obscuringCharacter: ,
                ),
                // if (mode == AuthMode.signup)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  constraints: BoxConstraints(
                    minHeight: mode == AuthMode.signup ? 60 : 0,
                    maxHeight: mode == AuthMode.signup ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacity!,
                    child: SlideTransition(
                      position: _slideTr!,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        enabled: mode == AuthMode.signup,
                        validator: mode == AuthMode.signup
                            ? (value) {
                                if (value != passwordController.text ||
                                    value!.isEmpty) {
                                  return 'password did not matched';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isloading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    onPressed: _submit,
                    child: mode == AuthMode.login
                        ? Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            'Signup',
                            style: TextStyle(color: Colors.white),
                          ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    color: Theme.of(context).primaryColor,
                  ),
                TextButton(
                  onPressed: switchMode,
                  child: mode == AuthMode.login
                      ? Text('SignUp instead')
                      : Text('Login instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
