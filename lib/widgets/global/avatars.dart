import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
    this.base64ProfilePicture,
    this.radius = 22.5,
    this.setProfilePicture,
  });

  final String? base64ProfilePicture;
  final void Function(String? newProfilePicture)? setProfilePicture;
  final double radius;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool isDroppedOver = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: DropRegion(
        formats: const [Formats.png, Formats.jpeg, Formats.bmp],
        onDropOver: (event) {
          return DropOperation.copy;
        },
        onDropEnter: (p0) => isDroppedOver = true,
        onDropLeave: (p0) => isDroppedOver = false,
        onDropEnded: (p0) => isDroppedOver = false,
        onPerformDrop: (event) async {
          event.session.items.first.dataReader?.getValue(
            Formats.fileUri,
            (value) async {
              if (value != null) {
                widget.setProfilePicture?.call(
                  base64Encode(
                    await File(value.toFilePath()).readAsBytes(),
                  ),
                );
              }
            },
          );
        },
        child: CircleAvatar(
          radius: widget.radius,
          child: ClipOval(
            child: widget.base64ProfilePicture != null
                ? AspectRatio(
                    aspectRatio: 1,
                    child: Image.memory(
                      const Base64Decoder()
                          .convert(widget.base64ProfilePicture!),
                      gaplessPlayback: true,
                      cacheHeight: (widget.radius * 2).toInt(),
                      cacheWidth: (widget.radius * 2).toInt(),
                      width: (widget.radius * 2),
                      height: (widget.radius * 2),
                    ),
                  )
                : const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}
