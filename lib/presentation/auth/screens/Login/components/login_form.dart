import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:so_ch/presentation/auth/screens/common/custom_snackbar.dart';

import '../../../../../core/padding.dart';
import '../../../../../core/strings.dart';
import '../../../bloc/authentication_bloc.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../Signup/signup_screen.dart';
import '../../common/email_field.dart';
import '../../common/password_field.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer = Debouncer();
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          debouncer.run(() {
            customSnackbar(
                message: logInFailString, title: snackbarErrorString);
          });
        } else if (state is AuthenticationAuthenticated) {
          _emailController.clear();
          _passwordController.clear();
        }
      },
      child: Form(
        child: Column(
          children: [
            EmailField(emailController: _emailController),
            const SizedBox(
              height: defaultPadding,
            ),
            PasswordField(controller: _passwordController),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final password = _passwordController.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  context.read<AuthenticationBloc>().add(
                        LogIn(email: email, password: password),
                      );
                }
              },
              child: const Text(
                "LOGIN",
              ),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              press: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
                if (result == 'SignUpSuccess') {
                  debouncer.run(() {
                    customSnackbar(message: signUpSuccessString);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
