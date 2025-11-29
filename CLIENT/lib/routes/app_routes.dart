import 'package:go_router/go_router.dart';
import '../features/home/screens/home_screen.dart';
import '../features/letter/screens/letter_list_screen.dart';
import '../features/letter/screens/letter_create_screen.dart';
import '../features/letter/screens/letter_detail_screen.dart';
import '../features/letter/screens/letter_template_form_screen.dart';
import '../features/letter/models/letter_format.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/letters',
      builder: (context, state) => const LettersListScreen(),
    ),
    // Create template baru
    GoRoute(
      path: '/letter/template/create',
      builder: (context, state) => const LetterTemplateFormScreen(),
    ),
    // Edit template
    GoRoute(
      path: '/letter/template/edit',
      builder: (context, state) {
        final template = state.extra as LetterFormat;
        return LetterTemplateFormScreen(template: template);
      },
    ),
    // Generate surat dari template
    GoRoute(
      path: '/letter/create',
      builder: (context, state) {
        final extra = state.extra as LetterFormat;
        return LetterCreateScreen(jenisSurat: extra);
      },
    ),
    GoRoute(
      path: '/letter/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return LetterDetailScreen(id: id);
      },
    ),
  ],
);
