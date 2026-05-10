import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class FileSelectorCard extends StatefulWidget {
  final String title;
  final String description;
  final String? path;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final ValueSetter<String> onFileDropped;

  const FileSelectorCard({
    super.key,
    required this.title,
    required this.description,
    required this.path,
    required this.onTap,
    required this.icon,
    required this.color,
    required this.onFileDropped,
  });

  @override
  State<FileSelectorCard> createState() => _FileSelectorCardState();
}

class _FileSelectorCardState extends State<FileSelectorCard> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropTarget(
      onDragEntered: (details) => setState(() => _isDragging = true),
      onDragExited: (details) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        if (details.files.isNotEmpty) {
          final file = details.files.first;
          widget.onFileDropped(file.path);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isDragging ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Card(
          elevation: _isDragging ? 8 : 2,
          child: ListTile(
            onTap: widget.onTap,
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: widget.path == null
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.tertiaryContainer,
              child: Icon(
                widget.icon,
                color: widget.path == null
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: SizedBox(
              height: 40,
              child: Text(
                widget.path != null
                    ? widget.path!.split(Platform.pathSeparator).last
                    : widget.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Icon(
              widget.path == null ? Icons.add_circle_outline : Icons.sync,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
