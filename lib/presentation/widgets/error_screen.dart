import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final String text;
  final String redirectRoute;
  final IconData iconData;
  final String buttonText;

  const ErrorScreen(
      {super.key,
      required this.text,
      required this.redirectRoute,
      required this.buttonText,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: height * 0.1,
              color: colors.error,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                    color: colors.error,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: height * 0.02,
            ),
            FilledButton(
                onPressed: () => context.go(redirectRoute),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
                child: Text(
                  buttonText,
                    style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: textTheme.bodyMedium!.fontSize,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
