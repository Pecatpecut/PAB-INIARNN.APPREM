import 'package:supabase_flutter/supabase_flutter.dart';

class ClaimsService {
  final supabase = Supabase.instance.client;

  /// 🔥 CREATE CLAIM
  Future<void> createClaim({
    required String orderId,
    required String userId,
    required String description,
    String? imageUrl,
  }) async {
    await supabase.from('claims').insert({
      "order_id": orderId,
      "user_id": userId,
      "problem_description": description,
      "proof_image": imageUrl,
      "status": "pending",
    });
  }

  /// 🔥 GET USER CLAIMS
  Future<List<Map<String, dynamic>>> getUserClaims() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final data = await supabase
        .from('claims')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  /// 🔥 GET CLAIM BY ORDER
  Future<List<Map<String, dynamic>>> getClaimsByOrder(
      String orderId) async {
    final data = await supabase
        .from('claims')
        .select()
        .eq('order_id', orderId);

    return List<Map<String, dynamic>>.from(data);
  }
}