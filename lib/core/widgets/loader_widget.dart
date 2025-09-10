import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final double? radius;
  const LoaderWidget({
    super.key,
    required this.child,
    this.isLoading = false,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
              child: WillPopScope(
                  onWillPop: () async => !isLoading,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(radius ?? 0),
                      ),
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 1)
                                ]),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator())),
                      )))),
      ],
    );
  }
}
