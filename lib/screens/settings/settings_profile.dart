// import 'dart:io';

// import 'package:discipulus/models/account.dart';
// import 'package:discipulus/screens/settings/settings.dart';
// import 'package:discipulus/widgets/global/list_decoration.dart';
// import 'package:discipulus/widgets/global/skeletons/default.dart';
// import 'package:flutter/material.dart';

// class ProfileSettingsScreen extends StatefulWidget {
//   const ProfileSettingsScreen({super.key, required this.profile});

//   final Profile profile;

//   @override
//   State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
// }

// class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
//   void changeSetting(void Function() change) {
//     change.call();
//     setState(() {});
//     widget.profile.save();
//   }

//   List<SettingsSection> get settingsSections => [
//         SettingsSection(name: "Notificaties", children: [
//           SwitchListTile(
//             title: Text("Evenementen"),
//             value: widget.profile.settings.eventsNotifications,
//             onChanged: (value) => changeSetting(
//               () => widget.profile.settings.eventsNotifications = value,
//             ),
//           ),
//           SwitchListTile(
//             title: Text("Cijfers"),
//             value: widget.profile.settings.gradesNotfications,
//             onChanged: (value) => changeSetting(
//               () => widget.profile.settings.gradesNotfications = value,
//             ),
//           ),
//           SwitchListTile(
//             title: Text("Berichten"),
//             value: widget.profile.settings.messagesNotifications,
//             onChanged: (value) => changeSetting(
//               () => widget.profile.settings.messagesNotifications = value,
//             ),
//           )
//         ]),
//         if (Platform.isIOS || Platform.isAndroid)
//           SettingsSection(name: "Spotlight Search", children: [
//             SwitchListTile(
//               title: Text("Berichten"),
//               value: widget.profile.settings.spotlightIndexMessages,
//               onChanged: (value) => changeSetting(
//                 () => widget.profile.settings.spotlightIndexMessages = value,
//               ),
//             ),
//             SwitchListTile(
//               title: Text("Studiewijzers"),
//               value: widget.profile.settings.spotlightIndexStudiewijzers,
//               onChanged: (value) => changeSetting(
//                 () =>
//                     widget.profile.settings.spotlightIndexStudiewijzers = value,
//               ),
//             ),
//           ]),
//       ];

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldSkeleton(
//       appBar: (isRefreshing, trailingRefreshButton, leading) =>
//           SliverAppBar.large(
//         title: Text("Instellingen voor ${widget.profile.name}"),
//       ),
//       children: [
//         ...settingsSections
//             .map((e) => [ListTitle(child: Text(e.name)), ...e.children])
//             .expand((e) => e)
//       ],
//     );
//   }
// }
