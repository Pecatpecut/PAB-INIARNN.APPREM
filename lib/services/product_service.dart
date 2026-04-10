import 'supabase_service.dart';

class ProductService {
  final supabase = SupabaseService.client;

  /// 🔥 GET PRODUCTS + VARIANTS
  Future<List<Map<String, dynamic>>> getProducts() async {
    final data = await supabase.from('products').select('''
      id,
      name,
      description,
      image,
      is_active,
      product_variants (
        id,
        type,
        price,
        duration_days
      )
    ''').eq('is_active', true);

    return List<Map<String, dynamic>>.from(data);
  }
}