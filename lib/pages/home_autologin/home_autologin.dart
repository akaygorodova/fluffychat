import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix/matrix.dart';

import '../../config/module_settings_keys.dart';
import '../../utils/platform_infos.dart';
import '../../widgets/matrix.dart';
import 'home_autologin_view.dart';

class HomeAutoLogin extends StatefulWidget {
  const HomeAutoLogin({super.key});

  @override
  State<StatefulWidget> createState() => HomeAutoLoginController();

}

class HomeAutoLoginController extends State<HomeAutoLogin> {
  bool loading = true;

  @override
  Widget build(BuildContext context) => HomeAutoLoginView(this);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => login());

    super.initState();
  }

  Future<void> login() async {
    final matrix = Matrix.of(context);

    const channel = BasicMessageChannel<String>(ModuleSettingKeys.chatPreferences, StringCodec());
    final homeserver = await channel.send(ModuleSettingKeys.homeserver) ?? "";
    final username = await channel.send(ModuleSettingKeys.username) ?? "";
    final password = await channel.send(ModuleSettingKeys.password) ?? "";

    if(homeserver.isEmpty || username.isEmpty || password.isEmpty) {
      SystemNavigator.pop(animated: false);
      debugPrint("error: empty params [$homeserver, $username, $password]");
      return;
    }

    (await matrix.getLoginClient()).homeserver = Uri.https(homeserver, '');
    try {
       await (await matrix.getLoginClient()).login(
        LoginType.mLoginPassword,
        identifier: AuthenticationUserIdentifier(user: username),
        password: password,
        initialDeviceDisplayName: PlatformInfos.clientName,
      );
    } on MatrixException catch (exception) {
      debugPrint("error: ${exception.errorMessage}");
      return setState(() => loading = false);
    } catch (exception) {
      debugPrint("error: ${exception.toString()}");
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }
}
