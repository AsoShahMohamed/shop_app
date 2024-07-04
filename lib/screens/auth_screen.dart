import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'dart:math';
import '../providers/authentication.dart';
import 'package:provider/provider.dart';

enum AuthMode { login, signup }

class AuthenticationScreen extends StatelessWidget {
  static const route = '/authenticate';

  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              appTheme.colorScheme.primary.withOpacity(0.55),
              appTheme.colorScheme.tertiary.withOpacity(0.75)
            ], stops: const [
              0,
              1
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: SingleChildScrollView(
              child: Container(
                width: mediaSize.width,
                height: mediaSize.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                        child: Text(
                          'MyShop',
                          style: TextStyle(
                              color: appTheme.colorScheme.onSurface,
                              fontSize: 35,
                              fontFamily: 'Anton',
                              fontStyle: FontStyle.italic),
                        ),
                        transform: Matrix4.rotationZ(-pi / 12)
                          ..setTranslationRaw(-10, 0, 0),
                        margin: EdgeInsets.only(bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 75, vertical: 25),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(66, 180, 140, 140),
                                  blurRadius: 10,
                                  offset: Offset(0, 10)),
                            ],
                            color: appTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(25)),
                      )),
                      Flexible(
                          child: AuthCard(mediaSize, appTheme),
                          flex: mediaSize.width > 600 ? 2 : 1)
                    ]),
              ),
            ))
      ],
    ));
  }
}

class AuthCard extends StatefulWidget {
  final Size mediaSize;
  final ThemeData appTheme;
  const AuthCard(this.mediaSize, this.appTheme);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final RegExp emailFilter = RegExp(
      r'(^[a-zA-Z0-9_-]+)(\.[a-zA-Z0-9]+){1,2}@([a-zA-Z0-9_-]+)\.(com||net)$');
  final FocusNode emailNode = FocusNode();

  final FocusNode passNode = FocusNode();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool _isLoading = false;
  Map<String, String> credentials = {'email': '', 'pass': ''};
  Animation<Size>? _animation;
  Animation<double>? _opacityAnimation;
  AnimationController? _aController;
  Animation<Offset>? _aOffset;
  AuthMode authMode = AuthMode.login;

  @override
  void initState() {
    _aController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    _animation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(
            parent: _aController as Animation<double>, curve: Curves.linear));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Curves.linear, parent: _aController as Animation<double>));
    // _animation!.addListener(() {
    //   setState(() {});
    // });
    //impelment the use of animatedBuilder to supplant this method

    _aOffset = Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0, 0)).animate(
        CurvedAnimation(
            curve: Curves.easeInOut,
            parent: _aController as Animation<double>));
    super.initState();
  }

  void switchAuthMode() {
    if (authMode == AuthMode.login) {
      setState(() {
        authMode = AuthMode.signup;
      });
      _aController!.forward();
    } else if (authMode == AuthMode.signup) {
      setState(() {
        authMode = AuthMode.login;
      });
      _aController!.reverse();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (cntx) {
          return AlertDialog(
              title: Text('something went wrong..'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'close',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  Future<void> _submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState?.save();

    setState(() {
      _isLoading = !_isLoading;
    });

    try {
      if (authMode == AuthMode.login) {
        await Provider.of<Authentication>(context, listen: false).logIn(
            credentials['email'] as String, credentials['pass'] as String);
      } else {
        await Provider.of<Authentication>(context, listen: false).signUp(
            credentials['email'] as String, credentials['pass'] as String);
      }
    } on HttpException catch (e) {
      var text = 'unknown cause';
      if (e.toString().contains('EMAIL_EXISTS')) {
        text = 'The email address is already in use by another account';
      }

      if (e.toString().contains('INVALID_LOGIN_CREDENTIALS')) {
        text = 'The password is invalid or the user does not have a password';
      }

      _showErrorDialog(text);
    } catch (e) {
      _showErrorDialog('please try again later..');
    }

    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void dispose() {
    passNode.dispose();
    emailNode.dispose();
    passwordController.dispose();
    _aController?.dispose();

// _animation.remove
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusScopeNode = FocusScope.of(context);
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        // child: AnimatedBuilder(
        //   animation: _animation as Listenable,
        //   builder: (context, ch) {
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
          constraints: BoxConstraints(
              minHeight: authMode == AuthMode.signup ? 320 : 260),
          // minHeight: _animation?.value. ?? 260,

          padding: EdgeInsets.all(10),
          width: widget.mediaSize.width * 0.75,
          height: authMode == AuthMode.signup ? _animation?.value.height : 260,
          // height: _animation?.value.height,
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                  child: FocusScope(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val) {
                        if (!emailFilter.hasMatch(val!)) {
                          return 'email doesnt match pattern';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        credentials['email'] = val!;
                      },
                      decoration: InputDecoration(
                          labelText: 'Email',
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.appTheme.colorScheme.primary))),
                      keyboardType: TextInputType.emailAddress,
                      focusNode: emailNode,
                      onFieldSubmitted: (val) {
                        focusScopeNode.requestFocus(passNode);
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.appTheme.colorScheme.primary)),
                        labelText: 'Password',
                      ),
                      focusNode: passNode,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 5) {
                          return 'password must be provided!';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        credentials['pass'] = val!;
                      },
                    ),
                    // if (authMode == AuthMode.signup)
                    AnimatedContainer(
                      constraints: BoxConstraints(
                          minHeight: authMode == AuthMode.login ? 0 : 60,
                          maxHeight: authMode == AuthMode.login ? 0 : 120),
                      duration: Duration(milliseconds: 400),
                      child: FadeTransition(
                        opacity: _opacityAnimation as Animation<double>,
                        child: SlideTransition(
                          position: _aOffset as Animation<Offset>,
                          child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: widget
                                              .appTheme.colorScheme.primary)),
                                  labelText: 'confirm Password'),
                              validator: (val) {
                                if (authMode == AuthMode.signup) {
                                  if (val! != passwordController.text) {
                                    return 'passwords do not match!';
                                  }
                                }
                                return null;
                              }),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading) CircularProgressIndicator(),
                    if (!_isLoading)
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              foregroundColor:
                                  widget.appTheme.colorScheme.onPrimary),
                          onPressed: _submitForm,
                          child: Text(
                              '${authMode == AuthMode.login ? 'Login' : 'Signup'}')),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        style: ElevatedButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        onPressed: switchAuthMode,
                        child: Text(
                            'shift to ${authMode == AuthMode.login ? 'signup' : 'login'}'))
                  ],
                ),
              ))),
        ));
  }
}
