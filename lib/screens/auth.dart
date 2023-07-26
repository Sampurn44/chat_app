import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() {
    return AuthscreenState();
  }
}

class AuthscreenState extends State<Authscreen> {
  final _form = GlobalKey<FormState>();
  var _islogin = true;
  var enteredemail = '';
  var enteredpass = '';
  void _submit() async {
    final isvalid = _form.currentState!.validate();
    try {
      if (!isvalid) {
        return;
      }

      _form.currentState!.save();
      //print(enteredemail);
      //  print(enteredpass);
      if (_islogin) {
        // loging in user
        final usercred = await _firebase.signInWithEmailAndPassword(
            email: enteredemail, password: enteredpass);
        print(usercred);
      } else {
        final usercred = await _firebase.createUserWithEmailAndPassword(
            email: enteredemail, password: enteredpass);
        //  print(usercred);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      // if (error.code == 'invalid-email') {}
      //if (error.code == 'operation-not-allowed') {}
      //if (error.code == 'weak-password') {}
      // TODO
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication Failed!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 15, bottom: 10, left: 10, right: 10),
                width: 200,
                child: Image.asset('assests/images/finalimgae.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredemail = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Please enter a valid password of atleast 6 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredpass = value!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              foregroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                            ),
                            child: Text(_islogin ? 'Login' : 'Sign Up'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _islogin = !_islogin;
                              });
                            },
                            child: Text(_islogin
                                ? 'Create a account'
                                : 'I already have a account. Login.'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
