import 'dart:io';

/// Wall-clock limits in unit tests are loose (×3) so a busy machine doesn't fail them; STRICT_TIMING=1 checks the real limit. Real timings live in test/bench.
int timeLimit(int ms) => Platform.environment['STRICT_TIMING'] == '1' ? ms : ms * 3;
