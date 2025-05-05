import 'package:flutter/material.dart';
import 'package:huops/widgets/busy_indicator.dart';
import 'package:huops/widgets/states/loading.shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomLoadingStateView extends StatelessWidget {
  const CustomLoadingStateView({
    required this.child,
    this.loading = false,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return loading?LoadingShimmer().centered(): child;
  }
}
