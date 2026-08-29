# typed_isolates

以 **type-safe** 的方式建立 isolates 並與它們通訊。

Dart 原生 `Isolate` / `SendPort` API 沒有型別；每個 message 都是 `dynamic`。
這個 package 包裝樣板程式碼，提供 connector，讓你能使用 statically-typed send 與 receive channels。

## 概念

三個 type parameters 描述 isolate：

- `R`：main isolate 從 child **接收** 的 message type。
- `S`：main isolate **送到** child 的 message type。
- `P`：child startup 時傳入的 parameter type。

## 使用方式

使用 `TypedIsolates.startIsolate` spawn isolate。它會回傳 `IsolateConnector<R, S>`，用來與 child 通訊。

```dart
import 'package:typed_isolates/typed_isolates.dart';

Future<void> main() async {
  // R = int (received), S = String (sent), P = String (start param)
  final connector = await TypedIsolates.startIsolate<int, String, String>(
    param: 'greeting',
    task: _childTask,
  );

  // Listen to messages coming back from the isolate.
  connector.receiveFromIsolate.listen((value) {
    print('main received: $value');
  });

  // Send messages to the isolate.
  connector.sendToIsolate('hello');
  connector.sendToIsolate('world');

  // Shut it down when done.
  await Future.delayed(const Duration(seconds: 1));
  connector.isolate.kill();
}

// Runs inside the spawned isolate.
Future<void> _childTask(
  Stream<String> receiveFromMain,
  void Function(int) sendToMain,
  String param,
) async {
  print('child started with param: $param');
  await for (final message in receiveFromMain) {
    sendToMain(message.length); // reply with the length of each message
  }
}
```

`IsolateConnector` exposes:

- `receiveFromIsolate`：來自 child 的 broadcast `Stream<R>`。
- `sendToIsolate(S message)`：將 typed message 送到 child。
- `isolate`：底層 `Isolate`，例如呼叫 `.kill()` 停止它。

## Request / response tasks

若要使用 request-and-reply pattern，也就是讓每個 response 對應到它的 request，package 提供一小組 DTOs，可作為你的 `S` / `R` payloads：

- `IsolateTask<T>`：帶有 `id` 與 `data` payload 的 request。
- `IsolateTaskResult<T>` (`IsolateTaskSuccessResult` / `IsolateTaskErrorResult`)：對應 request `id` 的單一 response。
- `IsolateTaskStreamResult<T>`：streamed response (`.event`、`.done`、`.error`)，用於會隨時間 emit 多個 values 的 tasks；另有 `IsolateTaskStreamAckResult` 用於 acknowledge event receipt。

當 connector 發送 bare `IsolateTask`s 並接收 `IsolateTaskStreamResult`s 時，`sendTaskAndListenStream` 會完成整個 round-trip：assign id、send task，並回傳 results 的 `Stream`：

```dart
// connection: IsolateConnector<IsolateTaskStreamResult<int>, IsolateTask<MyTask>>
final Stream<int> results = connection.sendTaskAndListenStream(
  task: MyTask('my input'),
);
```
