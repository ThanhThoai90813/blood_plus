import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/data/models/blog_model.dart';
import 'package:blood_plus/data/services/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BlogDetailScreen extends StatefulWidget {
  final String blogId;

  const BlogDetailScreen({super.key, required this.blogId});

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> with TickerProviderStateMixin {
  final BlogService _blogService = BlogService();
  BlogModel? blog;
  bool isLoading = true;
  String? errorMessage;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool isLiked = false;
  bool isBookmarked = false;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
    fetchBlog();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final maxOffset = 200.0;
      setState(() {
        _appBarOpacity = (offset / maxOffset).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchBlog() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedBlog = await _blogService.getBlogById(widget.blogId);
      setState(() {
        blog = fetchedBlog;
        isLoading = false;
      });

      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Đang tải bài viết...',
              style: AppTheme.bodyLarge.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildCustomAppBar(title: 'Chi tiết bài viết'),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.error_outline_rounded, color: Colors.red, size: 50),
              ),
              const SizedBox(height: 20),
              Text(
                'Không thể tải bài viết',
                style: AppTheme.headingMedium.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Vui lòng kiểm tra kết nối và thử lại',
                style: AppTheme.bodyMedium.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Thử lại',
                      color: AppColors.primaryRed,
                      textColor: Colors.white,
                      onPressed: fetchBlog,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      borderRadius: 12,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomButton(
                      text: 'Quay lại',
                      color: Colors.grey[300]!,
                      textColor: Colors.grey[700]!,
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      borderRadius: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar({String? title}) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(_appBarOpacity),
      elevation: _appBarOpacity > 0.5 ? 4 : 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _appBarOpacity > 0.5 ? Colors.transparent : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: _appBarOpacity > 0.5 ? Colors.black : Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: AnimatedOpacity(
        opacity: _appBarOpacity,
        duration: const Duration(milliseconds: 200),
        child: Text(
          title ?? (blog?.title ?? ''),
          style: AppTheme.headingMedium.copyWith(
            color: Colors.black,
            fontSize: 18,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _appBarOpacity > 0.5 ? Colors.transparent : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _appBarOpacity > 0.5
                  ? (isBookmarked ? AppColors.primaryRed : Colors.black)
                  : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _appBarOpacity > 0.5 ? Colors.transparent : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.share_rounded,
              color: _appBarOpacity > 0.5 ? Colors.black : Colors.white,
            ),
            onPressed: () {
              // Share functionality
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    if (blog?.image1 == null) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.grey[100]!],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_rounded, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text('Không có hình ảnh', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    return Hero(
      tag: 'blog_image_${blog!.id}',
      child: Container(
        height: 300,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              blog!.image1!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[200]!, Colors.grey[100]!],
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[200]!, Colors.grey[100]!],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    Text('Không thể tải ảnh', style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          if (blog!.createdTime != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded, size: 16, color: AppColors.primaryRed),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(blog!.createdTime!),
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility_rounded, size: 16, color: Colors.blue[300]),
                const SizedBox(width: 6),
                Text(
                  '${blog!.viewNumber} Views',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    final imageList = [blog!.image1, blog!.image2, blog!.image3, blog!.image4]
        .whereType<String>()
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  blog!.title,
                  style: AppTheme.headingLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 15),
                Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.primaryRed.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

          // Description
          if (blog!.description.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: AutoSizeText(
                blog!.description,
                style: AppTheme.bodyLarge.copyWith(
                  height: 1.6,
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Content with images
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (blog!.content.isNotEmpty) ...[
                  _buildContentWithImages(imageList),
                ] else if (imageList.length > 1) ...[
                  for (int i = 1; i < imageList.length; i++) ...[
                    _buildImageSection(imageList[i]),
                    if (i < imageList.length - 1) const SizedBox(height: 20),
                  ],
                ],
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildContentWithImages(List<String> imageList) {
    if (blog!.content.isEmpty) return Container();

    final contentParts = _splitContent(blog!.content, imageList.length - 1);

    return Column(
      children: [
        for (int i = 0; i < contentParts.length; i++) ...[
          if (contentParts[i].isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: AutoSizeText(
                contentParts[i],
                style: AppTheme.bodyMedium.copyWith(
                  height: 1.7,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          if (i < imageList.length - 1 && i + 1 < imageList.length) ...[
            const SizedBox(height: 20),
            _buildImageSection(imageList[i + 1]),
            const SizedBox(height: 20),
          ],
        ],
      ],
    );
  }

  List<String> _splitContent(String content, int parts) {
    if (parts <= 0) return [content];

    final words = content.split(' ');
    final wordsPerPart = (words.length / (parts + 1)).ceil();

    List<String> result = [];
    for (int i = 0; i <= parts; i++) {
      final start = i * wordsPerPart;
      final end = ((i + 1) * wordsPerPart).clamp(0, words.length);
      if (start < words.length) {
        result.add(words.sublist(start, end).join(' '));
      }
    }
    return result;
  }

  Widget _buildImageSection(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[200]!, Colors.grey[100]!],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[200]!, Colors.grey[100]!],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text('Không thể tải ảnh', style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(isLiked),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: Text(
                  isLiked ? 'Like' : '...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLiked ? AppColors.primaryRed : Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: isLiked ? 8 : 2,
                  shadowColor: isLiked ? AppColors.primaryRed.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // Comment functionality
              },
              icon: Icon(Icons.comment_outlined, color: Colors.grey[600]),
              padding: const EdgeInsets.all(15),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // Share functionality
              },
              icon: Icon(Icons.share_rounded, color: Colors.grey[600]),
              padding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingScreen();
    }

    if (errorMessage != null) {
      return _buildErrorScreen();
    }

    if (blog == null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: _buildCustomAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroImage(),
                      _buildMetaInfo(),
                      const SizedBox(height: 10),
                      _buildContentSection(),
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}