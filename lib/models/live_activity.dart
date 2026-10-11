class LiveActivityData {
  final String title;
  final String room;
  final String hourIndicator;
  final int startTime; // epoch millis
  final int endTime; // epoch millis
  final String nextTitle;
  final String nextRoom;
  final int? nextStartTime; // epoch millis
  final String afterText;
  final bool isOngoing;
  final bool isLastLesson;
  final bool nextDirectlyAfter;
  final int startLateThreshold; // epoch millis
  final int endTransitionThreshold; // epoch millis

  const LiveActivityData({
    required this.title,
    this.room = '',
    this.hourIndicator = '',
    required this.startTime,
    required this.endTime,
    this.nextTitle = '',
    this.nextRoom = '',
    this.nextStartTime,
    this.afterText = '',
    this.isOngoing = true,
    this.isLastLesson = false,
    this.nextDirectlyAfter = false,
    required this.startLateThreshold,
    required this.endTransitionThreshold,
  });

  LiveActivityData copyWith({
    String? title,
    String? room,
    String? hourIndicator,
    int? startTime,
    int? endTime,
    String? nextTitle,
    String? nextRoom,
    int? nextStartTime,
    String? afterText,
    bool? isOngoing,
    bool? isLastLesson,
    bool? nextDirectlyAfter,
    int? startLateThreshold,
    int? endTransitionThreshold,
  }) {
    return LiveActivityData(
      title: title ?? this.title,
      room: room ?? this.room,
      hourIndicator: hourIndicator ?? this.hourIndicator,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      nextTitle: nextTitle ?? this.nextTitle,
      nextRoom: nextRoom ?? this.nextRoom,
      nextStartTime: nextStartTime ?? this.nextStartTime,
      afterText: afterText ?? this.afterText,
      isOngoing: isOngoing ?? this.isOngoing,
      isLastLesson: isLastLesson ?? this.isLastLesson,
      nextDirectlyAfter: nextDirectlyAfter ?? this.nextDirectlyAfter,
      startLateThreshold: startLateThreshold ?? this.startLateThreshold,
      endTransitionThreshold:
          endTransitionThreshold ?? this.endTransitionThreshold,
    );
  }

  factory LiveActivityData.fromJson(Map<String, dynamic> json) {
    return LiveActivityData(
      title: json['title'] as String? ?? '',
      room: json['room'] as String? ?? '',
      hourIndicator: json['hourIndicator'] as String? ?? '',
      startTime: (json['startTime'] as num?)?.toInt() ?? 0,
      endTime: (json['endTime'] as num?)?.toInt() ?? 0,
      nextTitle: json['nextTitle'] as String? ?? '',
      nextRoom: json['nextRoom'] as String? ?? '',
      nextStartTime: (json['nextStartTime'] as num?)?.toInt(),
      afterText: json['afterText'] as String? ?? '',
      isOngoing: json['isOngoing'] as bool? ?? true,
      isLastLesson: json['isLastLesson'] as bool? ?? false,
      nextDirectlyAfter: json['nextDirectlyAfter'] as bool? ?? false,
      startLateThreshold: (json['startLateThreshold'] as num?)?.toInt() ?? 0,
      endTransitionThreshold:
          (json['endTransitionThreshold'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'room': room,
        'hourIndicator': hourIndicator,
        'startTime': startTime,
        'endTime': endTime,
        'nextTitle': nextTitle,
        'nextRoom': nextRoom,
        if (nextStartTime != null) 'nextStartTime': nextStartTime,
        'afterText': afterText,
        'isOngoing': isOngoing,
        'isLastLesson': isLastLesson,
        'nextDirectlyAfter': nextDirectlyAfter,
        'startLateThreshold': startLateThreshold,
        'endTransitionThreshold': endTransitionThreshold,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiveActivityData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          room == other.room &&
          hourIndicator == other.hourIndicator &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          nextTitle == other.nextTitle &&
          nextRoom == other.nextRoom &&
          nextStartTime == other.nextStartTime &&
          afterText == other.afterText &&
          isOngoing == other.isOngoing &&
          isLastLesson == other.isLastLesson &&
          nextDirectlyAfter == other.nextDirectlyAfter &&
          startLateThreshold == other.startLateThreshold &&
          endTransitionThreshold == other.endTransitionThreshold;

  @override
  int get hashCode => Object.hash(
        title,
        room,
        hourIndicator,
        startTime,
        endTime,
        nextTitle,
        nextRoom,
        nextStartTime,
        afterText,
        isOngoing,
        isLastLesson,
        nextDirectlyAfter,
        startLateThreshold,
        endTransitionThreshold,
      );

  @override
  String toString() =>
      'LiveActivityData(title: $title, room: $room, hourIndicator: $hourIndicator, startTime: $startTime, endTime: $endTime, isOngoing: $isOngoing)';
}
