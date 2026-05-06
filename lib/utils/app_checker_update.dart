import 'package:dieaya_user/utils/api/http_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dieaya_user/ui/widgets/global_widgets/custom_solver_text_issues.dart';

Future<String?> getLatestVersionFromAppStore(String appId) async {
  final url = Uri.parse('https://itunes.apple.com/lookup?id=$appId');
  final response = await HttpService.instance.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data["results"][0]["version"];
  }
  return null;
}

Future<String?> getLatestVersionFromPlayStore(String packageName) async {
  final url = Uri.parse('https://play.google.com/store/apps/details?id=$packageName&hl=en');
  final response = await HttpService.instance.get(url);

  if (response.statusCode == 200) {
    final regex = RegExp(r'\[\[\["([0-9]+.[0-9]+.[0-9]+)"\]');
    final match = regex.firstMatch(response.body);
    return match?.group(1);
  }
  return null;
}

Future<String> getCurrentAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

void checkForUpdate(BuildContext context, String packageName, String appId) async {
  String currentVersion = await getCurrentAppVersion();
  String? latestVersion;

  if (Theme.of(context).platform == TargetPlatform.android) {
    latestVersion = await getLatestVersionFromPlayStore(packageName);
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    latestVersion = await getLatestVersionFromAppStore(appId);
  }

  if (latestVersion != null && currentVersion != latestVersion) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing the dialog
      builder: (context) => AlertDialog(
        title: const CustomTextSolveIssue("Update Required"),
        content: CustomTextSolveIssue("A new version ($latestVersion) is available. Please update to continue using the app."),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final url = Theme.of(context).platform == TargetPlatform.android
                  ? "https://play.google.com/store/apps/details?id=$packageName"
                  : "https://apps.apple.com/app/id$appId";
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            child: const CustomTextSolveIssue("Update Now"),
          ),
        ],
      ),
    );
  }
}



class AppVersionChecker {
  final String packageName;
  final String appStoreId;

  const AppVersionChecker({
    required this.packageName,
    required this.appStoreId,
  });

  bool isNewerVersion(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    while (currentParts.length < 3) currentParts.add(0);
    while (latestParts.length < 3) latestParts.add(0);

    for (int i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  Future<bool> needsUpdate(BuildContext context) async {
    try {
      final String currentVersion = await getCurrentAppVersion();
      final String? latestVersion = Theme.of(context).platform == TargetPlatform.android
          ? await getLatestVersionFromPlayStore()
          : await getLatestVersionFromAppStore();

      if (latestVersion == null) {
        debugPrint('Could not fetch latest version');
        return false;
      }

      return isNewerVersion(currentVersion, latestVersion);
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  Future<String?> getLatestVersionFromAppStore() async {
    try {
      final url = Uri.parse('https://itunes.apple.com/lookup?id=$appStoreId');
      final response = await HttpService.instance.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results']?.isNotEmpty == true) {
          return data['results'][0]['version'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching App Store version: $e');
      return null;
    }
  }

  Future<String?> getLatestVersionFromPlayStore() async {
    try {
      final url = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName&hl=en'
      );
      final response = await HttpService.instance.get(url);

      if (response.statusCode == 200) {
        final regex = RegExp(r'\[\[\["([0-9]+\.[0-9]+\.[0-9]+)"\]');
        final match = regex.firstMatch(response.body);
        return match?.group(1);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching Play Store version: $e');
      return null;
    }
  }

  Future<void> launchStore(BuildContext context) async {
    final String url = Theme.of(context).platform == TargetPlatform.android
        ? "https://play.google.com/store/apps/details?id=$packageName"
        : "https://apps.apple.com/app/id$appStoreId";

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch store URL';
      }
    } catch (e) {
      debugPrint('Error launching store: $e');
    }
  }
}
