// import 'package:discipulus/screens/misc/introduction.dart';
// import 'package:discipulus/screens/misc/welcome.dart';
// import 'package:discipulus/utils/extensions.dart';
// import 'package:discipulus/widgets/global/card.dart';
// import 'package:discipulus/widgets/global/scaffold_skeleton.dart';
// import 'package:flutter/material.dart';

// class TOSPage extends StatefulWidget {
//   const TOSPage({super.key});

//   @override
//   State<TOSPage> createState() => _TOSPageState();
// }

// class _TOSPageState extends State<TOSPage> {
//   bool allowCrashanlytics = true;
//   bool agreeToMagisterTOS = false;
//   bool agreeToSilvoTOS = false;

//   @override
//   Widget build(BuildContext context) {
//     return ExplainerSkeleton(
//       title: const Text("Voorwaarden & Instellingen"),
//       subtitle: const Text(
//           "Om Discipulus te gebruiken moet je eerst akoord gaan met de voorwaarden"),
//       content: [
//         SwitchListTile(
//             value: allowCrashanlytics,
//             title: const Text("Crashlytics"),
//             subtitle: const Text("Automatische anonieme bug-rapportage"),
//             secondary: const Icon(Icons.bug_report_outlined),
//             onChanged: (value) => setState(() {
//                   allowCrashanlytics = value;
//                 })),
//         SwitchListTile(
//             value: agreeToMagisterTOS,
//             title: const Text("Voorwaarden van Magister"),
//             subtitle:
//                 const Text("Ik ga akoord met de voorwaarden van Magister"),
//             secondary: const Icon(Icons.description_outlined),
//             onChanged: (value) => setState(() {
//                   agreeToMagisterTOS = value;
//                 })),
//         SwitchListTile(
//             value: agreeToSilvoTOS,
//             title: const Text("Voorwaarden van Discipulus"),
//             subtitle:
//                 const Text("Ik ga akoord met de voorwaarden van Discipulus"),
//             secondary: const Icon(Icons.description_outlined),
//             onChanged: (value) => setState(() {
//                   agreeToSilvoTOS = value;
//                 }))
//       ]
//           .map(
//             (e) => CustomCard(
//                 elevation: 0,
//                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
//                 child: e),
//           )
//           .toList(),
//       actions: [
//         TextButton.icon(
//           onPressed: () => IntroductionScreen.of(context).previousPage(),
//           icon: const Icon(Icons.navigate_before),
//           label: const Text("Terug"),
//         ),
//         FilledButton.icon(
//             onPressed: agreeToMagisterTOS && agreeToSilvoTOS
//                 ? () => const LoginAndCreateAccountScreen().push(context)
//                 // ? () => IntroductionScreen.of(context).nextPage()
//                 : null,
//             icon: const Icon(Icons.navigate_next),
//             label: const Text("Ga verder"))
//       ],
//     );
//   }
// }
