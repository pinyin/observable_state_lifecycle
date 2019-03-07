import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:observable_state_lifecycle/observable_state_lifecycle.dart';

void main() {
  group('StateObservable', () {
    testWidgets('should call observer on corresponding phase of lifecycle',
        (tester) async {
      final outputPhase = <StateLifecyclePhase>[];
      await tester.pumpWidget(
          Test(output: (StateLifecyclePhase phase) => outputPhase.add(phase)));
      expect(outputPhase, [
        StateLifecyclePhase.initState,
        StateLifecyclePhase.initState,
        StateLifecyclePhase.didChangeDependencies,
        StateLifecyclePhase.didChangeDependencies
      ]);
      outputPhase.clear();
      await tester.pumpWidget(
          Test(output: (StateLifecyclePhase phase) => outputPhase.add(phase)));
      expect(outputPhase, [
        StateLifecyclePhase.didUpdateWidget,
        StateLifecyclePhase.didUpdateWidget,
      ]);
      outputPhase.clear();
      await tester.pumpWidget(Container());
      expect(outputPhase, [
        StateLifecyclePhase.deactivate,
        StateLifecyclePhase.deactivate,
        StateLifecyclePhase.dispose,
        StateLifecyclePhase.dispose,
      ]);
      outputPhase.clear();
      await tester.pumpWidget(
          Test(output: (StateLifecyclePhase phase) => outputPhase.add(phase)));
      expect(find.text('1'), findsOneWidget);
      await tester.pumpWidget(
          Test(output: (StateLifecyclePhase phase) => outputPhase.add(phase)));
      expect(find.text('3'), findsOneWidget);
    });
  });
}

class Test extends StatefulWidget {
  const Test({this.output});

  final void Function(StateLifecyclePhase phase) output;

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with ObservableStateLifecycle<Test> {
  _TestState() {
    addLifecycleObserver((phase) {
      widget.output(phase);
      if (phase == StateLifecyclePhase.didUpdateWidget)
        setState(() {
          n = 3;
        });
    });
  }

  int n = 1;

  @override
  void initState() {
    super.initState();
    widget.output(StateLifecyclePhase.initState);
  }

  @override
  void didUpdateWidget(Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.output(StateLifecyclePhase.didUpdateWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.output(StateLifecyclePhase.didChangeDependencies);
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.output(StateLifecyclePhase.reassemble);
  }

  @override
  void deactivate() {
    widget.output(StateLifecyclePhase.deactivate);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.output(StateLifecyclePhase.dispose);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(n.toString(), textDirection: TextDirection.ltr);
  }
}
