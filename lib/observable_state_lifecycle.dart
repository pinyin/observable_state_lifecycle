library observable_state_lifecycle;

import 'package:flutter/widgets.dart';

mixin ObservableStateLifecycle<W extends StatefulWidget> on State<W> {
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    this.lifecycleObservers.forEach((observer) {
      observer.onInitState();
    });
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.lifecycleObservers.forEach((observer) {
      observer.onDidUpdateWidget(oldWidget);
    });
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.lifecycleObservers.forEach((observer) {
      observer.onDidChangeDependencies();
    });
  }

  @override
  @mustCallSuper
  void reassemble() {
    super.reassemble();
    this.lifecycleObservers.forEach((observer) {
      observer.onReassemble();
    });
  }

  @override
  @mustCallSuper
  void deactivate() {
    this.lifecycleObservers.forEach((observer) {
      observer.onDeactivate();
    });
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose() {
    this.lifecycleObservers.forEach((observer) {
      observer.onDispose();
    });
    super.dispose();
  }

  @mustCallSuper
  void addLifecycleObserver(StateLifecycleObserver<W> observer,
      {bool shouldRunInitState = false}) {
    lifecycleObservers.add(observer);
    if (shouldRunInitState) observer.onInitState();
  }

  @mustCallSuper
  void removeLifecycleObserver(StateLifecycleObserver<W> observer) {
    lifecycleObservers.remove(observer);
  }

  final Set<StateLifecycleObserver<W>> lifecycleObservers =
      <StateLifecycleObserver<W>>{};
}

mixin StateLifecycleObservable<W extends StatefulWidget> {
  @mustCallSuper
  void addObserver(StateLifecycleObserver<W> observer,
      {bool shouldRunInitState = false}) {
    observers.add(observer);
    if (shouldRunInitState) observer.onInitState();
  }

  @mustCallSuper
  void removeObserver(StateLifecycleObserver<W> observer) {
    observers.remove(observer);
  }

  final Set<StateLifecycleObserver<W>> observers =
      <StateLifecycleObserver<W>>{};
}

mixin StateLifecycleObserver<W extends StatefulWidget> {
  void onInitState() {}
  void onDidUpdateWidget(covariant W oldWidget) {}
  void onDidChangeDependencies() {}
  void onReassemble() {}
  void onDeactivate() {}
  void onDispose() {}
}

void _empty([dynamic W]) {}

class StateLifecycleSubject<W extends StatefulWidget> extends Object
    with StateLifecycleObserver<W>, StateLifecycleObservable<W> {
  StateLifecycleSubject(
      {final void Function() onInitState = _empty,
      final void Function(W oldWidget) onDidUpdateWidget = _empty,
      final void Function() onDidChangeDependencies = _empty,
      final void Function() onReassemble = _empty,
      final void Function() onDeactivate = _empty,
      final void Function() onDispose = _empty})
      : _onInitState = onInitState,
        _onDidUpdateWidget = onDidUpdateWidget,
        _onDidChangeDependencies = onDidChangeDependencies,
        _onReassemble = onReassemble,
        _onDeactivate = onDeactivate,
        _onDispose = onDispose;

  final void Function() _onInitState;
  final void Function(W oldWidget) _onDidUpdateWidget;
  final void Function() _onDidChangeDependencies;
  final void Function() _onReassemble;
  final void Function() _onDeactivate;
  final void Function() _onDispose;

  @override
  @mustCallSuper
  void onInitState() {
    _onInitState();
    this.observers.forEach((observer) {
      observer.onInitState();
    });
  }

  @override
  @mustCallSuper
  void onDidUpdateWidget(W oldWidget) {
    _onDidUpdateWidget(oldWidget);
    this.observers.forEach((observer) {
      observer.onDidUpdateWidget(oldWidget);
    });
  }

  @override
  @mustCallSuper
  void onDidChangeDependencies() {
    _onDidChangeDependencies();
    this.observers.forEach((observer) {
      observer.onDidChangeDependencies();
    });
  }

  @override
  @mustCallSuper
  void onReassemble() {
    _onReassemble();
    this.observers.forEach((observer) {
      observer.onReassemble();
    });
  }

  @override
  @mustCallSuper
  void onDeactivate() {
    this.observers.forEach((observer) {
      observer.onInitState();
    });
    _onDeactivate();
  }

  @override
  @mustCallSuper
  void onDispose() {
    this.observers.forEach((observer) {
      observer.onDispose();
    });
    _onDispose();
  }
}
