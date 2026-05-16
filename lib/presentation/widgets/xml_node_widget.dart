import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class XmlNodeWidget extends StatelessWidget {
  final XmlElement element;
  final int depth;

  const XmlNodeWidget({super.key, required this.element, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: depth * 20.0),
          child: Row(
            children: [
              const Icon(Icons.code, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                "<${element.localName}>",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              Text(
                element.attributes.map((a) => ' ${a.name}="${a.value}"').join(),
                style: const TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
        ),
        ...element.children.whereType<XmlElement>().map(
          (child) => XmlNodeWidget(element: child, depth: depth + 1),
        ),
      ],
    );
  }
}
