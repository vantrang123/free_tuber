import 'package:flutter/material.dart';

import '../constants/strings.dart';

class SearchBarLogo extends StatelessWidget {
  final VoidCallback onClickSearchLogo;

  SearchBarLogo(this.onClickSearchLogo);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClickSearchLogo(),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                DateTime.now().month == 12
                    ? 'assets/images/logo_christmas.png'
                    : 'assets/images/ic_launcher.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Expanded(
              child: IgnorePointer(
                ignoring: true,
                child: Text(Strings.appName,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.color
                          ?.withOpacity(0.6),
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
