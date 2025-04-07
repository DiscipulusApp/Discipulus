import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:discipulus/api/models/external_bron.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/core/spotlight_search.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_apple_handoff/flutter_apple_handoff.dart';
import 'package:flutter_apple_spotlight/flutter_apple_spotlight.dart';
import 'package:isar/isar.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:super_clipboard/src/formats_base.dart';
import 'package:url_launcher/url_launcher.dart';

part 'bronnen.g.dart';

extension NameHelper on String {
  String get removePossibleExtension =>
      (split(".").length > 1) ? (split(".")..removeLast()).join() : this;
}

@Collection()
@Name("Bron")
class Bron with SpotlightSearchElementMixin {
  final profile = IsarLink<Profile>();

  Id get uuid => "${profile.value!.uuid}$id".hashCode;
  final int id;

  // Names
  final String rawNaam;
  String? customName;
  @ignore
  String get naam => appSettings.showBronExtension
      ? (customName ?? rawNaam)
      : (customName ?? rawNaam).removePossibleExtension;
  set naam(String? name) =>
      isar.writeTxnSync(() => isar.brons.putSync(this..customName = name));

  final String contentType;
  final int? status;
  final DateTime? datum;
  final int grootte;
  final int bronSoort;
  final int parentId;
  final List<BronLink> links;

  DateTime? lastUsed;
  bool isFavorite = false;
  @ignore
  BronType get type {
    switch (bronSoort) {
      case 0:
        return BronType.folder;
      case 1:
        return BronType.file;
      case 3:
        return BronType.link;
      default:
        return BronType.unknown;
    }
  }

  @ignore
  IconData get icon {
    if (bronSoort == 0) {
      return Icons.folder;
    } else if (bronSoort == 3) {
      return Icons.link;
    } else {
      return contentType.iconForMime;
    }
  }

  String? rawSavedPath;
  bool isDownloading = false;

  /// The [ExternalBronSource]. Will only be set if the bron is from a
  /// [ExternalBronSource].
  @Backlink(to: 'bronnen')
  final source = IsarLink<ExternalBronSource>();

  Bron({
    required this.id,
    required this.rawNaam,
    required this.contentType,
    required this.status,
    required this.datum,
    required this.grootte,
    required this.bronSoort,
    required this.links,
    required this.parentId,
  });

  factory Bron.fromJson(String str) => Bron.fromMap(json.decode(str));

  factory Bron.fromMap(Map<String, dynamic> json) => Bron(
        id: json["Id"] ?? json["id"],
        rawNaam: json["Naam"] ?? json["naam"],
        contentType: json["ContentType"] ?? json["contentType"],
        status: json["Status"] ?? 0,
        datum: ((json["Datum"] ?? json["aangemaaktOp"]) != null)
            ? DateTime.parse(json["Datum"] ?? json["aangemaaktOp"]).toUtc()
            : null,
        grootte: json["Grootte"] ?? json["grootte"],
        parentId: json["ParentId"] ?? 0,
        bronSoort: json["BronSoort"] ?? 1,
        links: List<BronLink>.from(json["links"] != null
            ? [
                BronLink(
                    rel: "download", href: json["links"]["download"]["href"])
              ]
            : (json["Links"]).map((x) => BronLink.fromMap(x))),
      );

  factory Bron.fromOnedriveMap(Map<String, dynamic> json,
          {int? customParentId}) =>
      Bron(
        id: json["id"].hashCode,
        parentId: customParentId ??
            (json["bovenliggendeId"] ?? json["mapId"]).hashCode,
        rawNaam: json["naam"],
        contentType: json["contentType"] ?? "folder",
        status: 0,
        datum: null,
        grootte: json["grootte"] ?? 0,
        bronSoort: json["type"].contains("map") ? 0 : 1,
        links: [
          if (json["links"]?["self"]?["href"] != null)
            BronLink(rel: "self", href: json["links"]["self"]["href"]),
          if (json["links"]?["children"]?["href"] != null)
            BronLink(rel: "children", href: json["links"]["children"]["href"]),
          if (json["links"]?["download"]?["href"] != null)
            BronLink(rel: "download", href: json["links"]["download"]["href"])
        ],
      );

