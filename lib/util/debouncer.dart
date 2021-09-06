import 'dart:async';
import 'dart:ui';

class Debouncer {
  Duration delay;
  Timer _timer;
  VoidCallback _callback;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void debounce(VoidCallback callback) {
    this._callback = callback;

    this.cancel();
    _timer = new Timer(delay, this.flush);
  }

  bool isActive() {
    return _timer?.isActive ?? false;
  }

  void cancel() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  void flush() {
    this._callback();
    this.cancel();
  }
}
