import 'package:flutter/material.dart';
import 'package:trakli/presentation/utils/forms/add_party_form.dart';

class AddPartyDialog extends StatelessWidget {
  const AddPartyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      //  backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      // child: const AddPartyForm(
      //   showClose: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Party',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const AddPartyForm(),
          ],
        ),
      ),
    );
  }
}
