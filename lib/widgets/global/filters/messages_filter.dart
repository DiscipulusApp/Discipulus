import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/widgets/global/chips/chips.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

abstract class MessageFilter {
  final int uuid;

  MessageFilter(this.uuid);
}

class MessageReadFilter extends MessageFilter {
  final bool onlyRead;

  MessageReadFilter(super.uuid, {this.onlyRead = false});
}

class MessageImportantFilter extends MessageFilter {
  final bool isImportant;

  MessageImportantFilter(super.uuid, {this.isImportant = true});
}

class MessageAttachmentFilter extends MessageFilter {
  final bool hasAttachment;

  MessageAttachmentFilter(super.uuid, {this.hasAttachment = true});
}

class MessageSenderFilter extends MessageFilter {
  final int senderId;
  final String? senderName;

  MessageSenderFilter(super.uuid, {required this.senderId, this.senderName});
}

class MessageDateRangeFilter extends MessageFilter {
  MessageDateRangeFilter(super.uuid, {required this.range});

  final DateTimeRange range;
}

extension MessageFilterExtension
    on QueryBuilder<Bericht, Bericht, QAfterFilterCondition> {
  /// Applies the active filter. If no list of filters is provided it will
  /// use the filters from the [Settings] object.
  QueryBuilder<Bericht, Bericht, QAfterFilterCondition> applyMessageFilter({
    List<MessageFilter>? filters,
  }) {
    // If no messages are present, do nothing.
    if (countSync() == 0) return this;

    // Set the correct filters
    List<MessageFilter> activeFilters = [
      ...(filters ?? Settings.activeMessageFilters)
    ];

    return
        // Filter for read messages
        optional(
                activeFilters.any((e) => e is MessageReadFilter),
                (q) => q.anyOf(
                      activeFilters.whereType<MessageReadFilter>(),
                      (q, element) => q.isGelezenEqualTo(element.onlyRead),
                    ))
            .and()
            // Filter for read messages
            .optional(
                activeFilters.any((e) => e is MessageImportantFilter),
                (q) => q.anyOf(
                      activeFilters.whereType<MessageImportantFilter>(),
                      (q, element) =>
                          q.heeftPrioriteitEqualTo(element.isImportant),
                    ))
            .and()
            // Filter for attachments
            .optional(
                activeFilters.any((e) => e is MessageAttachmentFilter),
                (q) => q.anyOf(
                      activeFilters.whereType<MessageAttachmentFilter>(),
                      (q, element) =>
                          q.heeftBijlagenEqualTo(element.hasAttachment),
                    ))
            .and()
            // Filter for senders
            .optional(
                activeFilters.any((e) => e is MessageSenderFilter),
                (q) => q.anyOf(
                      activeFilters.whereType<MessageSenderFilter>(),
                      (q, element) => q.afzender(
                        (q) => q.idEqualTo(element.senderId),
                      ),
                    ))
            .and()
            // Filter for dateRanges
            .optional(
              activeFilters.any((e) => e is MessageDateRangeFilter),
              (q) => q.anyOf(
                  activeFilters.whereType<MessageDateRangeFilter>(),
                  (q, element) => q.verzondenOpBetween(
                      element.range.start, element.range.end)),
            );
  }
}

List<Widget> messageFilterChips({
  void Function()? onChanged,
}) {
  void onPressed<T>(bool active, MessageFilter filter) {
    if (Settings.activeMessageFilters.whereType<T>().isNotEmpty) {
      Settings.activeMessageFilters.removeWhere((f) => f is T);
    } else {
      Settings.activeMessageFilters.add(filter);
    }
    onChanged?.call();
  }

  return [
    for (MessageSenderFilter filter
        in Settings.activeMessageFilters.whereType<MessageSenderFilter>())
      InputChip(
        selected: true,
        showCheckmark: false,
        avatar: const Icon(Icons.person),
        label: Text(filter.senderName ?? filter.senderId.toString()),
        onDeleted: () {
          Settings.activeMessageFilters
              .removeWhere((f) => f.uuid == filter.uuid);
          onChanged?.call();
        },
      ),
    ToggleChip(
      label: const Text("Ongelezen"),
      icon: const Icon(Icons.mark_email_unread),
      onChanged: (isEnabled) =>
          onPressed<MessageReadFilter>(isEnabled, MessageReadFilter(0)),
      initalValue: Settings.activeMessageFilters
          .whereType<MessageReadFilter>()
          .isNotEmpty,
    ),
    ToggleChip(
      label: const Text("Belangrijk"),
      icon: const Icon(Icons.info_outline),
      onChanged: (isEnabled) => onPressed<MessageImportantFilter>(
          isEnabled, MessageImportantFilter(1)),
      initalValue: Settings.activeMessageFilters
          .whereType<MessageImportantFilter>()
          .isNotEmpty,
    ),
    ToggleChip(
      label: const Text("Bijlage"),
      icon: const Icon(Icons.attach_file),
      onChanged: (isEnabled) => onPressed<MessageAttachmentFilter>(
          isEnabled, MessageAttachmentFilter(2)),
      initalValue: Settings.activeMessageFilters
          .whereType<MessageAttachmentFilter>()
          .isNotEmpty,
    ),
    DateRangeChip(
      title: const Text("Data"),
      selectedRange: Settings.activeMessageFilters
          .whereType<MessageDateRangeFilter>()
          .firstOrNull
          ?.range,
      callback: (range) {
        Settings.activeMessageFilters
            .removeWhere((f) => f is MessageDateRangeFilter);
        if (range != null) {
          Settings.activeMessageFilters
              .add(MessageDateRangeFilter(3, range: range));
        }
        onChanged?.call();
      },
    )
  ];
}
