import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/border_radius.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/strings.dart';
import '../../../../auth/bloc/authentication_bloc.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      // width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(10.0),
      color: kPrimaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            chatAppBarTitle,
            style: TextStyle(fontSize: 18, color: kPrimaryLightColor),
          ),
          // IconButton(
          //   onPressed: () {

          //   },
          //   icon: const Icon(Icons.more_vert, color: Colors.grey),
          // ),
          PopupMenuButton(
            color: const Color(0xFFD9D9D9),
            // iconSize: 40,
            iconColor: threeDotsColor,
            onSelected: (value) {
              if (value == 0) {
                context.read<AuthenticationBloc>().add(LogOut());
              }
            },
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            padding: EdgeInsetsDirectional.zero,
            itemBuilder: (context) => [
              const PopupMenuItem(
                padding: EdgeInsets.zero,
                value: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Logout",
                        // style: dropDownListButtonTS,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}