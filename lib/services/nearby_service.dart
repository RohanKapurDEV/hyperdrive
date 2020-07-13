import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class NearbyService extends ChangeNotifier {
  String _username;
  String get username => _username ??= uniqueUsername();

  List<Map<String, dynamic>> _advertisers;
  List<Map<String, dynamic>> get advertisers => _advertisers;

  /// Initializes necessary variables and starts looking for active advertisers nearby
  NearbyService() {
    this._username = uniqueUsername();
  }

  /// Checks for precise location and read/write permissions on user device. Returns an int
  /// indicating permissions status. 0 for neither, 1 for location only, 2 for storage only
  /// and 3 for both location and storage.
  Future<int> checkPermissions() async {
    bool hasLocationPermissions = await Nearby().checkLocationPermission();
    bool hasStoragePermissions =
        await Nearby().checkExternalStoragePermission();

    if (!hasLocationPermissions && !hasStoragePermissions) {
      return 0;
    } else if (hasLocationPermissions && !hasStoragePermissions) {
      return 1;
    } else if (!hasLocationPermissions && hasStoragePermissions) {
      return 2;
    } else {
      // Here, we assume both permissions are enabled for the user
      return 3;
    }
  }

  /// Asks for permissions based on [permissionsStatus], an integer expected from checkPermissions()
  /// output.
  void enablePermissions(int permissionsStatus) {
    if (permissionsStatus == 0) {
      Nearby().askLocationAndExternalStoragePermission();
    } else if (permissionsStatus == 1) {
      Nearby().askExternalStoragePermission();
    } else if (permissionsStatus == 2) {
      Nearby().askLocationPermission();
    } else {
      // Here, we assume permissionsStatus == 3
      print('All permissions enabled :)');
    }
  }

  /// Checks to see if the user has location enabled on the device during app runtime
  Future<void> checkLocationEnabled() async {
    final bool locationEnabled = await Nearby().checkLocationEnabled();
    if (!locationEnabled) {
      Nearby().enableLocationServices();
    }
  }

  /// Sets up a unique username for the user
  uniqueUsername() {
    final List<String> names = [
      "Helix",
      "Apache-Helicopter",
      "Narwhal",
      "Tycoon",
      "Philanthropist",
      "Playboy",
      "Billionaire",
      "Millionaire",
      "Disruptor",
      "Squared",
      "Cubed",
      "Dog",
      "Cat",
      "Mouse",
      "Rabbit",
      "Whale",
      "Satoshi",
      "Pokemon",
      "Centipede",
      "Sine Wave",
      "Cosine Wave",
      "Antidote",
      "Seashell",
      "Sea lion",
      "Pentagon",
      "Hexagon",
      "Shrimp",
      "Jesus",
      "God",
      "Stack",
      "Tank",
      "Dude",
      "Lizardman",
    ];

    final rdm = new Random();
    notifyListeners();
    return 'Anonymous ' + names[rdm.nextInt(names.length)];
  }
}
