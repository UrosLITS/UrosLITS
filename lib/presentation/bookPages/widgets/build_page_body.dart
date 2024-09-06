import 'dart:io';

import 'package:book/models/book/book_imports.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/cupertino.dart';

class LandscapeImage extends StatelessWidget {
  LandscapeImage({
    required this.bookPageImage,
    required this.bookPagesList,
    required this.currentIndex,
  });

  final List<BookPages> bookPagesList;
  final int currentIndex;
  final BookPageImage bookPageImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatColumn(
        children: [
          SizedBox(
            height: 10,
          ),
          Floatable(
            float: FCFloat.start,
            child: Container(),
          ),
          Floatable(
            clearMinSpacing: MediaQuery.of(context).size.height * 0.52,
            padding: EdgeInsets.only(right: 8),
            float: FCFloat.start,
            maxWidthPercentage: 0.5,
            clear: FCClear.both,
            child: bookPageImage.url != null
                ? Image.network(bookPageImage.url!)
                : Image.file(
                    File(bookPageImage.filePath!),
                  ),
          ),
          WrappableText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: bookPagesList[currentIndex].text,
            ),
          ),
        ],
      ),
    );
  }
}

class PortraitImage extends StatelessWidget {
  PortraitImage({
    required this.bookPageImage,
    required this.bookPagesList,
    required this.currentIndex,
  });

  final BookPageImage bookPageImage;
  final List<BookPages> bookPagesList;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatColumn(
        children: [
          SizedBox(height: 10),
          Floatable(
              clearMinSpacing: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.only(right: 8),
              float: FCFloat.start,
              maxWidthPercentage: 0.5,
              clear: FCClear.both,
              child: bookPageImage.url != null
                  ? Image.network(bookPageImage.url!)
                  : Image.file(File(bookPageImage.filePath!))),
          WrappableText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: bookPagesList[currentIndex].text,
            ),
          ),
        ],
      ),
    );
  }
}

class NoImage extends StatelessWidget {
  final List<BookPages> bookPagesList;
  final int currentIndex;

  NoImage({
    required this.bookPagesList,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 10),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            bookPagesList[currentIndex].text,
            textAlign: TextAlign.justify,
          ),
        )
      ],
    );
  }
}
