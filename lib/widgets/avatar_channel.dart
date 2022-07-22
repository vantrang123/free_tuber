import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../ui/components/shimmer_container.dart';

class AvatarChannel extends StatelessWidget {
  final String? url;

  AvatarChannel({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty)
      return ShimmerContainer(
        height: 50,
        width: 50,
        borderRadius: BorderRadius.circular(100),
      );
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: FadeInImage(
          fadeInDuration: Duration(milliseconds: 300),
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(url!),
          imageErrorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return ShimmerContainer(
              height: 50,
              width: 50,
              borderRadius: BorderRadius.circular(100),
            );
          },
          height: 50,
          width: 50,
          fit: BoxFit.cover),
    );
  }
}
