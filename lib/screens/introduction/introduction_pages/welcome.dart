// import 'package:discipulus/models/account.dart';
// import 'package:discipulus/models/dummy_account.dart';
// import 'package:discipulus/screens/misc/introduction.dart';
// import 'package:discipulus/screens/misc/welcome.dart';
// import 'package:discipulus/utils/account_manager.dart';
// import 'package:discipulus/utils/extensions.dart';
// import 'package:discipulus/widgets/global/card.dart';
// import 'package:discipulus/widgets/global/layout.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_apple_handoff/Classes/user_activity.dart';
// import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   final String title = "Welkom bij Discipulus";
//   final String subtitle = "Qui erat discipulus, magister factus est";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(scrolledUnderElevation: 0),
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 32),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: Text(
//                       title,
//                       style: Theme.of(context).textTheme.displayMedium
//                         ?..copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                 ],
//               ),
//             ),
//             Wrap(
//               alignment: WrapAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                     onPressed: () => otherLoginDialog(context),
//                     child: const Text("Anders")),
//                 FilledButton.icon(
//                     onPressed: () => IntroductionScreen.of(context).nextPage(),
//                     icon: const Icon(Icons.login),
//                     label: const Text("Login met Magister")),
//               ],
//             )
//           ],
//         ),
//       )),
//     );
//   }

//   Future<void> otherLoginDialog(BuildContext context) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Login op een andere manier'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               //TODO: REMOVE THIS OPTIONS
//               ListTile(
//                 leading: const Icon(Icons.handshake),
//                 title: const Text("Send Handoff test"),
//                 onTap: () async {
//                   print(
//                       "Current act: ${(await FlutterAppleHandoff.getCurrentActivity)?.activityType}");
//                   await FlutterAppleHandoff.updateActivity(
//                     NSUserActivity(
//                       activityType: "dev.harrydekat.discipulus.root-page",
//                       title: "Dit is een test",
//                       userInfo: {
//                         "page": "this is a page",
//                       },
//                     ),
//                   );
//                   print(
//                       "New act: ${(await FlutterAppleHandoff.getCurrentActivity)?.activityType}");
//                 },
//               ),
//               ListTile(
//                 title: Text("Dummy account"),
//                 onTap: () async {
//                   const LoginAndCreateAccountScreen(
//                     isDummy: true,
//                   ).push(context);
//                 },
//               ),
//               const ListTile(
//                 leading: Icon(Icons.qr_code),
//                 title: Text("Gebruik een QR-Code"),
//               ),
//               const ListTile(
//                 leading: Icon(Icons.upload_file),
//                 title: Text("Importeer een bestand"),
//               ),
//             ].map((e) => CustomCard(elevation: 0, child: e)).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