  void toggleFavorite() => isar
      .writeTxnSync(() => isar.brons.putSync(this..isFavorite = !isFavorite));

  void updateLastUsed() {
    isar.writeTxnSync(
        () => isar.brons.putSync(this..lastUsed = DateTime.now()));
    updateSpotlight();
  }

  @override
  @ignore
  SpotlightSearchElement? get spotlightItem => SpotlightSearchElement(
        uniqueIdentifier: "bronnen_$uuid",
        attributeSet: CoreSpotlightItemAttributeSet(
          UTType.fileURL,
          title: naam,
          metadataModificationDate: datum,
          fileSize: grootte,
          contentURL: Uri.tryParse(savedPath ?? ""),
        ),
      );
}

@embedded
class BronLink {
  final String rel;
  final String href;

  BronLink({
    this.rel = "",
    this.href = "",
  });

  factory BronLink.fromMap(Map<String, dynamic> json) => BronLink(
        rel: json["Rel"] ?? json.keys.first,
        href: json["Href"] ?? json.values.first["href"],
      );

  factory BronLink.fromMessagesMap(
          Map<String, MapEntry<dynamic, dynamic>> json) =>
      BronLink(
        rel: json.keys.first,
        href: json.values.first.value,
      );
}

enum BronType { file, folder, link, unknown }

extension BronIOExtension on Bron {
  File? get localFile => savedPath != null ? File(savedPath!) : null;

  /// The location where the file should be stored
  Future<String> get filePath async =>
      "${(await getApplicationSupportDirectory()).path}/bronnen/$id/${rawNaam.replaceAll(RegExp('[^A-Za-z0-9.-_]'), '_')}";

  /// The current path of the stored file. Will be null of the file has not been
  /// stored on the local filesystem.
  String? get savedPath {
    if (rawSavedPath != null && File(rawSavedPath!).existsSync()) {
      return rawSavedPath;
    } else {
      rawSavedPath = null;
      return null;
    }
  }

  /// Removes the current file if existent
  void remove([String? path]) {
    if ((path ?? savedPath) != null && File(path ?? savedPath!).existsSync()) {
      // We are storing everything in a folder, so we need to remove the file as
      // well as the folder that it is stored in.
      File(((path ?? savedPath!).split("/")..removeLast()).join("/"))
          .deleteSync(recursive: true);
    }
    isar.writeTxnSync(() => isar.brons.putSync(this..rawSavedPath = null));
  }
}

/// Contains information about a Bron that is currently downloading
class DownloadingBronInformation {
  final CancelToken cancelToken;
  final ValueNotifier<int?>? recievedBytes;
  int? totalBytes;

  DownloadingBronInformation({
    required this.cancelToken,
    this.recievedBytes,
    this.totalBytes,
  });
}

extension BronLocalExtension on Bron {
  /// Opens the file and tries to set the activity
  Future<void> openFile() async {
    // Get current activity
    NSUserActivity? activityBefore = (Platform.isIOS || Platform.isMacOS)
        ? await FlutterAppleHandoff.getCurrentActivity
        : null;

    // When the bron actually has a file.
    if (savedPath != null) {
      if (Platform.isIOS || Platform.isMacOS) {
        await HandoffActivity.construct(
          title: naam,
          screenType: Bron,
          profileUUID: profile.value?.uuid,
          type: NSUserActivityTypes.subPage,
          extraInfo: {
            "bron_href": links.firstOrNull?.href,
            "bron_UUID": uuid,
          },
        ).becomeCurrent();
      }

      // Open the file
      if (Platform.isLinux) {
        // Without an Isolate the application will hang in Linux, making it
        // impossible to open multiple files.
        await Isolate.spawn(
            (String path) async => await OpenFile.open(path), savedPath!);
      } else {
        await OpenFile.open(savedPath!);
      }

      // Revert the activity to the activity before.
      if (Platform.isIOS || Platform.isMacOS) {
        await FlutterAppleHandoff.updateActivity(activityBefore);
      }
    }
  }
}

Map<int, DownloadingBronInformation> downloadingBronnen = {};

