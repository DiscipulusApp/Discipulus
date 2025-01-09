import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';

class NextHomeWokeTile extends StatefulWidget {
  const NextHomeWokeTile({super.key});

  @override
  State<NextHomeWokeTile> createState() => _NextHomeWokeTileState();
}

class _NextHomeWokeTileState extends State<NextHomeWokeTile> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PageView.builder(
        itemBuilder: (context, index) => const Placeholder(),
      ),
    );
  }
}
