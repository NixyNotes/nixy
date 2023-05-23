import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:nextcloudnotes/components/future_builder.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/note/controllers/note-view.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nixi_markdown/formatters/newline_formatter.dart';

@RoutePage()
class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.noteId});

  final int noteId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final controller = getIt<NoteViewController>();
  bool editMode = false;
  GlobalKey key = GlobalKey();
  @override
  void initState() {
    super.initState();
    controller.fetchNote(widget.noteId);
  }

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder<Note>(
      future: controller.fetchNote(widget.noteId),
      child: (data) {
        controller.markdownController.text = data?.content ?? "se";

        return AppScaffold(
            title: data?.title,
            actions: [
              IconButton(
                  onPressed: () {
                    controller
                        .deleteNote(data?.id ?? 0)
                        .then((value) => context.router.back());
                  },
                  icon: const Icon(EvaIcons.trash2Outline)),
            ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SelectableText(data!.modified.toString()),
                  Text(DateFormat("yyyy-MM-dd HH:mm").format(
                      DateTime.utc(1970, 1, 1)
                          .add(const Duration(seconds: 1684543279)))),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        editMode = !editMode;
                      });
                    },
                    child: editMode
                        ? TextField(
                            maxLines: null,
                            controller: controller.markdownController,
                            inputFormatters: [NewlineFormatter()],
                            onChanged: (value) {
                              Future.delayed(const Duration(seconds: 2),
                                  () => controller.updateNote(data.id, data));
                            },
                          )
                        : Markdown(data: data.content),
                  )
                ],
              ),
            ));
      },
    );
  }
}
