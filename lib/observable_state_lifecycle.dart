library observable_state_lifecycle;

import 'package:flutter/widgets.dart';

mixin ObservableStateLifecycle<W extends StatefulWidget> on State<W> {
  @override
  @mustCallSuper
  void initState() {
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.initState, this);
    });
    super.initState();
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.didUpdateWidget, this);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.didChangeDependencies, this);
    });
    super.didChangeDependencies();
  }

  @override
  @mustCallSuper
  void reassemble() {
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.reassemble, this);
    });
    super.reassemble();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  @mustCallSuper
  void deactivate() {
    super.deactivate();
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.deactivate, this);
    });
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.dispose, this);
    });
  }

  // https://github.com/dart-lang/sdk/issues/9589
  @mustCallSuper
  void addLifecycleObserver(StateLifecycleObserver<W> observer) {
    lifecycleObservers.add(observer);
  }

  @mustCallSuper
  void removeLifecycleObserver(StateLifecycleObserver<W> observer) {
    lifecycleObservers.remove(observer);
  }

  final Set<StateLifecycleObserver<W>> lifecycleObservers =
      <StateLifecycleObserver<W>>{};
}

enum StateLifecyclePhase {
  initState,
  didUpdateWidget,
  didChangeDependencies,
  reassemble,
  deactivate,
  dispose,
}

typedef StateLifecycleObserver<W extends StatefulWidget> = void Function(
    StateLifecyclePhase phase, ObservableStateLifecycle<W> state);
