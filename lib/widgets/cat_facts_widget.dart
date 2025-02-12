import 'package:aandm/models/cat_facts_api_model.dart';
import 'package:aandm/models/cat_picture_api_model.dart';
import 'package:flutter/material.dart';

class CatPreviewWidget extends StatelessWidget {
  final List<CatFactsApiModel> catFacts;
  final List<CatPictureApiModel> catPictures;

  const CatPreviewWidget({required this.catFacts, required this.catPictures});

  @override
  Widget build(BuildContext context) {
    if (catFacts.isNotEmpty || catPictures.isNotEmpty) {
      return getPageView(context);
    } else {
      return Container();
    }
  }

  Widget getPageView(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Define a breakpoint for tablet screens
    const tabletBreakpoint = 600.0;

    // Adjust sizing based on device width
    final isTablet = width > tabletBreakpoint;
    final itemWidth = isTablet
        ? width / 4
        : (catFacts.length > 1 ? width / 1.1 : width / 1.07);

    return SizedBox(
      height: 320, // Overall height of the ListView
      child: ListView.builder(
        itemCount: catFacts.length > catPictures.length
            ? catFacts.length
            : catPictures.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: itemWidth,
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
              margin: const EdgeInsets.all(4),
              elevation: 3,
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (catPictures.elementAtOrNull(index)?.url != null)
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Image.network(
                          catPictures[index].url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'lustiger Fakt',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleSmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                catFacts.length > index
                                    ? '${catFacts.elementAtOrNull(index)?.updatedAt.day.toString().padLeft(2, '0')}.${catFacts[index].updatedAt.month.toString().padLeft(2, '0')}.${catFacts[index].updatedAt.year}'
                                    : '',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleSmall,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            catFacts.elementAtOrNull(index)?.text ??
                                'Kein Fakt gefunden',
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
