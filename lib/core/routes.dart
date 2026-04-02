import 'package:flutter/material.dart';
import '../features/admin/admin_order_page.dart';
import '../features/customer/edit_profile_page.dart';
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';
import '../features/customer/home_page.dart';
import '../features/customer/product_detail_page.dart';
import '../features/customer/product_page.dart';
import '../features/customer/checkout_page.dart';
import '../features/customer/payment_page.dart';
import '../features/customer/order_page.dart';
import '../features/customer/profile_page.dart';
import '../features/customer/garansi_page.dart';
import '../features/customer/search_page.dart';
import '../features/customer/garansi_detail_page.dart';
import '../features/customer/info_page.dart';
import '../features/customer/order_detail_page.dart';
import '../features/customer/rules_page.dart';
import '../features/customer/social_page.dart';
import '../features/admin/admin_home_page.dart';
import '../features/admin/admin_order_detail_page.dart';
import '../features/admin/admin_product_detail_page.dart';
import '../features/admin/admin_product_page.dart';
import '../features/admin/admin_add_product_page.dart';
import '../features/admin/admin_add_variant_page.dart';
import '../features/admin/admin_garansi_page.dart';
import '../features/admin/admin_garansi_detail_page.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomePage(),
    '/products': (context) => const ProductPage(),
    '/detail': (context) => const ProductDetailPage(),
    '/checkout': (context) => const CheckoutPage(),
    '/payment': (context) => const PaymentPage(),
    '/orders': (context) => const OrderPage(),
    '/profile': (context) => const ProfilePage(),
    '/garansi': (context) => const GaransiPage(),
    '/search': (context) => const SearchPage(),
    '/info': (context) => const InfoPage(),
    '/order-detail': (context) => const OrderDetailPage(),
    '/garansi-detail': (context) => const GaransiDetailPage(),
    '/rules': (context) => const RulesPage(),
    '/social': (context) => const SocialPage(),
    '/edit-profile': (context) => const EditProfilePage(),
    '/admin': (context) => const AdminHomePage(),
    '/admin-order': (context) => const AdminOrderPage(),
    '/admin-order-detail': (context) => const AdminOrderDetailPage(),
    '/admin-product-detail': (context) => const AdminProductDetailPage(),
    '/admin-product': (context) => const AdminProductPage(),
    '/admin-add-product': (context) => const AdminAddProductPage(),
    '/admin-add-variant': (context) => const AdminAddVariantPage(),
    '/admin-garansi': (context) => const AdminGaransiPage(),
    '/admin-garansi-detail': (context) => const AdminGaransiDetailPage(),
  };
}