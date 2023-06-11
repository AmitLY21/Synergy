import 'package:flutter/material.dart';

import '../Helpers/helper.dart';
import '../models/article.dart';
import '../screens/article_page.dart';

Widget articleListTile(Article article, BuildContext context) {
  String formattedDate = Helper().formatPublishedDate(article.publishedAt!);

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticlePage(
            article: article,
          ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          const SizedBox(height: 12.0),
          Text(
            formattedDate,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 12.0),
          if (article.urlToImage != null)
            Stack(
              children: [
                Hero(
                  tag: "articleImage${article.url}",
                  child: Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: NetworkImage(article.urlToImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.0,
                  right: 12.0,
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text(
                      article.source!.name!
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}
