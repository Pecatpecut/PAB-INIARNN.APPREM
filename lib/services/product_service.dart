import 'supabase_service.dart';

class ProductService {
  final supabase = SupabaseService.client;

  Future<List<Map<String, dynamic>>> getProducts({String? category}) async {
    var query = supabase.from('products').select('''
      id,
      name,
      description,
      image,
      is_active,
      category,
      product_variants (
        id,
        type,
        price,
        duration_days
      )
    ''').eq('is_active', true);

    if (category != null && category != 'All') {
    query = query.eq('category', category);
  }

    return List<Map<String, dynamic>>.from(await query);
  }
}