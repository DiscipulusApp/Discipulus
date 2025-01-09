import "package:discipulus/api/models/calendar.dart";
import "package:discipulus/screens/grades/widgets/text_input.dart";
import "package:discipulus/utils/account_manager.dart";
import "package:discipulus/widgets/global/bottom_sheet.dart";
import "package:discipulus/widgets/global/card.dart";
import "package:discipulus/widgets/global/input_dialog.dart";
import "package:fleather/fleather.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:parchment/codecs.dart";

class _CalendarScheduleScreen extends StatefulWidget {
  const _CalendarScheduleScreen(this.controller);

  final ScrollController controller;

  @override
  State<_CalendarScheduleScreen> createState() =>
      _CalendarScheduleScreenState();
}

class _CalendarScheduleScreenState extends State<_CalendarScheduleScreen> {
  bool _allDayEvent = false;
  String _eventTitle = "";
  String _eventLocation = "";
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(const Duration(hours: 1));
  CalendarType _calendarType = CalendarType.personal;
  String? _dateError;

  late final FleatherController _controller;

  bool get _isPersonalPlanning => _calendarType == CalendarType.personal;
  bool get _isAllDay => _allDayEvent;

  @override
  void initState() {
    super.initState();
    _controller = FleatherController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton(
                  onPressed: _saveEvent,
                  child: const Text("Plannen"),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(left: 52, top: 10),
              child: TextField(
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Voeg titel toe",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
                onChanged: (value) => setState(() {
                  _eventTitle = value;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  .copyWith(left: 52),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FilterChip(
                    label: const Text("Planning"),
                    selected: _calendarType == CalendarType.schedule,
                    onSelected: (bool value) {
                      if (true) {
                        setState(() {
                          _calendarType = CalendarType.schedule;
                        });
                      }
                    },
                    showCheckmark: false,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text("Persoonlijk"),
                    selected: _calendarType == CalendarType.personal,
                    onSelected: (bool value) {
                      if (true) {
                        setState(() {
                          _calendarType = CalendarType.personal;
                        });
                      }
                    },
                    showCheckmark: false,
                  ),
                  const SizedBox(width: 8),
                  const FilterChip(
                    label: Text("Absentie"),
                    selected: false,
                    onSelected: null, //(bool value) {
                    // Handle event button press
                    //},
                    showCheckmark: false,
                  ),
                ],
              ),
            ),
            CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 0,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text("All-day"),
                    trailing: Switch(
                      value: _allDayEvent,
                      onChanged: (bool value) {
                        setState(() {
                          _allDayEvent = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Text(
                      DateFormat("EEE, dd MMM yyyy").format(_selectedStartDate),
                      textAlign: TextAlign.start,
                    ),
                    onTap: () => _selectDate(context, isStartTime: true),
                    trailing: _isAllDay
                        ? null
                        : InkWell(
                            onTap: () =>
                                _selectTime(context, isStartTime: true),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                DateFormat("HH:mm").format(_selectedStartDate),
                              ),
                            ),
                          ),
                  ),
                  ListTile(
                    leading: const SizedBox(),
                    title: Text(
                      DateFormat("EEE, dd MMM yyyy").format(_selectedEndDate),
                      textAlign: TextAlign.start,
                    ),
                    onTap: () => _selectDate(context, isStartTime: false),
                    trailing: _isAllDay
                        ? null
                        : InkWell(
                            onTap: () =>
                                _selectTime(context, isStartTime: false),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                DateFormat("HH:mm").format(_selectedEndDate),
                              ),
                            ),
                          ),
                  ),
                  if (_dateError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        _dateError!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.replay),
                    title: Text("Does not repeat"),
                  ),
                ],
              ),
            ),

            CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Add location"),
                onTap: () => _setLocation(context),
                subtitle:
                    _eventLocation.isNotEmpty ? Text(_eventLocation) : null,
              ),
            ),

            CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              elevation: 0,
              child: RichTextInput(
                controller: _controller,
                minHeight: 200,
              ),
            ),
            // ListTile(
            //   title: const Text("Personal"),
            //   trailing: Switch(
            //     value: _isPersonalPlanning,
            //     onChanged: (value) {
            //       setState(() {
            //         _calendarType =
            //             value ? CalendarType.personal : CalendarType.schedule;
            //       });
            //     },
            //   ),
            // ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartTime}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;

    setState(() {
      if (isStartTime) {
        _selectedStartDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            _selectedStartDate.hour,
            _selectedStartDate.minute);
      } else {
        _selectedEndDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, _selectedEndDate.hour, _selectedEndDate.minute);
      }

      _checkDateError();
    });
  }

  Future<void> _selectTime(BuildContext context,
      {required bool isStartTime}) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          isStartTime ? _selectedStartDate : _selectedEndDate),
    );

    if (selectedTime == null) return;

    setState(() {
      if (isStartTime) {
        _selectedStartDate = DateTime(
          _selectedStartDate.year,
          _selectedStartDate.month,
          _selectedStartDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      } else {
        _selectedEndDate = DateTime(
          _selectedEndDate.year,
          _selectedEndDate.month,
          _selectedEndDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
      _checkDateError();
    });
  }

  void _checkDateError() {
    if (_selectedStartDate.isAfter(_selectedEndDate)) {
      _dateError = "Start date can't be bigger than end date";
    } else {
      _dateError = null;
    }
  }

  Future<void> _setLocation(BuildContext context) async {
    String? location = await showTextInputDialog(
      context,
      title: "Zet een lokatie",
      hint: _eventLocation,
      emptyOnEmpty: true,
    );

    if (location != null) {
      setState(() {
        _eventLocation = location;
      });
    }
  }

  Future<void> _saveEvent() async {
    _checkDateError();

    if (_dateError != null) {
      return;
    }

    try {
      await activeProfile.account.value!.api
          .person(activeProfile.id)
          .createCalendarEvent(
            duurtHeleDag: _isAllDay,
            omschrijving: _eventTitle,
            inhoud: parchmentHtml.encode(_controller.document),
            lokatie: _eventLocation,
            start: _isAllDay
                ? DateTime(_selectedStartDate.year, _selectedStartDate.month,
                    _selectedStartDate.day)
                : _selectedStartDate,
            einde: _isAllDay
                ? DateTime(_selectedEndDate.year, _selectedEndDate.month,
                    _selectedEndDate.day)
                : _selectedEndDate,
            type: _isPersonalPlanning
                ? CalendarType.personal
                : CalendarType.schedule,
          );

      Navigator.pop(context, _selectedStartDate);
    } catch (e) {
      print("Failed to save event $e");
    }
  }
}

/// Displays schedule sheet and returns the start date of the scheduled event.
/// If no event has been created it will return null.
Future<DateTime?> showScheduleSheet(BuildContext context) async {
  return await showScrollableModalBottomSheet(
    context: context,
    builder: (context, setState, scrollController) {
      return _CalendarScheduleScreen(scrollController);
    },
  );
}
