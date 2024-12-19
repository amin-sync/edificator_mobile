import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/cupertino.dart';

import 'loader.dart';

class GenericList<T> extends StatelessWidget {
  final bool isLoading;
  final List<T>? items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final EdgeInsetsGeometry padding;

  const GenericList({
    Key? key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    this.emptyMessage = "No items available",
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Loader();
    }

    if (items == null || items!.isEmpty) {
      return Center(
        child: CustomText(
          text: emptyMessage,
          fontSize: 16,
          color: MyColor.tealColor,
        ),
      );
    }

    return ListView.builder(
      itemCount: items!.length,
      itemBuilder: (context, index) => itemBuilder(context, items![index]),
    );
  }
}
