import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:synergy/Helpers/helper.dart';

import '../models/article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publishDate = Helper().formatPublishedDate(article.publishedAt!);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
          softWrap: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "articleImage${article.url}",
              child: Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article.urlToImage!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.source!.name!,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    article.title!,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    article.description!,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Published: $publishDate',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ReadMoreText(
                    article.content!,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: '\nShow more',
                    trimExpandedText: '\nShow less',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                    moreStyle: const TextStyle(
                        fontSize: 16, color: Colors.deepPurpleAccent),
                    lessStyle: const TextStyle(
                        fontSize: 16, color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
