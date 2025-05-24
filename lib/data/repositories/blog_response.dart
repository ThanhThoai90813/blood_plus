import '../models/blog_model.dart';

//Đại diện cho toàn bộ kết quả trả về từ API blog: Danh sách blog
// Thông tin phân trang (page, total, v.v...)

class BlogResponse {
  final List<BlogModel> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  BlogResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>? ?? {};
    List<dynamic>? itemsData;

    print('message: $message');

    if (message['items'] is List) {
      itemsData = message['items'] as List<dynamic>?;
      print('items is List: $itemsData');
    } else if (message['items'] is Map) {
      final itemsMap = message['items'] as Map<String, dynamic>? ?? {};
      itemsData = itemsMap[r'$values'] as List<dynamic>?;
      print('items is Map, key \$values: $itemsData');
    }

    final itemsList = itemsData?.map((item) => BlogModel.fromJson(item as Map<String, dynamic>)).toList() ?? [];
    print('itemsList: $itemsList');

    return BlogResponse(
      items: itemsList,
      totalItems: (message['totalItems'] as num?)?.toInt() ?? 0,
      currentPage: (message['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (message['totalPages'] as num?)?.toInt() ?? 0,
      pageSize: (message['pageSize'] as num?)?.toInt() ?? 0,
      hasPreviousPage: message['hasPreviousPage'] as bool? ?? false,
      hasNextPage: message['hasNextPage'] as bool? ?? false,
    );
  }

}