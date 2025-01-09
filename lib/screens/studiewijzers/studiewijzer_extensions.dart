import 'dart:collection';

import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:flutter/material.dart';

extension StudieWijzerExtension on Studiewijzer {
  Widget get icon {
    Widget? icon;

    if (customEmojiIcon != null) {
      icon = Text(customEmojiIcon!);
    } else {
      final lowerCaseTitle = titel.toLowerCase();
      final subjectIcons = {
        "nederlands": const Text("🌷"),
        "frans": const Text("🥖"),
        "français": const Text("🥖"),
        "duits": const Text("🇩🇪"),
        "deutsch": const Text("🇩🇪"),
        "engels": const Text("☕️"),
        "english": const Text("☕️"),
        "eng": const Text("☕️"),
        "natuurkunde": const Icon(Icons.architecture),
        "physics": const Icon(Icons.architecture),
        "nat": const Icon(Icons.architecture),
        "aardrijkskunde": const Icon(Icons.public),
        "geography": const Icon(Icons.public),
        "ak": const Icon(Icons.public),
        "wiskunde": const Icon(Icons.functions),
        "math": const Icon(Icons.functions),
        "wis": const Icon(Icons.functions),
        "biologie": const Icon(Icons.emoji_nature),
        "biology": const Icon(Icons.emoji_nature),
        "bio": const Icon(Icons.emoji_nature),
        "culturele": const Icon(Icons.art_track),
        "ckv": const Icon(Icons.art_track),
        "scheikunde": const Icon(Icons.science),
        "chemistry": const Icon(Icons.science),
        "sk": const Icon(Icons.science),
        "profielwerkstuk": const Icon(Icons.subject),
        "informatica": const Icon(Icons.computer),
        "inf": const Icon(Icons.computer),
        "geschiedenis": const Text("🏛️"),
        "gs": const Text("🏛️"),
        "economie": const Text("💰"),
        "ec": const Text("💰"),
        "tekenen": const Icon(Icons.draw),
        "bv": const Icon(Icons.draw),
        "beeldendevorming": const Icon(Icons.draw),
        "muziek": const Icon(Icons.music_note),
        "music": const Icon(Icons.music_note),
        "gymnastiek": const Icon(Icons.fitness_center),
        "lo": const Icon(Icons.fitness_center),
        "lichamelijkeopvoeding": const Icon(Icons.fitness_center),
        "filosofie": const Icon(Icons.psychology),
        "filo": const Icon(Icons.psychology),
        "psychologie": const Icon(Icons.psychology),
        "maatschappijleer": const Icon(Icons.account_balance),
        "maatschappijwetenschappen": const Icon(Icons.account_balance),
        "maw": const Icon(Icons.account_balance),
        "techniek": const Icon(Icons.build),
        "technology": const Icon(Icons.build),
        "handvaardigheid": const Icon(Icons.handyman),
        "hv": const Icon(Icons.handyman),
        "drama": const Icon(Icons.theater_comedy),
        "theater": const Icon(Icons.theater_comedy),
        "latijn": const Text("🏛️"),
        "latin": const Text("🏛️"),
        "grieks": const Text("🏛️"),
        "greek": const Text("🏛️"),
        "spaans": const Text("🇪🇸"),
        "spanish": const Text("🇪🇸"),
        "italiaans": const Text("🇮🇹"),
        "italian": const Text("🇮🇹"),
        "portugees": const Text("🇵🇹"),
        "portuguese": const Text("🇵🇹"),
        "russisch": const Text("🇷🇺"),
        "russian": const Text("🇷🇺"),
        "technasium": const Icon(Icons.engineering),
        "nlt": const Icon(Icons.biotech),
        "natuur, leven en technologie": const Icon(Icons.biotech),
        "o&o": const Icon(Icons.science),
        "onderzoek en ontwerpen": const Icon(Icons.science),
        "informatie": const Icon(Icons.info),
        "informatie wetenschap": const Icon(Icons.info),
        "technologie & toepassing": const Icon(Icons.settings_applications),
        "debatteren": const Icon(Icons.forum),
        "robotica": const Icon(Icons.auto_mode),
        "ondernemerschap": const Icon(Icons.business),
        "creatief schrijven": const Icon(Icons.edit),
        "mandarijn": const Text("🇨🇳"),
        "mandarin": const Text("🇨🇳"),
        "arabisch": const Text("🇸🇦"),
        "arabic": const Text("🇸🇦"),
        "japans": const Text("🇯🇵"),
        "japanese": const Text("🇯🇵"),
        "turks": const Text("🇹🇷"),
        "turkish": const Text("🇹🇷"),
        "pools": const Text("🇵🇱"),
        "polish": const Text("🇵🇱"),
        "studievaardigheden": const Icon(Icons.school),
        "lob": const Icon(Icons.work),
        "loopbaanoriëntatie en begeleiding": const Icon(Icons.work),
        "technologie": const Icon(Icons.build),
        "horeca": const Icon(Icons.restaurant),
        "zorg en welzijn": const Icon(Icons.health_and_safety),
        "handel en administratie": const Icon(Icons.account_balance_wallet),
        "verzorging": const Icon(Icons.local_hospital),
        "mediawijsheid": const Icon(Icons.perm_media),
        "kunst algemeen": const Icon(Icons.palette),
        "kunstvak": const Icon(Icons.theater_comedy),
        "fotografie": const Icon(Icons.camera_alt),
      };

      for (var entry in subjectIcons.entries) {
        if (lowerCaseTitle.contains(entry.key)) {
          icon = entry.value;
          break;
        }
      }
    }

    return icon != null
        ? DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, height: 1.2),
            child: Align(
              alignment: Alignment.center,
              child: icon,
            ),
          )
        : Icon(onderdelen.isNotEmpty ? Icons.folder : Icons.folder_outlined);
  }
}

