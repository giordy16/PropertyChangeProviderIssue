import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:property_change_notifier_issue/db/mapper.dart';
import 'package:property_change_notifier_issue/models/counter_obox.dart';
import 'package:property_change_notifier_issue/models/domain_base_class.dart';

import 'db/objectbox.dart';
import 'models/counter.dart';
import 'objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Counter> counterList;

  bool useObjectBox = true;

  @override
  void initState() {
    if (useObjectBox) {
      fetchCounters();
    } else {
      counterList = [];
    }

    super.initState();
  }

  void fetchCounters() {
    counterList = objectbox.store
        .box<CounterObox>()
        .query()
        .order(CounterObox_.sortOrder)
        .build()
        .find()
        .map((e) => e.convertToDomain())
        .toList();
  }

  void saveCounter(Counter c) {
    if (useObjectBox) {
      objectbox.store.box<CounterObox>().put(c.convertToObox());
    } else {
      counterList.add(c);
    }
  }

  void increase(Counter c) {
    c.currentValue = (c.currentValue ?? 0) + 1;

    if (useObjectBox) {
      saveCounter(c);
    }
  }

  void delete(Counter c) {
    if (useObjectBox) {
      objectbox.store.box<CounterObox>().remove(c.id);
    } else {
      counterList.remove(c);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              saveCounter(Counter(
                  name: DateTime.now().millisecondsSinceEpoch.toString()));
              setState(() {
                if (useObjectBox) fetchCounters();
              });
            }),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemBuilder: (context, index) {
              Counter c = counterList[index];
              return Row(
                children: [
                  Expanded(child: CounterValueWidget(c)),
                  IconButton(
                      onPressed: () {
                        delete(c);
                        setState(() {
                          if (useObjectBox) fetchCounters();
                        });
                      },
                      icon: const Icon(Icons.delete_outline)),
                  IconButton(
                      onPressed: () {
                        increase(c);
                      },
                      icon: const Icon(Icons.plus_one))
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: counterList.length,
          ),
        )));
  }
}

class CounterValueWidget extends StatefulWidget {
  Counter counter;

  CounterValueWidget(this.counter);

  @override
  State<StatefulWidget> createState() => _CounterValueWidgetState();
}

class _CounterValueWidgetState extends State<CounterValueWidget> {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<DomainBaseClass, String>(
        key: Key("currentValue"),
        value: widget.counter,
        child: Builder(builder: (BuildContext context) {
          final c = PropertyChangeProvider.of<DomainBaseClass, String>(context,
                  properties: ["currentValue"])!
              .value as Counter;

          return Text((c.currentValue ?? 0).toString());
        }));
  }
}
