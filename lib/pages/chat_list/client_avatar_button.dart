import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'chat_list.dart';

class ClientAvatarButton extends StatelessWidget {
  final ChatListController controller;

  const ClientAvatarButton(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    var clientCount = 0;
    matrix.accountBundles.forEach((key, value) => clientCount += value.length);
    return FutureBuilder<Profile>(
      future: matrix.client.fetchOwnProfile(),
      builder: (context, snapshot) => MaterialButton(
        onPressed: () { context.go('/rooms/settings'); },
        clipBehavior: Clip.antiAlias,
        child: Avatar(
          mxContent: snapshot.data?.avatarUrl,
          name: snapshot.data?.displayName ??
              matrix.client.userID!.localpart,
          size: 32,
        ),
      ),
    );
  }
}
