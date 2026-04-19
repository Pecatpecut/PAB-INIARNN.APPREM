import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  Map? subscription;
  bool isLoadingSubs = true;

  // ✅ Animasi konsisten dengan halaman lain
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data = ModalRoute.of(context)?.settings.arguments as Map?;
    if (data != null) _fetchSubscription(data['id']);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchSubscription(String orderId) async {
    try {
      final data = await supabase
          .from('subscriptions')
          .select()
          .eq('order_id', orderId)
          .maybeSingle();

      if (!mounted) return;
      setState(() {
        subscription = data;
        isLoadingSubs = false;
      });
      _animController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingSubs = false);
      _animController.forward();
    }
  }

  String _formatDate(String? raw) {
    if (raw == null) return '-';
    final date = DateTime.tryParse(raw);
    if (date == null) return '-';
    return "${date.day}/${date.month}/${date.year}";
  }

  // ✅ SnackBar konsisten dengan halaman lain
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final data = ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }

    // ── Data parsing ──────────────────────────
    final productName = data["product_name"] ?? "-";
    final variant = data["variant_type"] ?? "-";
    final price = data["price"] ?? 0;
    final status = data["status"] ?? "pending";
    final email = data["account_email"] ?? "-";
    final password = data["account_password"] ?? "-";
    final imageUrl =
        data['products'] != null ? data['products']['image'] : null;

    final createdAt =
        DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now();
    final duration = data['duration_days'] ?? 30;
    final endDate = createdAt.add(Duration(days: duration));
    final now = DateTime.now();

    int remaining = endDate.difference(now).inDays;
    if (remaining < 0) remaining = 0;

    final isApproved = status == 'approved';
    final isPending = status == 'pending';
    final isExpired = isApproved && remaining == 0;
    final isActive = isApproved && remaining > 0;

    double progress = duration > 0 ? (remaining / duration) : 0;
    if (progress < 0) progress = 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF0A0A14),
                    const Color(0xFF111124),
                    theme.colorScheme.primary.withValues(alpha: 0.18),
                  ]
                : [
                    Colors.white,
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // ─────────────────────────────
              // APPBAR CUSTOM
              // ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Order Detail",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 38),
                  ],
                ),
              ),

              // ─────────────────────────────
              // CONTENT
              // ─────────────────────────────
              Expanded(
                child: isLoadingSubs
                    ? Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                          strokeWidth: 2.5,
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 4,
                            ),
                            children: [

                              // ─────────────────────
                              // HEADER CARD — Product
                              // ─────────────────────
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [
                                            const Color(0xFF1B1B2F),
                                            const Color(0xFF23233A),
                                          ]
                                        : [
                                            Colors.white,
                                            Colors.grey.shade50,
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.07)
                                        : Colors.black.withValues(alpha: 0.04),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.black.withValues(alpha: 0.3)
                                          : Colors.black.withValues(alpha: 0.07),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [

                                    // Thumbnail produk
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: isDark
                                            ? Colors.white.withValues(alpha: 0.07)
                                            : Colors.grey.shade100,
                                        border: Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.15),
                                        ),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: imageUrl != null &&
                                              imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Icon(
                                                Icons.image_not_supported_outlined,
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withValues(alpha: 0.3),
                                              ),
                                            )
                                          : Icon(
                                              Icons.inventory_2_outlined,
                                              color: theme.colorScheme.primary
                                                  .withValues(alpha: 0.5),
                                            ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      productName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 12),

                                    // Status badge
                                    _statusBadge(
                                      isActive: isActive,
                                      isPending: isPending,
                                      isExpired: isExpired,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ─────────────────────
                              // TIME REMAINING
                              // ─────────────────────
                              _sectionCard(
                                isDark: isDark,
                                theme: theme,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _sectionLabel("TIME REMAINING", theme),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          isPending
                                              ? "Menunggu Aktivasi"
                                              : isExpired
                                                  ? "Expired"
                                                  : "$remaining",
                                          style: TextStyle(
                                            fontSize: isPending || isExpired
                                                ? 16
                                                : 28,
                                            fontWeight: FontWeight.bold,
                                            color: isExpired
                                                ? Colors.redAccent
                                                : theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        if (isActive) ...[
                                          const SizedBox(width: 4),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Text(
                                              "hari tersisa",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Progress bar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: isPending ? 0 : progress,
                                        minHeight: 7,
                                        backgroundColor: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.08)
                                            : Colors.black
                                                .withValues(alpha: 0.07),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          isExpired
                                              ? Colors.redAccent
                                              : progress < 0.25
                                                  ? Colors.orange
                                                  : theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      "Berakhir ${_formatDate(endDate.toIso8601String())}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ─────────────────────
                              // PLAN + PRICE (2 kolom)
                              // ─────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: _infoCard(
                                      title: "PLAN TYPE",
                                      value: variant,
                                      icon: Icons.workspace_premium_outlined,
                                      isDark: isDark,
                                      theme: theme,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _infoCard(
                                      title: "HARGA",
                                      value: "Rp $price",
                                      icon: Icons.payments_outlined,
                                      isDark: isDark,
                                      theme: theme,
                                      isHighlight: true,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // ─────────────────────
                              // PURCHASE DATE
                              // ─────────────────────
                              _infoCard(
                                title: "TANGGAL PEMBELIAN",
                                value: _formatDate(data['created_at']),
                                icon: Icons.calendar_today_outlined,
                                isDark: isDark,
                                theme: theme,
                              ),

                              // ─────────────────────
                              // ACCOUNT INFO (hanya active)
                              // ─────────────────────
                              if (isActive) ...[
                                const SizedBox(height: 16),
                                _sectionCard(
                                  isDark: isDark,
                                  theme: theme,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: theme.colorScheme.primary
                                                  .withValues(alpha: 0.12),
                                            ),
                                            child: Icon(
                                              Icons.key_outlined,
                                              size: 16,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "INFO AKUN",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                              color: theme.colorScheme.primary
                                                  .withValues(alpha: 0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      _accountRow(
                                        Icons.mail_outline,
                                        "Email",
                                        email,
                                        theme,
                                        isDark,
                                      ),
                                      const SizedBox(height: 10),
                                      _accountRow(
                                        Icons.lock_outline,
                                        "Password",
                                        password,
                                        theme,
                                        isDark,
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 20),

                              // ─────────────────────
                              // CLAIM WARRANTY (hanya expired)
                              // ─────────────────────
                              if (isExpired) ...[

                              // ── Button Klaim Garansi ──
                              _actionButton(
                                label: "Klaim Garansi",
                                icon: Icons.shield_outlined,
                                isPrimary: true,
                                theme: theme,
                                isDark: isDark,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/garansi-form',
                                  arguments: data,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // ✅ Button Lihat Detail Garansi — lebih menonjol
                              GestureDetector(
                                onTap: () async {
                                  // ✅ FIX: pakai .limit(1) bukan .maybeSingle()
                                  // agar tidak crash saat ada lebih dari 1 row
                                  final result = await supabase
                                      .from('claims')
                                      .select('''
                                        *,
                                        orders (
                                          product_name,
                                          variant_type,
                                          products ( image )
                                        )
                                      ''')
                                      .eq('order_id', data['id'])
                                      .order('created_at', ascending: false)
                                      .limit(1);

                                  if (!mounted) return;

                                  if (result.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      '/garansi-detail',
                                      arguments: result.first as Map,
                                    );
                                  } else {
                                    _showSnackBar(
                                      'Belum ada klaim garansi untuk produk ini',
                                      isError: false,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppConstants.radius),
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.07)
                                        : Colors.grey.shade100,
                                    border: Border.all(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // ✅ Icon dengan background berwarna biar keliatan
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                        ),
                                        child: Icon(
                                          Icons.verified_outlined,
                                          size: 16,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Lihat Detail Garansi",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.4,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 13,
                                        color: theme.colorScheme.primary.withValues(alpha: 0.7),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              ],

                              // ─────────────────────
                              // CONTACT SUPPORT
                              // ─────────────────────
                              _actionButton(
                                label: "Hubungi Support",
                                icon: Icons.support_agent_outlined,
                                isPrimary: false,
                                theme: theme,
                                isDark: isDark,
                                onTap: () async {
                                  const phone = "6285349661585";
                                  final message =
                                      "Halo admin, saya butuh bantuan untuk order $productName";
                                  final url = Uri.parse(
                                    "https://wa.me/$phone?text=${Uri.encodeComponent(message)}",
                                  );
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    if (mounted) {
                                      _showSnackBar(
                                        "Tidak dapat membuka WhatsApp",
                                        isError: true,
                                      );
                                    }
                                  }
                                },
                              ),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // WIDGET HELPERS
  // ─────────────────────────────────────

  Widget _statusBadge({
    required bool isActive,
    required bool isPending,
    required bool isExpired,
  }) {
    final Color bg;
    final Color fg;
    final String label;
    final IconData icon;

    if (isActive) {
      bg = Colors.green.withValues(alpha: 0.15);
      fg = Colors.green;
      label = "AKTIF";
      icon = Icons.check_circle_outline;
    } else if (isPending) {
      bg = Colors.orange.withValues(alpha: 0.15);
      fg = Colors.orange;
      label = "PENDING";
      icon = Icons.hourglass_empty_outlined;
    } else {
      bg = Colors.redAccent.withValues(alpha: 0.15);
      fg = Colors.redAccent;
      label = "EXPIRED";
      icon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: bg,
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required bool isDark,
    required ThemeData theme,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.02),
                ]
              : [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
        color: theme.colorScheme.primary.withValues(alpha: 0.75),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    required ThemeData theme,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.06),
                  Colors.white.withValues(alpha: 0.02),
                ]
              : [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (isHighlight
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface)
                  .withValues(alpha: 0.1),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isHighlight
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isHighlight
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.grey.shade100,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required ThemeData theme,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radius),
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                )
              : null,
          color: isPrimary
              ? null
              : isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : Colors.grey.shade100,
          border: isPrimary
              ? null
              : Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary
                  ? (isDark ? Colors.black : Colors.white)
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
                color: isPrimary
                    ? (isDark ? Colors.black : Colors.white)
                    : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}