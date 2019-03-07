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
    addLifecycleObserver((phase, state){
      if(phase == StateLifecyclePhase.initState) {
        // state is an instance of ObservableStateLifecycle, so you can call methods
        // like addLifecycleObserver or setState on it to achieve composability
        state.setState((){
          n = 2;
        });
      }
    });

    int n = 1;
  }
}

```

