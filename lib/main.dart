import 'package:cli_util/cli_logging.dart';

final logger = Logger.standard();
void main(List<String> args) {
  final elements = int.parse(args[0]);
  logger.stdout('Bogosort ($elements elements)');

  var shuffles = 0;
  final list = List.generate(elements, (i) => i)..shuffle();
  final stopwatch = Stopwatch()..start();

  int getShufflesPerSecond() => stopwatch.elapsedMilliseconds == 0
      ? 0
      : (shuffles / (stopwatch.elapsedMilliseconds / 1000)).round();

  DateTime? lastLogTime;
  void tryLogProgress() {
    final now = DateTime.now();
    if (lastLogTime != null &&
        lastLogTime!.difference(now).inMilliseconds.abs() < 125) {
      return;
    }

    final sections = [
      '${stopwatch.elapsedMilliseconds} ms',
      '$shuffles shuffles',
      '${getShufflesPerSecond()} s/s'
    ];
    logger.write(
      sections.map((section) => '${section.padLeft(20)} | ').join() + '\r',
    );
    lastLogTime = DateTime.now();
  }

  while (!list.isSorted) {
    tryLogProgress();
    list.shuffle();
    shuffles++;
  }
  stopwatch.stop();

  logger.stdout(
    'Done. Took ${stopwatch.elapsedMilliseconds} ms and $shuffles shuffles '
    '(${getShufflesPerSecond()} shuffles/second).'
    '                              ',
  );
}

extension on List<int> {
  bool get isSorted {
    for (var i = 1; i < length; i++) {
      if (this[i] < this[i - 1]) {
        return false;
      }
    }

    return true;
  }
}
