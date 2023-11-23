import 'package:flutter/material.dart';
import 'package:highest_dimension/widgets/my_info_dialog.dart';
import 'package:provider/provider.dart';

import '../logic/validate_values.dart';
import '../model/providers/auth_app_state.dart';
import '../widgets/my_elevated_button.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Consumer<AuthAppState>(
        builder: (context, appState, _) {
          if (appState.loginState == ApplicationLoginState.loggedIn) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Already logged in.\n\n'),
                    MyElevatedButton(
                        title: 'Log Out',
                        onPressed: () {
                          context.read<AuthAppState>().signOut((message) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return MyInfoDialog(title: 'Error', child: Text(message));
                              },
                            );
                          });
                        })
                  ],
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(height: 140, padding: const EdgeInsets.all(12), child: Image.asset('assets/images/pearl.png')),
                        const SizedBox(
                          width: 450,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                            child: LoginForm(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final ValidateValues _validateValues = ValidateValues();
  final _formKey = GlobalKey<FormState>();
  final _forgotPassFormKey = GlobalKey<FormState>();
  String? _password;
  String? _email;
  String? _forgotPassEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              onSaved: (newValue) => _email = newValue,
              validator: (value) => _validateValues.validateEmail(value),
              decoration: const InputDecoration(label: Text('E-mail')),
            ),
            const SizedBox(height: 10),
            TextFormField(
              autofillHints: const [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textCapitalization: TextCapitalization.none,
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              onSaved: (newValue) => _password = newValue,
              validator: (value) => _validateValues.validatePassword(value),
              decoration: const InputDecoration(label: Text('Password')),
            ),
            const SizedBox(height: 30),
            // MyTextFieldWidget(
            //   icon: const Icon(Icons.person),
            //   autofillHints: const [AutofillHints.email],
            //   labelText: 'E-mail',
            //   textInputType: TextInputType.emailAddress,
            //   isRequired: false,
            //   setValue: (value) => _email = value,
            //   validate: (value) => _validateValues.validateEmail(value),
            // ),
            // MyTextFieldWidget(
            //   icon: const Icon(Icons.lock),
            //   autofillHints: const [AutofillHints.password],
            //   labelText: 'Password',
            //   isRequired: false,
            //   obscureText: true,
            //   textCapitalization: TextCapitalization.none,
            //   setValue: (value) => _password = value,
            //   validate: (value) => _validateValues.validatePassword(value),
            // ),
            SizedBox(
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: forgotPasswordDialog,
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 20),
            MyElevatedButton(
              title: 'Login',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  context.read<AuthAppState>().signInWithEmailAndPassword(
                    _email!,
                    _password!,
                    () {
                      Navigator.pop(context);
                    },
                    (message) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return MyInfoDialog(
                            title: 'Error',
                            child: Text(message),
                          );
                        },
                      );
                      // showMyDialog(context, 'Login Fejl', message);
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  void forgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return MyInfoDialog(
          action: Row(
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(onPressed: sendForgotPasswordEmail, child: const Text('Send')),
            ],
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: _forgotPassFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Didn't recieve an E-mail?\nCheck your spam filter.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                    onSaved: (newValue) => _email = newValue,
                    validator: (value) => _validateValues.validateEmail(value),
                    decoration: const InputDecoration(label: Text('E-mail')),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void sendForgotPasswordEmail() {
    if (_forgotPassFormKey.currentState!.validate()) {
      _forgotPassFormKey.currentState!.save();

      context.read<AuthAppState>().resetUserPassword(
        _forgotPassEmail!.toLowerCase(),
        () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return MyInfoDialog(
                title: 'Success',
                child: Text('An E-mail has been sent to:\n$_forgotPassEmail.\n\nAfter you have reset your password, you can use it to login.'),
              );
            },
          );
        },
        (message) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return MyInfoDialog(title: 'Error', child: Text(message));
            },
          );
        },
      );
    }
  }
}
