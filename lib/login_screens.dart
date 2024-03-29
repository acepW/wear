import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wear/wear.dart';
import 'package:wears/const/firebase_const.dart';
import 'package:wears/heart_rate.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passFocusNode = FocusNode();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _submitFormOnLogin() async {
    final isValid = _formKey.currentState;
    User? user = FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();

    try {
      setState(() {
        _isLoading = true;
      });
      await authInstance.signInWithEmailAndPassword(
          email: _emailTextController.text.toLowerCase().trim(),
          password: _passTextController.text.trim());

      // ignore: use_build_context_synchronously

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HeartRate(),
      ));

      print('Successfully logged in');
    } on FirebaseException catch (error) {
      showSnackBar(context, "${error.message}");

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      showSnackBar(context, "$error");

      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        return AmbientMode(
            builder: (context, mode, child) => child!,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Masukkan email dengan benar';
                            } else {
                              return null;
                            }
                          },
                         
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.green),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.green),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Email",
                           
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            _submitFormOnLogin();
                          },
                          controller: _passTextController,
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty || value.length <= 5) {
                              return 'Masukkan password dengan benar';
                            } else {
                              return null;
                            }
                          },
                          
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.green),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.green),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Password",
                             ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            _submitFormOnLogin();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Login",
                                     
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ),
            ));
      },
    );
  }
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.purple,
      content: Text(text),
    ),
  );
}
