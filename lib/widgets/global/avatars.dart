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
    this.forceSquare = false,
  });

  final String? base64ProfilePicture;
  final void Function(String? newProfilePicture)? setProfilePicture;
  final double radius;
  final bool forceSquare;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool isDroppedOver = false;

  Widget _buildImage() {
    if (widget.base64ProfilePicture == null) {
      return const Icon(Icons.person);
    }

    final pixelRatio = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final targetPixelSize = (widget.radius * 2 * pixelRatio).ceil();

    return AspectRatio(
      aspectRatio: 1,
      child: Image.memory(
        const Base64Decoder().convert(widget.base64ProfilePicture!),
        gaplessPlayback: true,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        cacheHeight: targetPixelSize,
        cacheWidth: targetPixelSize,
        width: (widget.radius * 2),
        height: (widget.radius * 2),
      ),
    );
  }

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
        child: widget.forceSquare ? _buildImage() : CircleAvatar(
          radius: widget.radius,
          child: ClipOval(
            child: _buildImage()
          ),
        ),
      ),
    );
  }
}
