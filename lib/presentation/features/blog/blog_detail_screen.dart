import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/data/models/blog_model.dart';
import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final imageList = [blog.image1, blog.image2, blog.image3, blog.image4].whereType<String>().toList();
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: const TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Xen kẽ ảnh và đoạn văn
            for (int i = 0; i < imageList.length; i++) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  imageList[i],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(height: 12),
              if (i == 0)
                Text(
                  blog.description,
                  style: const TextStyle(fontSize: 19, height: 1.5),
                )
              else if (i == 1)
                Text(
                  blog.content.substring(0, (blog.content.length ~/ 2)),
                  style: const TextStyle(fontSize: 18, height: 1.5),
                )
              else if (i == 2)
                  Text(
                    blog.content.substring((blog.content.length ~/ 2)),
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
              const SizedBox(height: 16),
            ],

            // Nếu còn nội dung thừa
            if (imageList.length < 3)
              Text(
                blog.content.isEmpty
                    ? localizations.translate('no_content')
                    : blog.content, // Xử lý đa ngôn ngữ nếu cần
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            const SizedBox(height: 16),
            if (blog.author != null)
              Text(
                localizations.translate('author_label').replaceAll('{author}', blog.author!),
                style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 8),
            Text(
              localizations.translate('views_label').replaceAll('{views}', blog.viewNumber.toString()),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
