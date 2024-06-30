import 'package:flutter/material.dart';
import '../../../../common/responsive.dart';
import '../../components/background.dart';
import 'components/login_signup_btn.dart';
import 'components/welcome_image.dart';
part './components/mobile_welcome_screen.dart';
part './components/desktop_welcome_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Responsive(
            desktop: DesktopWelcomeScreen(),
            mobile: MobileWelcomeScreen(),
          ),
        ),
      ),
    );
  }
}
