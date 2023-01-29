import 'package:api_pagination/repositery/api_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ApiClientEntries>(
      create: (context) => ApiClientEntries(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ApiClientEntries _apiClientEntries;
  late ScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiClientEntries = Provider.of<ApiClientEntries>(context, listen: false);
    _apiClientEntries.firstLoad();
    controller = ScrollController()
      ..addListener(() {
        print('...........Liostener.............');
        _apiClientEntries.loadMore(controller: controller);
      });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('pagination'),
        ),
        body: Consumer<ApiClientEntries>(
          builder: (context, value, child) {
            print(
                '..................Value............${value.isFirstLoadRunning}');
            return value.isFirstLoadRunning
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: value.posts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('${value.posts[index].title}'),
                            );
                          },
                        ),
                      ),
                      if (value.isLoadMoreRunning == true)
                        const Center(
                            child: Padding(
                          padding: EdgeInsets.only(bottom: 40.0),
                          child: CircularProgressIndicator(),
                        )),
                      if (!value.hasNextPage)
                        Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 40),
                          color: Colors.amber,
                          child: const Center(
                            child: Text('You have fetched all of the content'),
                          ),
                        ),
                    ],
                  );
          },
        ));
  }
}
