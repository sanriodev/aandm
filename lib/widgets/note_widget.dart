import 'package:aandm/enum/privacy_mode_enum.dart';
import 'package:aandm/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NoteWidget extends StatefulWidget {
  final String name;
  final String content;
  final PrivacyMode privacyMode;
  final void Function()? onTap;
  final void Function()? onDeletePress;
  final void Function(PrivacyMode mode)? onChangePrivacy;

  final User? author;
  final User? lastModifiedUser;

  const NoteWidget(
      {super.key,
      required this.name,
      required this.content,
      required this.privacyMode,
      this.onDeletePress,
      this.onTap,
      this.onChangePrivacy,
      this.author,
      this.lastModifiedUser});

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
              key: UniqueKey(),
              endActionPane: ActionPane(
                motion: BehindMotion(),
                extentRatio: 0.3,
                children: [
                  SlidableAction(
                    borderRadius: BorderRadius.circular(5),
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
                                      widget.name,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  if (widget.content.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        "Inhaltsvorschau",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall,
                                      ),
                                    ),
                                  if (widget.content.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        "${widget.content.length > 40 ? widget.content.substring(0, 40) : widget.content}...",
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
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(left: 12, right: 12),
                            //   child: PopupMenuButton<PrivacyMode>(
                            //     tooltip: 'Privatsphäre',
                            //     onSelected: (mode) =>
                            //         widget.onChangePrivacy?.call(mode),
                            //     itemBuilder: (context) => [
                            //       const PopupMenuItem(
                            //         value: PrivacyMode.private,
                            //         child: Text('Privat'),
                            //       ),
                            //       const PopupMenuItem(
                            //         value: PrivacyMode.protected,
                            //         child: Text('Geschützt'),
                            //       ),
                            //       const PopupMenuItem(
                            //         value: PrivacyMode.public,
                            //         child: Text('Öffentlich'),
                            //       ),
                            //     ],
                            //     child: Icon(
                            //       privacyIconFor(widget.privacyMode),
                            //       color:
                            //           Theme.of(context).primaryIconTheme.color,
                            //     ),
                            //   ),
                            // ),
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
                                widget.author != null
                                    ? widget.author!.username
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
                                widget.lastModifiedUser != null
                                    ? widget.lastModifiedUser!.username
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
