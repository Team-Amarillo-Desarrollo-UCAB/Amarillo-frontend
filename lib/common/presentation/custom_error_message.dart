import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackbarUtil {
  static void showAwesomeSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: AwesomeSnackbarContent(
            title: title,
            message: message,
            contentType: contentType,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

class AwesomeSnackBarExample extends StatelessWidget {
  const AwesomeSnackBarExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text('Show Awesome SnackBar - Failure'),
              onPressed: () {
                SnackbarUtil.showAwesomeSnackBar(
                  context: context,
                  title: 'On Snap!',
                  message:
                      'This is an example error message that will be shown in the body of snackbar!',
                  contentType: ContentType.failure,
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Show Awesome SnackBar - Success'),
              onPressed: () {
                SnackbarUtil.showAwesomeSnackBar(
                  context: context,
                  title: 'Oh Hey!!',
                  message:
                      'This is an example success message for the snackbar!',
                  contentType: ContentType.success,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
