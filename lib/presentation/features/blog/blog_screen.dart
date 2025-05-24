import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/data/models/blog_model.dart';
import 'package:blood_plus/data/services/blog_service.dart';
import 'package:blood_plus/presentation/features/blog/blog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final BlogService _blogService = BlogService();
  List<BlogModel> blogs = [];
  bool isLoading = false;
  String? errorMessage;
  int currentPage = 1;
  int pageSize = 5;
  bool hasNextPage = false;

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> fetchBlogs({bool loadMore = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _blogService.getBlogs(
        pageNumber: loadMore ? currentPage + 1 : 1,
        pageSize: pageSize,
      );

      setState(() {
        if (loadMore) {
          blogs.addAll(response.items);
          currentPage++;
        } else {
          blogs = response.items;
          currentPage = 1;
        }
        hasNextPage = response.hasNextPage;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text (localizations.translate('blog_title')),
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchBlogs(),
        child: isLoading && blogs.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text(localizations.translate('error_loading_blogs')))
            : blogs.isEmpty
            ? Center(child: Text(localizations.translate('no_blogs')))
            : ListView.builder(
          itemCount: blogs.length + (hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == blogs.length && hasNextPage) {
              if (!isLoading) {
                fetchBlogs(loadMore: true);
              }
              return const Center(child: CircularProgressIndicator());
            }

            final blog = blogs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlogDetailScreen(blog: blog),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (blog.image1 != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                        child: Image.network(
                          blog.image1!,
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            blog.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          if (blog.createdTime != null)
                            Text(
                                  _formatDate(blog.createdTime!),
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
      ),
    );
  }
}
