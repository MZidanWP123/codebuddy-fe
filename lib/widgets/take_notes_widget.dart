import 'package:flutter/material.dart';

class TakeNotesWidget extends StatefulWidget {
  final Function(String) onSave;
  final VoidCallback onCancel;

  const TakeNotesWidget({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<TakeNotesWidget> createState() => _TakeNotesWidgetState();
}

class _TakeNotesWidgetState extends State<TakeNotesWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasUnsavedChanges = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Take Notes!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (_hasUnsavedChanges) {
                    _showUnsavedChangesDialog();
                  } else {
                    widget.onCancel();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              onChanged: (value) {
                setState(() {
                  _hasUnsavedChanges = value.trim().isNotEmpty;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Ketik catatan disini...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => widget.onSave(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D2A44),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Notes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved changes'),
        content: const Text('Do you want to save or discard changes?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onCancel();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onSave(_controller.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D2A44),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
