// lib/core/router/app_router.dart
import 'package:e_penilaian_santri/features/auth/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_providers.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/santri/presentation/santri_list_page.dart';
import '../../features/penilaian/presentation/santri_detail_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // ambil state auth dari Riverpod
  final authState = ref.watch(appUserStreamProvider);

  // convert ke object user (boleh null)
  final user = authState.maybeWhen(
    data: (u) => u,
    orElse: () => null,
  );

  return GoRouter(
    // TANPA refreshListenable dulu, biar simple dan tidak error
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const SantriListPage(),
      ),
      GoRoute(
        path: '/santri/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SantriDetailPage(santriId: id);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
    redirect: (context, state) {
      final loggingIn = state.uri.path == '/login';

      // kalau user belum login
      if (user == null) {
        // kalau sudah di /login, biarkan; kalau bukan, arahkan ke /login
        return loggingIn ? null : '/login';
      }

      // kalau SUDAH login tapi URL-nya masih /login, arahkan ke home
      if (loggingIn) return '/';

      // selain itu tidak perlu redirect
      return null;
    },
  );
});
