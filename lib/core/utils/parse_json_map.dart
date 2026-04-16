import 'dart:convert';

/// Normalizes [Dio] [Response.data] to a JSON object map.
///
/// Dio leaves the body as [String] when the server sends e.g. `text/html` or
/// `text/plain` even if the payload is JSON.
Map<String, dynamic>? parseJsonMap(dynamic data) {
  if (data == null) return null;
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String) {
    final trimmed = data.trim();
    if (trimmed.isEmpty) return null;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return null;
}
