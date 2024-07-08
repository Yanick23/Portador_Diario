import 'package:flutter/material.dart';

class OptionFavoritePage extends StatelessWidget {
  final String text;
  final Color colorText;
  final Icon? iconsRow_1;
  final Widget iconOrText;
  final Color? colorIcon;
  final void jj;
  const OptionFavoritePage({
    super.key,
    required this.text,
    required this.colorText,
    this.iconsRow_1,
    required this.iconOrText,
    this.colorIcon,
    this.jj,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (iconsRow_1 != null) iconsRow_1!,
              if (iconsRow_1 != null)
                const SizedBox(
                  width: 20,
                ),
              Text(
                text,
                style: TextStyle(color: colorText, fontSize: 17),
              )
            ],
          ),
          iconOrText
        ],
      ),
    );
  }
}
