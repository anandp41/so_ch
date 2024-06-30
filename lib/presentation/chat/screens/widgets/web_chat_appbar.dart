import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/web_socket_bloc.dart';

import '../../../../core/border_radius.dart';
import '../../../../core/colors.dart';
import '../../../auth/bloc/authentication_bloc.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.077,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: kPrimaryColor,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.read<WebSocketBloc>().loggedInEmail,
            style: const TextStyle(fontSize: 18, color: kPrimaryLightColor),
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
