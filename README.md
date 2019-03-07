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
    addLifecycleObserver((phase){
      if(phase == StateLifecyclePhase.initState) {
        setState((){
          n = 2;
        });
      }
    });

    int n = 1;
  }
}

```

