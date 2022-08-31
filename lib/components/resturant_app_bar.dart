import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RestaurantAppBar extends StatelessWidget {
  const RestaurantAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/images/Header-image.png',
          fit: BoxFit.cover,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset('assets/icons/back.svg'),
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            'assets/icons/share.svg',
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