extension BronAPIExtension on Bron {
  /// Downloads the file from Magister and saves it to the correct path.
  Future<void> download({
    String? path,
    void Function(int received, int total)? onReceiveProgress,
    void Function()? onCancel,
  }) async {
    if (bronSoort == 3) {
      launchUrl(await absoluteFileLocation);
    } else if (links
        .where((e) => e.rel == "Children" || e.rel == "children")
        .isNotEmpty) {
      // This is actually a folder that needs it's children to be fetched.

      await source.value?.syncBronnen(links
          .where((e) => e.rel == "Children" || e.rel == "children")
          .first
          .href
          .replaceAll("/api/", ""));
    } else {
      // Create a information class
      downloadingBronnen.addAll({
        uuid: DownloadingBronInformation(
          cancelToken: CancelToken(),
          recievedBytes: ValueNotifier(null),
          totalBytes: 0,
        )
      });

      String savingPath = path ?? await filePath;
      isar.writeTxnSync(
        () => isar.brons.putSync(this..isDownloading = true),
      );

      try {
        await Dio().downloadUri(
          await absoluteFileLocation,
          savingPath,
          onReceiveProgress: (count, total) {
            onReceiveProgress?.call(count, total);
            downloadingBronnen[uuid]!
              ..recievedBytes?.value = count
              ..totalBytes = total;
          },
          cancelToken: downloadingBronnen[uuid]!.cancelToken,
        );
        cleanupDownload(savingPath);
        await updateSpotlight();
      } catch (e) {
        cleanupDownload();
        if ((e is DioException && CancelToken.isCancel(e))) {
          onCancel?.call();
        } else {
          rethrow;
        }
      }
    }
  }

  /// Downloads the file from the API and streams it. This does **not** call
  /// cleanupDownload(), so that should be done!
  Future<Stream<Uint8List>?> downloadAsStream({
    void Function(int received, int total)? onReceiveProgress,
    void Function()? onCancel,
  }) async {
    downloadingBronnen.addAll({
      uuid: DownloadingBronInformation(
        cancelToken: CancelToken(),
        recievedBytes: ValueNotifier(null),
        totalBytes: 0,
      )
    });

    isar.writeTxnSync(
      () => isar.brons.putSync(this..isDownloading = true),
    );
    try {
      return (await Dio().getUri<ResponseBody>(
        await absoluteFileLocation,
        onReceiveProgress: (received, total) {
          onReceiveProgress?.call(received, total);
          downloadingBronnen[uuid]!
            ..recievedBytes?.value = received
            ..totalBytes = total;
        },
        cancelToken: downloadingBronnen[uuid]!.cancelToken,
        options: Options(responseType: ResponseType.stream),
      ))
          .data
          ?.stream;
    } catch (e) {
      cleanupDownload();
      if ((e is DioException && CancelToken.isCancel(e))) {
        onCancel?.call();
      } else {
        rethrow;
      }
    }
    return null;
  }

  /// Should be run when a download has completed
  void cleanupDownload([String? path]) {
    downloadingBronnen[uuid]
      ?..recievedBytes?.value = null
      ..totalBytes = null
      ..recievedBytes?.dispose();
    downloadingBronnen.remove(uuid);
    updateSpotlight();
    isar.writeTxnSync(
      () => isar.brons.putSync(this
        ..isDownloading = false
        ..rawSavedPath = path
        ..lastUsed = DateTime.now()),
    );
  }

  /// Give the absolute file location from the API, this link will only be valid
  /// for a few hours. Sometimes, in case of a link, this can just be the link to
  /// a website that should be opened.
  Future<Uri> get absoluteFileLocation async {
    if (bronSoort == 3) {
      // Just a link to a website
      return Uri.parse(links.firstWhere((l) => l.rel == "Contents").href);
    } else {
      // An actual file

      // Usually the longest URL if all the URL-types a present, contains the
      // download.
      String url = (links
              .where((l) =>
                  l.rel == "download" || l.rel == "Contents" || l.rel == "Self")
              .toList()
            ..sort(
              (a, b) => b.href.length.compareTo(a.href.length),
            ))
          .first
          .href;

      return Uri.parse((await (profile.value ?? activeProfile)
              .account
              .value!
              .api
              .dio
              .get("${url.replaceAll("/api/", "")}?redirect_type=body"))
          .data["location"]);
    }
  }
}

