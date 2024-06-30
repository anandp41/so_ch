import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/strings.dart';
import '../../common/custom_snackbar.dart';

import '../../../../../common/debouncer.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/padding.dart';
import '../../../bloc/authentication_bloc.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../Login/login_screen.dart';
import '../../common/password_field.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer();
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          _emailController.clear();
          _passwordController.clear();
          Navigator.pop(context); // Go back to login page on success
        } else if (state is SignUpFailure) {
          debouncer.run(() {
            customSnackbar(
                message: signUpFailString, title: snackbarErrorString);
          });
        }
      },
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: PasswordField(controller: _passwordController),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final password = _passwordController.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  context.read<AuthenticationBloc>().add(
                        SignUp(email: email, password: password),
                      );
                }
              },
              child: const Text("SIGN UP"),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
