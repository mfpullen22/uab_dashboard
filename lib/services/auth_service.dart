import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:uab_dashboard/hub.dart";

final _firebase = FirebaseAuth.instance;

class AuthService extends StatefulWidget {
  const AuthService({super.key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  var _isLogin = true;
  final _form = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredPassword = "";
  var _reenteredPassword = "";
  var _idToken = "";
  var _firstName = "";
  var _lastName = "";
  var _credentials = "";
  var _organization = "";
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save(); // Save form state

    if (!_isLogin && _enteredPassword != _reenteredPassword) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        // Handle login flow
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        // Handle sign-up flow
        final pinSnapshot = await FirebaseFirestore.instance
            .collection("registration_codes")
            .where("reg_code", isEqualTo: _idToken)
            .limit(1)
            .get();

        if (pinSnapshot.docs.isNotEmpty) {
          // Register new user
          await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword,
          );

          await FirebaseFirestore.instance.collection("users").add({
            "first_name": _firstName,
            "last_name": _lastName,
            "credentials": _credentials,
            "organization": _organization,
            "email": _enteredEmail,
            "projects": [],
          });

          // Ensure the widget is still mounted before navigating
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HubScreen(),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid ID token."),
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? "Authentication failed."),
          ),
        );
      }
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 400,
                child: Image.asset(
                  "assets/images/msg_logo.png",
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Email Address",
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains("@")) {
                                  return "Please enter a valid email address.";
                                }
                                return null;
                              },
                              onSaved: (value) => _enteredEmail = value!,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Password",
                              ),
                              obscureText: true,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Password must be at least 6 characters.";
                                }
                                return null;
                              },
                              onSaved: (value) => _enteredPassword = value!,
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Re-enter Password",
                                ),
                                obscureText: true,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return "Re-enter your password.";
                                  }
                                  return null;
                                },
                                onSaved: (value) => _reenteredPassword = value!,
                              ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: "Unique Code",
                                ),
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter your secure code.";
                                  }
                                  return null;
                                },
                                onSaved: (value) => _idToken = value!,
                              ),
                            const SizedBox(height: 20),
                            if (!_isLogin)
                              Text(
                                "Complete your profile below",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontSize: 20.0, color: Colors.black),
                              ),
                            if (!_isLogin) const SizedBox(height: 10),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'First Name'),
                                onSaved: (value) {
                                  _firstName = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            if (!_isLogin) const SizedBox(height: 10),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Last Name'),
                                onSaved: (value) {
                                  _lastName = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                            if (!_isLogin) const SizedBox(height: 10),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText:
                                        'Credentials (MD, DO, PhD, etc.)'),
                                onSaved: (value) {
                                  _credentials = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your credentials';
                                  }
                                  return null;
                                },
                              ),
                            if (!_isLogin) const SizedBox(height: 10),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText:
                                        'Organization (University, Company)'),
                                onSaved: (value) {
                                  _organization = value!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your organization';
                                  }
                                  return null;
                                },
                              ),
                            if (!_isLogin) const SizedBox(height: 12),
                            if (_isAuthenticating)
                              const CircularProgressIndicator()
                            else
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Text(_isLogin ? "Login" : "Sign Up"),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? "Create new account"
                                      : "I already have an account",
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
