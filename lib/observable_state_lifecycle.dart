library observable_state_lifecycle;

import 'package:flutter/widgets.dart';

mixin ObservableStateLifecycle<W extends StatefulWidget> on State<W> {
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    latestLifecyclePhase = StateLifecyclePhase.initState;
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.initState);
    });
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant W oldWidget) {
    super.didUpdateWidget(oldWidget);
    latestLifecyclePhase = StateLifecyclePhase.didUpdateWidget;
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.didUpdateWidget);
    });
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    latestLifecyclePhase = StateLifecyclePhase.didChangeDependencies;
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.didChangeDependencies);
    });
  }

  @override
  @mustCallSuper
  void reassemble() {
    super.reassemble();
    latestLifecyclePhase = StateLifecyclePhase.reassemble;
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.reassemble);
    });
  }

  @override
  @mustCallSuper
  void deactivate() {
    latestLifecyclePhase = StateLifecyclePhase.deactivate;
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.deactivate);
    });
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose() {
    latestLifecyclePhase = StateLifecyclePhase.dispose;
    lifecycleObservers.forEach((observer) {
      observer(StateLifecyclePhase.dispose);
    });
    super.dispose();
  }

  // expose setState as public method
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  // https://github.com/dart-lang/sdk/issues/9589
  @mustCallSuper
  void addLifecycleObserver(StateLifecycleObserver observer) {
    lifecycleObservers.add(observer);
    if (latestLifecyclePhase == StateLifecyclePhase.initState) {
      observer(StateLifecyclePhase.initState);
    }
  }

  @mustCallSuper
  void removeLifecycleObserver(StateLifecycleObserver observer) {
    lifecycleObservers.remove(observer);
  }

  final Set<StateLifecycleObserver> lifecycleObservers =
      <StateLifecycleObserver>{};

  StateLifecyclePhase latestLifecyclePhase;
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

void observeEffect(VoidCallback Function() effect, bool Function() isIdentical,
    ObservableStateLifecycle host) {
  VoidCallback cancel;

  host.addLifecycleObserver((phase) {
    switch (phase) {
      case StateLifecyclePhase.initState:
        cancel = effect();
        break;
      case StateLifecyclePhase.didUpdateWidget:
        if (isIdentical()) break;
        cancel();
        cancel = effect();
        break;
      case StateLifecyclePhase.dispose:
        cancel();
        break;
      default:
        {}
    }
  });
}

ObserveState<S> observeState<S>(S initialValue, ObservableStateLifecycle host) {
  return ObserveState(initialValue, host);
}

class ObserveState<S> {
  ObserveState(S initialValue, ObservableStateLifecycle state)
      : _state = state,
        _value = initialValue;

  S _value;
  final ObservableStateLifecycle _state;

  S get value => _value;
  set value(S newValue) {
    if (newValue == _value) return;
    _value = newValue;
    _state.setState(() {});
  }

  S get() {
    return value;
  }

  void set(S newValue) {
    value = newValue;
  }
}
