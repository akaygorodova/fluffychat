import 'package:flutter/material.dart';

import 'home_autologin.dart';

class HomeAutoLoginView extends StatelessWidget {
  final HomeAutoLoginController controller;

  const HomeAutoLoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : const SizedBox(
                          height: 0,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
