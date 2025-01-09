import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/screens/messages/tiles.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class UploadBronTile extends StatefulWidget {
  const UploadBronTile({super.key});

  @override
  State<UploadBronTile> createState() => _UploadBronTileState();
}

class _UploadBronTileState extends State<UploadBronTile> {
  List<UploadedAttachment> attachments = [];

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: const [Formats.fileUri],
      onDropOver: (p0) => DropOperation.copy,
      onPerformDrop: (event) async {},
      child: const ListTile(
          leading: Icon(Icons.add), title: Text("Voeg bronnen toe")),
    );
  }
}

class ValueTile extends StatelessWidget {
  const ValueTile(
      {super.key, required this.title, required this.value, this.onTap});

  final String title;
  final Widget value;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: ListTile(
          onTap: onTap,
          title: Text(title),
          subtitle: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    value,
                  ],
                ),
              ))),
    );
  }
}

class VerticalAverageTile extends StatelessWidget {
  const VerticalAverageTile(
      {super.key,
      required this.name,
      this.value,
      this.onTap,
      this.widgetValue});

  final void Function()? onTap;
  final String name;
  final String? value;
  final Widget? widgetValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          children: [
            widgetValue ??
                GradeAvatar(gradeString: value, enableAnimatedSwitcher: true),
            Text(name),
          ],
        ),
      ),
    );
  }
}

class FilledBar extends StatelessWidget {
  const FilledBar(
      {super.key,
      required this.fromGrade,
      required this.toGrade,
      this.average});

  final double fromGrade;
  final double toGrade;
  final double? average;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 4,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        Row(
          children: [
            const Expanded(flex: (1), child: SizedBox()),
            Expanded(
              flex: (toGrade - fromGrade).toInt(),
              child: Container(
                height: 4,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Expanded(flex: (10 - toGrade).toInt(), child: const SizedBox()),
          ],
        ),
        if (average != null && !average!.isNaN)
          Row(
            children: [
              Expanded(flex: average!.toInt(), child: const SizedBox()),
              Expanded(
                flex: (10 - average!).toInt(),
                child: Transform.translate(
                  offset: const Offset(0, -6),
                  child: SizedBox(
                    height: 4,
                    child: Icon(
                      Icons.circle,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}

class ContactsListTile extends StatefulWidget {
  const ContactsListTile(
      {super.key, required this.title, this.icon, required this.contacts});

  final String title;
  final Icon? icon;
  final List<Contact> contacts;

  @override
  State<ContactsListTile> createState() => _ContactsListTileState();
}

class _ContactsListTileState extends State<ContactsListTile> {
  bool isExp = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        onExpansionChanged: (value) => setState(() {
              isExp = value;
            }),
        leading: const Icon(Icons.group),
        title: Text(widget.title),
        subtitle: !isExp
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: widget.contacts
                        .take(10)
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ContactBadge.fromContact(e),
                            ))
                        .toList()))
            : null,
        children: [
          Wrap(
              children: widget.contacts
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ContactBadge.fromContact(e),
                      ))
                  .toList())
        ]);
  }
}

class TextInputListTile extends StatefulWidget {
  const TextInputListTile(
      {super.key,
      this.title,
      this.leading,
      this.subtitle,
      this.onFocusChange,
      this.hintText});

  final Widget? title;
  final Widget? leading;
  final Widget? subtitle;
  final String? hintText;

  ///In other words the fucntion that will handle the saving the value.
  final Function(String value)? onFocusChange;

  @override
  State<TextInputListTile> createState() => _TextInputListTileState();
}

class _TextInputListTileState extends State<TextInputListTile> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      leading: widget.leading,
      subtitle: widget.subtitle,
      trailing: SizedBox(
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: FocusScope(
                  onFocusChange: (widget.onFocusChange != null)
                      ? (value) {
                          if (!value) {
                            //Callback
                            widget.onFocusChange!.call(controller.text);
                            setState(() {});
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        }
                      : null,
                  child: TextFormField(
                    controller: controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onTapOutside: (event) {},
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: widget.hintText,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
