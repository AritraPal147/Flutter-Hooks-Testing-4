import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Hooks Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

class CountDown extends ValueNotifier<int> {
  late StreamSubscription sub;

  /// Sets up a subscription to a Stream, which takes values from the stream
  /// provided the values in the stream are greater than zero.
  ///
  /// Each second, the value [from] given by user gets reduced by [value] or [v]
  /// that we get from the [Stream]. The [Stream] stops when [value] < 0
  CountDown({required int from}) : super(from) {
    sub = Stream.periodic(
      const Duration(seconds: 1),
      (v) => from - v,
    ).takeWhile((value) => value >= 0).listen((value) {
      this.value = value;
    });
  }

  /// Cancels [sub], the [StreamSubscription], when [CountDown] is disposed.
  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// If we do not want to rebuild everything everytime the build function
    /// is called, we use [useMemoized] hook that allows us to store complex
    /// objects in cache so that data can directly be retrieved from there.
    ///
    /// [countDown] only stores the current countDown in cache, it DOES NOT
    /// call the build function.
    final countDown = useMemoized(() => CountDown(from: 20));

    /// [notifier] listens for changes in [countDown]
    ///
    /// Calls the build function everytime [countDown] changes its value
    final notifier = useListenable(countDown);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
          child: Text(
        notifier.value.toString(),
        style: const TextStyle(fontSize: 30),
      )),
    );
  }
}