extension BronDragExtension on Bron {
  FutureOr<DragItem?> dragItemProvider(DragItemRequest request,
      {Function? onDownloadDone}) {
    var item = DragItem(suggestedName: (customName ?? rawNaam));

    // Get the supported file type. When it is not supported this will be null
    SimpleFileFormat? format = Formats.standardFormats
        .whereType<SimpleFileFormat>()
        .cast<SimpleFileFormat?>()
        .where((e) =>
            e?.mimeTypes?.contains(
                savedPath != null ? lookupMimeType(savedPath!) : contentType) ??
            false)
        .firstOrNull;

    if (savedPath != null) {
      // File has already been downloaded

      // Android is not really a fan of having fileUri exposed, so it throws an
      // exception. To circumvent this android will only support certain file
      // types.
      item.add(Platform.isAndroid && format != null
          ? format.call(localFile!.readAsBytesSync())
          : Formats.fileUri.call(localFile!.uri));
      return item;
    } else if (item.virtualFileSupported) {
      // This operating system supports virtual files, so we will be using
      // that.

      if (format != null) {
        // Only certain types of files are supported for virtual files
        item.addVirtualFile(
          format: format,
          provider: (sinkProvider, progress) async {
            // Create sink
            EventSink<List<int>> sink =
                sinkProvider(fileSize: grootte) as EventSink<List<int>>;

            progress.onCancel.addListener(
              () => downloadingBronnen[uuid]?.cancelToken.cancel(),
            );

            if (appSettings.saveVirtualFiles) {
              await download(
                onReceiveProgress: (received, total) =>
                    progress.updateProgress(received / total),
                onCancel: () => sink.close(),
              );
              if (localFile != null) {
                await for (var data in localFile!.openRead()) {
                  sink.add(data);
                }
              }
            } else {
              Stream<Uint8List>? stream = await downloadAsStream(
                onReceiveProgress: (received, total) =>
                    progress.updateProgress(received / total),
                onCancel: () => sink.close(),
              );

              // Add file to sink. The file can be null if the stream was
              // cancelled.
              if (isDownloading == true && stream != null) {
                await for (var chunk in stream) {
                  sink.add(chunk);
                }
              }
              cleanupDownload();
            }

            progress.onCancel.removeListener(() {});

            // Set the updated state
            onDownloadDone?.call();
            sink.close();
          },
        );
      }
      return item;
    } else {
      // The file is not saved and cannot be downloaded, as virtual file are not
      // supported. Dragging the file to see the entire name of it is sometimes
      // handy though, so we will still allow dragging to be possible.
      return item;
    }
  }
}

extension BronListExtension on Iterable<Bron> {
  Future<void> share([BuildContext? context]) async {
    final box = context?.findRenderObject() as RenderBox?;
    Rect? rect =
        box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;

    Future<XFile?> fileFromStream(Future<Stream<Uint8List>?> stream,
        {XFile Function(Uint8List data)? onData}) async {
      final data = await stream;
      List<int> allBytes = [];

      if (data == null) {
        return null;
      }

      await for (final chunk in data) {
        allBytes.addAll(chunk);
      }

      return onData?.call(Uint8List.fromList(allBytes)) ??
          XFile.fromData(
            Uint8List.fromList(allBytes),
          );
    }

    if (length == 1 && first.type == BronType.link) {
      await Share.shareUri(
        await first.absoluteFileLocation,
        sharePositionOrigin: rect,
      );
      return;
    }

    // Some files will not have been downloaded, so we will download those.
    List<XFile> files = (await Future.wait(
      [
        for (Bron bron
            in where((e) => e.savedPath == null && e.type == BronType.file))
          fileFromStream(
            bron.downloadAsStream(),
            onData: (data) => XFile.fromData(
              data,
              name: bron.naam,
              mimeType: bron.contentType,
            ),
          )
      ],
    ))
        .nonNulls
        .toList();

    where((e) => e.savedPath == null).forEach(
      (e) => e.cleanupDownload(),
    );

    await Share.shareXFiles(
      [
        for (Bron bron in where((e) => e.savedPath != null))
          XFile(
            bron.savedPath!,
            name: bron.naam,
            mimeType: bron.contentType,
          ),
        ...files
      ],
      sharePositionOrigin: rect,
    );
  }
}