extension StudieWijzerListExtension on Iterable<Studiewijzer> {
  List<List<Studiewijzer>> get group {
    List<List<Studiewijzer>> groups = [];
    for (Studiewijzer wijzer in where((s) => s.groupedUUIDS.isNotEmpty)) {
      List<Studiewijzer>? group = groups
          .where((group) => group
              .map((e) => e.uuid)
              .any((w) => wijzer.groupedUUIDS.contains(w)))
          .firstOrNull;
      if (group == null) {
        // Group does not exist yet, creating it.
        groups.add([wijzer]);
      } else {
        group.add(wijzer);
      }
    }
    return groups
      ..addAll([
        ...where((s) => s.groupedUUIDS.isEmpty).map((e) => [e])
      ]);
  }

  /// Get suggested groups based on a list of studiewijzers
  Map<String, List<Studiewijzer>> get getGroupSuggestions {
    Map<String, List<Studiewijzer>> keywordGroups = {};

    Set<String> extractKeywords(String folderName) {
      List<String> negativeWords = ["atheneum", "vwo", "havo", "mavo", "vmbo"];

      return folderName
          .toLowerCase()
          .split(
            // Split by space, hyphen, underscore, or numbers
            RegExp(r'\s+|\-|_|\d+'),
          )
          .where(
            // Remove words shorter than 2 characters and filter out banned words
            (word) => word.length > 2 && !negativeWords.contains(word),
          )
          .toSet();
    }

    for (Studiewijzer folder in this) {
      Set<String> keywords =
          extractKeywords(folder.customName ?? folder.rawTitel);

      bool added = false;
      for (String keyword in keywords) {
        if (keywordGroups.containsKey(keyword)) {
          keywordGroups[keyword]!.add(folder);
          added = true;
          break;
        }
      }

      if (!added) {
        // If no existing group found, start a new one
        for (String keyword in keywords) {
          keywordGroups[keyword] = [folder];
        }
      }
    }

    // Filter groups with only one item
    return SplayTreeMap<String, List<Studiewijzer>>.from(
      Map.fromEntries(
        keywordGroups.entries.where((entry) => entry.value.length > 1),
      ),
    );
  }
}
