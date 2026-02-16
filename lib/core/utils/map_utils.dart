import 'dart:io';

class MapUtils {
  /// Resolves a Google Maps short link (e.g., https://maps.app.goo.gl/...)
  /// to its full URL by following redirects.
  ///
  /// Returns the original [url] if it's not a short link or if resolution fails.
  static Future<String> resolveShortLink(String url) async {
    if (!url.contains('goo.gl') && !url.contains('maps.app.goo.gl')) {
      return url;
    }

    try {
      final client = HttpClient();
      var uri = Uri.parse(url);
      var request = await client.getUrl(uri);
      request.followRedirects =
          false; // We want to capture the redirect manually if needed,
      // or actually HttpClient follows by default?
      // specific requirement: "follow the redirect and get the FULL URL".
      // HttpClient auto-follows redirects by default up to a limit.
      // But to get the *final* URL, we might need to check the response.
      // Actually, if we use `followRedirects = true` (default), the `response` object might not easily give the final URL if it's a chain.
      // A better way with dart:io is to let it follow and check `response.redirects`? No, `HttpClientResponse` doesn't expose final URL directly easily.
      // Let's use `followRedirects = false` and loop, or just use `http` package if available.
      // User said "dart:io or package:http".
      // Let's try a simple HEAD/GET request with manual redirect handling to be sure.

      // Simpler approach: Use `HttpClient` and let it follow, but getting the final URL can be tricky.
      // Let's use the `HEAD` method iteratively.

      client.close();

      // Re-implementation with detailed loop for safety
      String currentUrl = url;
      int redirects = 0;
      while (redirects < 5) {
        final client = HttpClient();
        final req = await client.headUrl(Uri.parse(currentUrl));
        req.followRedirects = false;
        final res = await req.close();

        if (res.statusCode >= 300 && res.statusCode < 400) {
          final location = res.headers.value(HttpHeaders.locationHeader);
          if (location != null) {
            currentUrl = location;
            redirects++;
            // Check if we already have coordinates in the new URL
            if (_hasCoordinates(currentUrl)) {
              return currentUrl;
            }
          } else {
            break;
          }
        } else {
          // 200 OK or other
          break;
        }
      }
      return currentUrl;
    } catch (e) {
      // Gracefully return original URL on error (Offline or invalid)
      return url;
    }
  }

  static bool _hasCoordinates(String url) {
    return url.contains('@') || url.contains('?q=') || url.contains('search/');
  }

  /// Extracts [lat, long] from a Google Maps URL.
  /// Returns null if no coordinates found.
  static List<double>? extractCoordinates(String url) {
    try {
      // 1. Pattern: @-6.123,106.123
      // Regex: @(-?\d+\.\d+),(-?\d+\.\d+)
      final atRegex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
      final atMatch = atRegex.firstMatch(url);
      if (atMatch != null) {
        return [
          double.parse(atMatch.group(1)!),
          double.parse(atMatch.group(2)!)
        ];
      }

      // 2. Pattern: ?q=-6.123,106.123
      // Regex: [?&]q=(-?\d+\.\d+),(-?\d+\.\d+)
      final qRegex = RegExp(r'[?&]q=(-?\d+\.\d+),(-?\d+\.\d+)');
      final qMatch = qRegex.firstMatch(url);
      if (qMatch != null) {
        return [double.parse(qMatch.group(1)!), double.parse(qMatch.group(2)!)];
      }

      // 3. Pattern: search/-6.123,106.123
      final searchRegex = RegExp(r'search/(-?\d+\.\d+),(-?\d+\.\d+)');
      final searchMatch = searchRegex.firstMatch(url);
      if (searchMatch != null) {
        return [
          double.parse(searchMatch.group(1)!),
          double.parse(searchMatch.group(2)!)
        ];
      }

      // 4. Pattern: 3d-6.123!4d106.123 (Data PB)
      // This is harder and less common for user copy-paste, but let's handle basic ones first.

      return null;
    } catch (e) {
      return null;
    }
  }
}
