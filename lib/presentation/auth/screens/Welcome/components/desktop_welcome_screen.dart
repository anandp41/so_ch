part of '../welcome_screen.dart';

class DesktopWelcomeScreen extends StatelessWidget {
  const DesktopWelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: WelcomeImage(),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 450,
                child: LoginAndSignupBtn(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
