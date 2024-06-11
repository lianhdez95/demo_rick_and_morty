import 'package:flutter/material.dart';

class Loading extends StatelessWidget {

  final double? sizePercent;
  final double? fontSize;
  final double? borderRadiusPercent;
  final String? text;

  const Loading({
    super.key, 
    this.sizePercent, 
    this.fontSize, 
    this.text, 
    this.borderRadiusPercent
  });

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: sizePercent != null ? height * sizePercent! / 100 : height * 0.3,
              width: sizePercent != null ? height * sizePercent! / 100 : height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height * 0.03),
              ),
              child: ClipRRect(
                borderRadius: borderRadiusPercent != null ? BorderRadius.circular(height * borderRadiusPercent!/100) : BorderRadius.circular(height * 0.03),
                child: Image.asset(
                  'assets/images/rick_loading.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              text ?? 'Cargando datos...',
              style: TextStyle(
                  fontSize: fontSize ?? textTheme.headlineLarge!.fontSize,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
