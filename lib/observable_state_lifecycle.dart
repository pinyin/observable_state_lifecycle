library observable_state_lifecycle;

import 'package:flutter/widgets.dart';

mixin ObservableStateLifecycle<W extends StatefulWidget> on State<W> {
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.initState);
    });
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.didUpdateWidget);
    });
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.didChangeDependencies);
    });
  }

  @override
  @mustCallSuper
  void reassemble() {
    super.reassemble();
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.reassemble);
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  @mustCallSuper
  void deactivate() {
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.deactivate);
    });
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose() {
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.dispose);
    });
    super.dispose();
  }

  // https://github.com/dart-lang/sdk/issues/9589
  @mustCallSuper
  void addLifecycleObserver(StateLifecycleObserver observer) {
    lifecycleObservers.add(observer);
  }

  @mustCallSuper
  void removeLifecycleObserver(StateLifecycleObserver observer) {
    lifecycleObservers.remove(observer);
  }

  final Set<StateLifecycleObserver> lifecycleObservers =
      <StateLifecycleObserver>{};
}

enum StateLifecyclePhase {
  initState,
  didUpdateWidget,
  didChangeDependencies,
  reassemble,
  deactivate,
  dispose,
}

typedef StateLifecycleObserver = void Function(StateLifecyclePhase);
