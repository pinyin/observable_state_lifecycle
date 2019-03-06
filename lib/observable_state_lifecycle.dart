library observable_state_lifecycle;

import 'package:flutter/widgets.dart';

mixin ObservableStateLifecycle<W extends StatefulWidget> on State<W> {
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    lifecycleObservers.forEach((observer) {
      observer.onInitState();
    });
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    lifecycleObservers.forEach((observer) {
      observer.onDidUpdateWidget(oldWidget);
    });
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    lifecycleObservers.forEach((observer) {
      observer.onDidChangeDependencies();
    });
  }

  @override
  @mustCallSuper
  void reassemble() {
    super.reassemble();
    lifecycleObservers.forEach((observer) {
      observer.onReassemble();
    });
  }

  @override
  @mustCallSuper
  void deactivate() {
    lifecycleObservers.forEach((observer) {
      observer.onDeactivate();
    });
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose() {
    lifecycleObservers.forEach((observer) {
      observer.onDispose();
    });
    super.dispose();
  }

  // https://github.com/dart-lang/sdk/issues/9589
  @mustCallSuper
  void addLifecycleObserver(LifecycleObserver<W> observer,
      {bool shouldRunInitState = false}) {
    lifecycleObservers.add(observer);
    if (shouldRunInitState) observer.onInitState();
  }

  @mustCallSuper
  void removeLifecycleObserver(LifecycleObserver<W> observer) {
    lifecycleObservers.remove(observer);
  }

  final Set<LifecycleObserver<W>> lifecycleObservers = <LifecycleObserver<W>>{};
}

mixin LifecycleObservers<W extends StatefulWidget> {
  @mustCallSuper
  void addLifecycleObserver(LifecycleObserver<W> observer,
      {bool shouldRunInitState = false}) {
    lifecycleObservers.add(observer);
    if (shouldRunInitState) observer.onInitState();
  }

  @mustCallSuper
  void removeLifecycleObserver(LifecycleObserver<W> observer) {
    lifecycleObservers.remove(observer);
  }

  final Set<LifecycleObserver<W>> lifecycleObservers = <LifecycleObserver<W>>{};
}

mixin LifecycleObserver<W extends StatefulWidget> {
  void onInitState() {}
  void onDidUpdateWidget(covariant W oldWidget) {}
  void onDidChangeDependencies() {}
  void onReassemble() {}
  void onDeactivate() {}
  void onDispose() {}
}

void _empty([dynamic W]) {}

abstract class LifecycleSubject<W extends StatefulWidget>
    with LifecycleObserver<W>, LifecycleObservers<W> {
  LifecycleSubject();

  factory LifecycleSubject.create(
      {final void Function() onInitState = _empty,
      final void Function(W oldWidget) onDidUpdateWidget = _empty,
      final void Function() onDidChangeDependencies = _empty,
      final void Function() onReassemble = _empty,
      final void Function() onDeactivate = _empty,
      final void Function() onDispose = _empty}) {
    return LifecycleSubjectImpl<W>(
        onInitState: onInitState,
        onDidUpdateWidget: onDidUpdateWidget,
        onDidChangeDependencies: onDidChangeDependencies,
        onReassemble: onReassemble,
        onDeactivate: onDeactivate,
        onDispose: onDispose);
  }

  @override
  @mustCallSuper
  void onInitState() {
    this.lifecycleObservers.forEach((observer) {
      observer.onInitState();
    });
  }

  @override
  @mustCallSuper
  void onDidUpdateWidget(W oldWidget) {
    this.lifecycleObservers.forEach((observer) {
      observer.onDidUpdateWidget(oldWidget);
    });
  }

  @override
  @mustCallSuper
  void onDidChangeDependencies() {
    this.lifecycleObservers.forEach((observer) {
      observer.onDidChangeDependencies();
    });
  }

  @override
  @mustCallSuper
  void onReassemble() {
    this.lifecycleObservers.forEach((observer) {
      observer.onReassemble();
    });
  }

  @override
  @mustCallSuper
  void onDeactivate() {
    this.lifecycleObservers.forEach((observer) {
      observer.onInitState();
    });
  }

  @override
  @mustCallSuper
  void onDispose() {
    this.lifecycleObservers.forEach((observer) {
      observer.onDispose();
    });
  }
}

class LifecycleSubjectImpl<W extends StatefulWidget>
    extends LifecycleSubject<W> {
  LifecycleSubjectImpl(
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
    super.onInitState();
  }

  @override
  @mustCallSuper
  void onDidUpdateWidget(W oldWidget) {
    _onDidUpdateWidget(oldWidget);
    super.onDidUpdateWidget(oldWidget);
  }

  @override
  @mustCallSuper
  void onDidChangeDependencies() {
    _onDidChangeDependencies();
    super.onDidChangeDependencies();
  }

  @override
  @mustCallSuper
  void onReassemble() {
    _onReassemble();
    super.onReassemble();
  }

  @override
  @mustCallSuper
  void onDeactivate() {
    super.onDeactivate();
    _onDeactivate();
  }

  @override
  @mustCallSuper
  void onDispose() {
    super.onDispose();
    _onDispose();
  }
}
