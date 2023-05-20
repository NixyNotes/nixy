import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:nextcloudnotes/components/future_builder.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/note/controllers/note-view.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@RoutePage()
class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.noteId});

  final int noteId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class CheckBoxBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Text("test", style: preferredStyle);
  }
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
              child: MarkdownAutoPreview(
                key: key,
                controller: controller.markdownController,
                toolbarBackground: Theme.of(context).colorScheme.background,
                onChanged: (value) {
                  Future.delayed(const Duration(seconds: 2),
                      () => controller.updateNote(data?.id ?? 0, data!));
                },
              ),
            ));
      },
    );
  }
}
