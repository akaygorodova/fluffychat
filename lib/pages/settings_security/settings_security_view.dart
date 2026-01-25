import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'settings_security.dart';

class SettingsSecurityView extends StatelessWidget {
  final SettingsSecurityController controller;

  const SettingsSecurityView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).security),
        automaticallyImplyLeading: !FluffyThemes.isColumnMode(context),
        centerTitle: FluffyThemes.isColumnMode(context),
      ),
      body: ListTileTheme(
        iconColor: theme.colorScheme.onSurface,
        child: MaxWidthBody(
          child: FutureBuilder(
            future: Matrix.of(context)
                .client
                .getCapabilities()
                .timeout(const Duration(seconds: 10)),
            builder: (context, snapshot) {
              final capabilities = snapshot.data;
              final error = snapshot.error;
              if (error == null && capabilities == null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  ),
                );
              }
              return Column(
                children: [
                  ListTile(
                    trailing: const Icon(Icons.chevron_right_outlined),
                    title: Text(L10n.of(context).blockedUsers),
                    subtitle: Text(
                      L10n.of(context).thereAreCountUsersBlocked(
                        Matrix.of(context).client.ignoredUsers.length,
                      ),
                    ),
                    onTap: () =>
                        context.go('/rooms/settings/security/ignorelist'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

extension on ShareKeysWith {
  String localized(L10n l10n) {
    switch (this) {
      case ShareKeysWith.all:
        return l10n.allDevices;
      case ShareKeysWith.crossVerifiedIfEnabled:
        return l10n.crossVerifiedDevicesIfEnabled;
      case ShareKeysWith.crossVerified:
        return l10n.crossVerifiedDevices;
      case ShareKeysWith.directlyVerifiedOnly:
        return l10n.verifiedDevicesOnly;
    }
  }
}
