import 'package:flutter/material.dart';

import 'dialog_box_item.dart';

class DialogBoxSectionType extends StatelessWidget {
  final List<DialoBoxItem> listitems;
  final String title;

  const DialogBoxSectionType({
    super.key,
    this.listitems = const [],
    this.title = "Select Section Type",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.view_list_outlined, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Item List
            Expanded(
              child: ListView.separated(
                itemCount: listitems.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, thickness: 0.6),
                itemBuilder: (context, index) {
                  switch (listitems[index]) {
                    case ItemWithGoto(name: String name, goTo: Function goTo):
                      return InkWell(
                        onTap: () {
                          goTo();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.folder_open_outlined,
                                  size: 20, color: Colors.blueGrey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  size: 20, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    case SelectImageWithBlocEvent(
                        name: String name,
                        addEvent: Function addEvent
                      ):
                      return InkWell(
                        onTap: () {
                          addEvent();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.folder_open_outlined,
                                  size: 20, color: Colors.blueGrey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  size: 20, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
