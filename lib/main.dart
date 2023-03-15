import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rfw/rfw.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}
// see example/hello
// see example/local

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final Runtime _runtime = Runtime();
  final DynamicContent _data = DynamicContent();

  final bool _ready = false;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _runtime.update(
      const LibraryName(<String>['core', 'widgets']),
      createCoreWidgets(),
    );

    _runtime.update(
      const LibraryName(<String>['core', 'material']),
      createMaterialWidgets(),
    );
    _updateData();
    _updateWidgets();
  }

  void _updateData() {
    _data.update('counter', _counter.toString());
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   _update();
  // }

  //widget making

  // static WidgetLibrary _createLocalWidgets() =>
  //     LocalWidgetLibrary(<String, LocalWidgetBuilder>{
  //       'Scaffold': (BuildContext context, DataSource source) {
  //         return Scaffold(
  //             backgroundColor: Color(
  //                 source.v<int>(<Object>["backgroundColor"]) ?? 0xFFFFFFFF),
  //             body: SingleChildScrollView(
  //               child: Column(
  //                 children: source.childList(<Object>['children']),
  //               ),
  //             ));
  //       },
  //       'Container': (BuildContext context, DataSource source) {
  //         return Container(
  //           color: Color(source.v<int>(<Object>["customColor"]) ?? 0xFFFFFFFF),
  //           height: source.v<double>(<Object>["height"]),
  //           child: source.child(<Object>['child']),
  //           // child: source.child(<Object>['child']),
  //         );
  //       },
  //       'SizedBox': (BuildContext context, DataSource source) {
  //         return SizedBox(height: source.v<double>(<Object>["height"]));
  //       },
  //       'Text': (BuildContext context, DataSource source) {
  //         return Center(
  //             child: Text('${source.v<String>(<Object>["name"])}',
  //                 style: TextStyle(
  //                     fontSize: double.parse(
  //                         '${source.v<String>(<Object>["fontSize"])}')),
  //                 textDirection: TextDirection.ltr));
  //       },
  //       'TextFormField': (BuildContext context, DataSource source) {
  //         return TextFormField(
  //           decoration: InputDecoration(
  //               labelText: "${source.v<String>(<Object>["labelText"])}"),
  //         );
  //       },
  //       'Padding': (BuildContext context, DataSource source) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           child: source.child(<Object>['child']),
  //         );
  //       },
  //       'ElevatedButton': (BuildContext context, DataSource source) {
  //         return Center(
  //           child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 minimumSize: const Size(100, 50),
  //                 maximumSize: const Size(300, 50),
  //                 backgroundColor: Colors.black, // background (button) color
  //                 foregroundColor: Colors.white, // foreground (text) color
  //               ),
  //               onPressed: () {
  //                 source.voidHandler(<Object>['onPressed']);
  //               },
  //               child: source.child(<Object>['child'])),
  //         );
  //       },
  //     });

  // void _update() {
  //   //widget update
  //   _runtime.update(
  //       const LibraryName(<String>['local']), _createLocalWidgets());

  //   //show widget thru json
  //   _runtime.update(const LibraryName(<String>['remote']), parseLibraryFile('''
  //     import local;
  //     widget root = Scaffold(
  //       backgroundColor:0xFFFFFFFF,
  //       children:[
  //         Container(customColor:0xFFCCFFFF,
  //         height:200.00,
  //         child:Text(name: "Login",fontSize:"20.00"),
  //         ),
  //         SizedBox(height:50.00),
  //         Padding(child:TextFormField(labelText:"Login")),
  //         SizedBox(height:50.00),
  //         Padding(child:TextFormField(labelText:"Password")),
  //         SizedBox(height:100.00),
  //         ElevatedButton(child:Text(name: "Login",fontSize:"20.00"),)
  //                   ],
  //     );
  //   '''));
  // }

  void _updateWidgets() async {
    const String path =
        "/Users/simer/Documents/flutter_application_1/lib/login.rfwtxt";
    final File currentFile = File(path);

    if (currentFile.existsSync()) {
      try {
        _runtime.update(const LibraryName(<String>['[main']),
            decodeLibraryBlob(await currentFile.readAsBytes()));
      } catch (e) {
        // FlutterError reportError(
        //     FlutterErrorDetails(exception: e, stack: stack),
        // );
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return RemoteWidget(
  //     runtime: _runtime,
  //     data: _data,
  //     widget: const FullyQualifiedWidgetName(
  //         LibraryName(<String>['remote']), 'root'),
  //     onEvent: (String name, DynamicMap arguments) {
  //       log('user triggered event "$name" with data: $arguments');
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return RemoteWidget(
      runtime: _runtime,
      data: _data,
      widget: const FullyQualifiedWidgetName(
          LibraryName(<String>['main']), 'Counter'),
      onEvent: (String name, DynamicMap arguments) {
        if (name == 'increment') {
          _counter += 1;
          _updateData();
        }
      },
    );
  }
}
