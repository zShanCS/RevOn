import 'package:flutter/material.dart';
import 'package:revon/BookListScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController =
      TextEditingController(text: 'zshanahmad@gmail.com');
  TextEditingController _passwordController =
      TextEditingController(text: 'Zshan&Zshan1');

  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool signUpFirstTime = false;
  togglePasswordVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  toggleSignUp() {
    setState(() {
      signUpFirstTime = !signUpFirstTime;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RevOn | Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.mail)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter some text';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Incorrect Email Format';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        togglePasswordVisible();
                      },
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter some text';
                  } else if (value.length < 8) {
                    return 'Password cant be less than 8 characters';
                  } else if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(value)) {
                    return 'Passwords needs to be alphanumeric, contain a special character and an uppercase ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        signUpFirstTime = !signUpFirstTime;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: signUpFirstTime,
                          onChanged: (value) {
                            setState(() {
                              signUpFirstTime = !signUpFirstTime;
                            });
                          },
                        ),
                        const Text('Sign Up. (Its my first time on app)'),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
// Register a new user with email and password
                    if (signUpFirstTime) {
                      // sign up the user and move to next screen
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (userCredential.user != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);
                        await prefs.setString('user', _emailController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookListScreen()),
                        );
                      } else {
                        //failed to sign up
                        showSnackBar(context, 'Failed to Sign Up');
                      }
                    } else {
                      //try to login
                      UserCredential userCreds = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                      if (userCreds.user != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', true);
                        await prefs.setString('user', _emailController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookListScreen()),
                        );
                      } else {
                        showSnackBar(context,
                            'Failed to login. Check email and password. Or Sign Up.');
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error Occurred')),
                    );
                  }
                },
                child: Text(signUpFirstTime ? 'Sign Up' : 'Log In'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color.fromARGB(20, 0, 0, 0),
      content: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: Duration(seconds: 2), // set the duration for the message
    ),
  );
}
