import 'package:flutter/material.dart';

enum TabItem {
  home('Home'),
  favorite('Favorite'),
  contract('Contract'),
  cart('Cart'),
  pay('Pay'),
  setting('Setting');

  const TabItem(this.name);
  // final MaterialColor color;
  final String name;
}
