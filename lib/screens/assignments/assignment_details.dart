import 'dart:io';

import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/assignments/widgets/assignment_tile.dart';
import 'package:discipulus/screens/grades/widgets/text_input.dart';
import 'package:discipulus/screens/messages/message_compose.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:parchment/codecs.dart';

import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  const AssignmentDetailsScreen({super.key, required this.assignment});

  final Assignment assignment;

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  /// This is the activity that is displayed, it is saved because it changes
  /// when the user signs up for an element.
  late Assignment assignment;

  /// These are the activity elements. These as saved, so they can be searched
  /// and filtered
  List<AssignmentVersion> assignmentVersions = [];

  late final FleatherController controller;
  List<UploadedAttachment> uploadedAttachments = [];

  /// This list contains the progress of an attachment that is still being uploaded.
  List<UploadedAttachmentProgress> attachmentsProgress = [];

  /// Will refresh everything, from activity to the elements
  Future<void> refresh(bool isOffline) async {
    if (!isOffline) await assignment.profile.value!.getAssignments();
    assignment = (await assignment.profile.value!.assignments
        .filter()
        .uuidEqualTo(assignment.uuid)
        .findFirst())!;
    if (!isOffline) await assignment.fill();
    if (!isOffline) {
      await Future.wait([for (var ass in assignment.versies) ass.fill()]);
    }
    assignmentVersions =
        await assignment.versies.filter().sortByVersieNummerDesc().findAll();
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    controller = FleatherController();
    assignment = widget.assignment;
    assignmentVersions = assignment.versies.toList();
    super.initState();
  }

  /// This will upload a file to Magister and add the progress to [attachmentsProgress]
  Future<void> uploadAttachment(
      List<File> files, void Function(void Function()) setState,
      {bool retryFailed = false}) async {
    // Add files to files-that-are-in-progress list and call setState
    if (!retryFailed) {
      attachmentsProgress
          .addAll(files.map((e) => UploadedAttachmentProgress(path: e.path)));
    }
    setState(() {});

    // Upload all the files
    await Future.wait(files.map((e) =>
        assignment.profile.value!.account.value!.api.messages.uploadFile(
          e,
          (part, total) {
            // Update the upload progress of the file
            UploadedAttachmentProgress? progress =
                attachmentsProgress.where((p) => p.path == e.path).firstOrNull;
            progress?.part.value = part;
            progress?.total = total;
          },
          messageAttachment: false,
        ).then((value) {
          // The Upload was finished, so we can remove it from the files-that-are-in-progress list
          // and add it to the list of attachments
          attachmentsProgress.removeWhere((a) => a.path == e.path);
          uploadedAttachments = [...uploadedAttachments, value..path = e.path];
          setState(() {});
        }))).onError((error, stackTrace) {
      // When the upload fails, the files should be removed from the files-that-are-in-progress list
      attachmentsProgress
          .where((a) => files.map((e) => e.path).contains(a.path))
          .firstOrNull
          ?.failed = true;
      return [];
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handInAssignment() async {
    if (controller.document.toPlainText().isEmptyHTML &&
        uploadedAttachments.isEmpty) {
      return;
    }

    // Get last version
    AssignmentVersion? version =
        await assignment.versies.filter().sortByVersieNummerDesc().findFirst();

    // Hand everything in
    await version?.handInVersion(
        comment: parchmentHtml.encode(controller.document),
        attachments: uploadedAttachments);

    // Clear all the inputs
    controller.document.insert(0, "");
    uploadedAttachments.clear();

    // Refresh the page
    await refresh(false);
  }

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: Formats.standardFormats,
      onPerformDrop: (PerformDropEvent event) async {
        for (var e in event.session.items) {
          e.dataReader?.getValue(
            Formats.fileUri,
            (value) {
              uploadAttachment([File(value?.toFilePath() ?? "")], setState)
                  .then((value) {
                if (mounted) setState(() {});
              });
            },
          );
        }
      },
      onDropOver: (DropOverEvent event) => assignment.magInleveren || kDebugMode
          ? DropOperation.copy
          : DropOperation.forbidden,
      child: ScaffoldSkeleton(
        noWait: true,
        appBar: (isRefreshing, trailingRefreshButton, leading) =>
            SliverAppBar.large(
          title: Text(assignment.titel),
          actions: [if (trailingRefreshButton != null) trailingRefreshButton],
        ),
        fetch: refresh,
        activity: HandoffActivity.construct(
          type: NSUserActivityTypes.subPage,
          title: widget.assignment.titel,
          profileUUID: widget.assignment.profile.value?.uuid,
          screenType: AssignmentDetailsScreen,
          extraInfo: {
            "assignment_uuid": widget.assignment.uuid,
            "assignment_id": widget.assignment.id,
            "assignment_title": widget.assignment.titel,
          },
        ),
        customBuilder: (body) {
          return Scaffold(
            primary: false,
            body: body,
            floatingActionButton: assignment.magInleveren &&
                    (!controller.document.toPlainText().isEmptyHTML ||
                        uploadedAttachments.isNotEmpty)
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      await _handInAssignment();
                    },
                    label: const Text("Inleveren"),
                    icon: const Icon(Icons.send),
                  )
                : null,
          );
        },
        children: [
          // Header
          Padding(
            key: const HeaderKey(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomCard(
              child: AssignmentTile(
                assignment: assignment,
                isNavigationCard: false,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: assignmentVersions.isEmpty ? 200 : 300),
            child: Column(
              mainAxisAlignment: assignmentVersions.isEmpty
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                if (assignment.magInleveren || kDebugMode)
                  CustomCard(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RichTextInput(
                          topWidget: CustomCard(
                            margin: const EdgeInsets.all(8).copyWith(bottom: 0),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: AttachmentTileList(
                                  attachmentsProgress: attachmentsProgress,
                                  uploadedAttachments: uploadedAttachments,
                                  onAttachmentUploaded: (attachment) {
                                    uploadedAttachments = [
                                      ...uploadedAttachments,
                                      attachment
                                    ];
                                    setState(() {});
                                  },
                                  onAttachmentRemoved: (attachment) {
                                    uploadedAttachments.removeWhere(
                                        (u) => u.id == attachment.id);
                                    setState(() {});
                                  },
                                  onRetry: (attachment) {
                                    attachment.failed = false;
                                    uploadAttachment(
                                        [File(attachment.path)], setState,
                                        retryFailed: true);
                                  },
                                  uploadAttachment: (files) {
                                    uploadAttachment(files, setState)
                                        .then((value) => setState(() {}));
                                  },
                                ),
                              ),
                            ),
                          ),
                          controller: controller,
                        ),
                      ],
                    ),
                  ),
                for (AssignmentVersion version in assignmentVersions)
                  AssignmentVersionTile(
                    assignmentVersion: version,
                  ),
                if (assignmentVersions.isEmpty)
                  const Center(
                    child: Text("Geen ingeleverde versies gevonden 😪"),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
