import 'package:book/models/book/book_imports.dart';
import 'package:flutter/material.dart';

class ChapterListView extends StatefulWidget {
  ChapterListView(
      {Key? key,
      required this.bookpages,
      required this.bookchaptersList,
      required this.onPagePressed})
      : super(key: key);

  final List<BookPage> bookpages;
  final List<BookChapter> bookchaptersList;
  final ValueChanged<int> onPagePressed;

  State<ChapterListView> createState() => _ChapterListView();
}

class _ChapterListView extends State<ChapterListView> {
  int? expandedChNumber;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
      itemCount: widget.bookchaptersList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildChapter(context,
            bookChapter: widget.bookchaptersList[index],
            chPages: exctractPagesForCh(widget.bookchaptersList[index]));
      },
    );
  }

  List<BookPage> exctractPagesForCh(BookChapter bookChapter) {
    return widget.bookpages
        .where((page) => page.bookChapter?.chNumber == bookChapter.chNumber)
        .toList();
  }

  ExpansionTile buildChapter(BuildContext context,
      {required BookChapter bookChapter, required List<BookPage> chPages}) {
    return ExpansionTile(
        shape: Border(
            top: BorderSide(
              color: Colors.transparent,
            ),
            bottom: BorderSide(
              width: 1,
              color: Colors.black,
            )),
        key: UniqueKey(),
        initiallyExpanded: expandedChNumber == bookChapter.chNumber,
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            expandedChNumber = bookChapter.chNumber;
          } else {
            expandedChNumber = null;
          }
          setState(() {});
        },
        title: Text(bookChapter.chTitle!),
        children: chPages
            .map((page) => ListTile(
                  title: Text(
                    page.pageNumber.toString() + "  " + page.text,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    widget.onPagePressed(page.pageNumber);
                  },
                ))
            .toList());
  }
}
