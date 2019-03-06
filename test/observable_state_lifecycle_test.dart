import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:observable_state_lifecycle/observable_state_lifecycle.dart';

void main() {
  group('StateObservable', () {
    testWidgets('should call observer on corresponding phase of lifecycle',
        (tester) async {
      final output = <Phase>[];
      await tester.pumpWidget(Test(output: (Phase phase) => output.add(phase)));
      expect(output, [
        Phase.initState,
        Phase.initState,
        Phase.didChangeDependencies,
        Phase.didChangeDependencies
      ]);
      output.clear();
      await tester.pumpWidget(Test(output: (Phase phase) => output.add(phase)));
      expect(output, [
        Phase.didUpdateWidget,
        Phase.didUpdateWidget,
      ]);
      output.clear();
      await tester.pumpWidget(Container());
      expect(output, [
        Phase.deactivate,
        Phase.deactivate,
        Phase.dispose,
        Phase.dispose,
      ]);
    });
  });
}

class Test extends StatefulWidget {
  const Test({this.output});

  final void Function(Phase phase) output;

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with ObservableStateLifecycle<Test> {
  _TestState() {
    addLifecycleObserver(StateLifecycleSubject<Test>(
      onInitState: () {
        widget.output(Phase.initState);
      },
      onDidUpdateWidget: (Test oldWidget) {
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

  @override
  void initState() {
    super.initState();
    widget.output(Phase.initState);
  }

  @override
  void didUpdateWidget(Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.output(Phase.didUpdateWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.output(Phase.didChangeDependencies);
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.output(Phase.reassemble);
  }

  @override
  void deactivate() {
    widget.output(Phase.deactivate);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.output(Phase.dispose);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

enum Phase {
  initState,
  didUpdateWidget,
  didChangeDependencies,
  reassemble,
  deactivate,
  dispose,
}
