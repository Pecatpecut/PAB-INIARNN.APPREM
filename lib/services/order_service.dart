import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  /// 🔥 CREATE ORDER (SUDAH BAGUS, TIDAK PERLU DIUBAH)
  Future<void> createOrder({
    required String userId,
    required Map product,
    required Map variant,
    required String email,
  }) async {
    await supabase.from('orders').insert({
      "user_id": userId,
      "product_id": product["id"], // 🔥 penting (relasi)
      "variant_id": variant["id"], // 🔥 penting (relasi)
      "product_name": product["name"],
      "variant_type": variant["type"],
      "duration_days": variant["duration_days"],
      "price": variant["price"],
      "account_email": email,
      "status": "pending",
    });
  }

  /// 🔥 GET ORDERS (SUDAH INCLUDE IMAGE DARI PRODUCTS)
  Future<List<Map<String, dynamic>>> getOrders() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final data = await supabase
        .from('orders')
        .select('*, products(image)') // 🔥 INI KUNCINYA
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  /// 🔥 APPROVE ORDER (MANUAL INPUT ACCOUNT)
Future<void> approveOrderManual({
  required String orderId,
  required String email,
  required String password,
}) async {
  await supabase.from('orders').update({
    "status": "approved",
    "account_email": email,
    "account_password": password,
  }).eq('id', orderId);
}

/// 🔥 UPDATE STATUS ORDER (REJECT / DLL)
Future<void> updateOrderStatus(String id, String status) async {
  await supabase
      .from('orders')
      .update({'status': status})
      .eq('id', id);
}
  
}