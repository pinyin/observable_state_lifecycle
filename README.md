# observable_state_lifecycle

Make Flutter StatefulWidget's lifecycle observable.

## Getting Started

When creating your `StatefulWidget`, add a mixin from this library:
```
// A Widget named Test

import 'package:observable_state_lifecycle/observable_state_lifecycle.dart';

class _TestState extends State<Test> with ObservableStateLifecycle<Test> {

}

```

Then you can call `addLifecycleObserver` in your state:

```
class _TestState extends State<Test> with ObservableStateLifecycle<Test> {
  _TestState() {
    addLifecycleObserver(StateLifecycleSubject<Test>(
      onInitState: () {
        widget.output(Phase.initState);
      },
      onDidUpdateWidget: () {
        widget.output(Phase.didUpdateWidget);
      },
      onDidChangeDependencies: () {
        widget.output(Phase.didChangeDependencies);
      },
      onReassemble: () {
        widget.output(Phase.reassemble);
      },
      onDeactivate: () {
        widget.output(Phase.deactivate);
      },
      onDispose: () {
        widget.output(Phase.dispose);
      },
    ));
  }
}

```

You can also pass your own instance of `StateLifecycleObserver` to addLifecycleObserver, preferably by creating a subclass of `StateLifecycleSubject`.
