import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:hyperdrive/services/nearby_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NearbyService())],
      child: MaterialApp(
        title: 'Hyperdrive',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.cyan,
          accentColor: Colors.cyanAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainView(),
      ),
    );
  }
}

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey<InnerDrawerState>();
  bool _showDiscoveryLoadingBar = false;

  void _toggleDrawer() {
    _drawerKey.currentState.toggle();
  }

  @override
  void initState() {
    checkAndHandlePermissions();
    super.initState();
  }

  /// Hooks into the NearbyService to check for and activate the necessary permissions required to
  /// start looking for and creating connections with other devices
  checkAndHandlePermissions() async {
    NearbyService nearbyService = NearbyService();
    int permissionsStatus = await nearbyService.checkPermissions();
    nearbyService.enablePermissions(permissionsStatus);
    await nearbyService.checkLocationEnabled();
  }

  initiateDiscovery() {
    setState(() {
      this._showDiscoveryLoadingBar = true;
    });
  }

  stopDiscovery() {
    setState(() {
      this._showDiscoveryLoadingBar = false;
    });
  }

  _buildDiscoveryProgressBar() {
    if (this._showDiscoveryLoadingBar) {
      return LinearProgressIndicator();
    } else {
      return SizedBox(height: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NearbyService nearbyService = Provider.of<NearbyService>(context);

    return InnerDrawer(
      key: _drawerKey,
      onTapClose: true,
      swipe: true,
      offset: IDOffset.horizontal(0.6),
      scale: IDOffset.horizontal(1),
      leftAnimationType: InnerDrawerAnimation.quadratic,
      colorTransitionChild: Colors.cyan,
      leftChild: Container(
        color: Colors.black45,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 8),
            Material(
                child: ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {
                _toggleDrawer();
              },
            )),
            SizedBox(height: 8),
            Material(
                child: ListTile(
              title: Text('Credits'),
              leading: Icon(Icons.info),
              onTap: () {},
            )),
            SizedBox(height: 8),
            Material(
                child: ListTile(
                    title: Text('Username: ' + nearbyService.username)))
          ],
        ),
      ),
      scaffold: Scaffold(
        appBar: AppBar(
          title: Text('Hyperdrive'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(icon: Icon(Icons.menu), onPressed: _toggleDrawer),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () {},
        ),
        body: Column(
          children: <Widget>[
            _buildDiscoveryProgressBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Show my device nearby'),
                  Switch(
                    value: this._showDiscoveryLoadingBar,
                    onChanged: (val) {
                      if (this._showDiscoveryLoadingBar) {
                        stopDiscovery();
                      } else {
                        initiateDiscovery();
                      }
                    },
                  )
                ],
              ),
            ),
            Divider(color: Colors.black),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: Row(
                children: <Widget>[
                  Text('Nearby Devices', textScaleFactor: 1.3)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
