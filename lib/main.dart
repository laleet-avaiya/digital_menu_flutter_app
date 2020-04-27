import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Menu',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Digital Menu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey qrKey = GlobalKey();
  var qrText = "";
  QRViewController controller;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ('$qrText'.length == 0)
          ? AppBar(
              title: Text(widget.title),
            )
          : EmptyAppBar(),
      body: Center(
          child: ('$qrText'.length == 0)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: QRView(
                          key: qrKey,
                          overlay: QrScannerOverlayShape(
                              borderRadius: 10,
                              borderColor: Colors.green,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 300),
                          onQRViewCreated: _onQRViewCreate),
                    )
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                        child: WebView(
                            key: _key,
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: qrText))
                  ],
                )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.crop_free),
        onPressed: () => { setState(() { qrText = ""; }) },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.account_box),color: Colors.white, onPressed: () {},),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scandata) {
      setState(() {
        qrText = scandata;
      });
    });
  }
}
