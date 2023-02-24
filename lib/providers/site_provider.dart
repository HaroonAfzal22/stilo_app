import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sede.dart';

final siteProvider = StateProvider<Site?>((ref) => null);

final sitesProvider = StateProvider<List<Site>>((ref) => []);
