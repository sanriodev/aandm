import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/note/note_api_model.dart';
import 'package:aandm/util/helpers.dart';
import 'package:blvckleg_dart_core/service/auth_backend_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoteWidget extends StatefulWidget {
  final Note note;
  final void Function()? onTap;
  final void Function()? onDeletePress;
  final void Function(PrivacyMode mode)? onChangePrivacy;

  const NoteWidget({
    super.key,
    required this.note,
    this.onDeletePress,
    this.onTap,
    this.onChangePrivacy,
  });

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned.fill(
            child: Builder(
                builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        color: Colors.red,
                      ),
                    )),
          ),
          Slidable(
              enabled: widget.note.user?.username ==
                  AuthBackend().loggedInUser?.user?.username,
              key: UniqueKey(),
              endActionPane: ActionPane(
                motion: BehindMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(12),
                    onPressed: (_) => widget.onDeletePress?.call(),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                  ),
                ],
              ),
              child: InkWell(
                onTap: widget.onTap,
                child: Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Text(
                                      "Name",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      widget.note.title,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  if (widget.note.content != null &&
                                      widget.note.content!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        "Inhaltsvorschau",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall,
                                      ),
                                    ),
                                  if (widget.note.content != null &&
                                      widget.note.content!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        "${widget.note.content!.length > 40 ? widget.note.content!.substring(0, 40) : widget.note.content}...",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyMedium!
                                          ..copyWith(
                                              overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: PopupMenuButton<PrivacyMode>(
                                enabled: widget.note.user?.username ==
                                    AuthBackend().loggedInUser?.user?.username,
                                tooltip: 'Privatsphäre',
                                onSelected: (mode) =>
                                    widget.onChangePrivacy?.call(mode),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: PrivacyMode.private,
                                    child: Text(
                                        'Privat - nur du kannst sehen/bearbeiten'),
                                  ),
                                  const PopupMenuItem(
                                    value: PrivacyMode.protected,
                                    child: Text(
                                        'Geschützt - alle können sehen, bearbeiten nur du'),
                                  ),
                                  const PopupMenuItem(
                                    value: PrivacyMode.public,
                                    child: Text(
                                        'Öffentlich - alle können sehen/bearbeiten'),
                                  ),
                                ],
                                child: Icon(
                                  privacyIconFor(widget.note.privacyMode),
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, bottom: 8, right: 6),
                              child: PhosphorIcon(
                                PhosphorIconsRegular.user,
                                size: 16,
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 12, bottom: 8),
                              child: Text(
                                widget.note.user != null
                                    ? widget.note.user!.username
                                    : "unknown",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodySmall,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, bottom: 8, right: 6),
                              child: PhosphorIcon(
                                PhosphorIconsRegular.pencil,
                                size: 16,
                                color: Theme.of(context).primaryIconTheme.color,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 12, bottom: 8),
                              child: Text(
                                widget.note.lastModifiedUser != null
                                    ? widget.note.lastModifiedUser!.username
                                    : "unknown",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              )),
        ],
      ),
    );
  }
}
