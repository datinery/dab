import 'dart:async';

import 'package:dab/dab.dart';

class CursorPageResponse<T, C> {
  final List<T> list;
  final C? lastCursor;

  const CursorPageResponse({
    required this.list,
    required this.lastCursor,
  });

  factory CursorPageResponse.empty() =>
      const CursorPageResponse(list: [], lastCursor: null);
}

abstract class CursorPageService<T, K, C> {
  final PageState<T, K> state;

  CursorPageService({required this.state});

  C? _lastCursor;

  C? get lastCursor => _lastCursor;
  bool get hasNext => _lastCursor != null;

  FutureOr<CursorPageResponse<T, C>> getCursorPagedItems({C? lastCursor});

  Future<List<T>> getItems({bool paginate = false}) async {
    if (!paginate) {
      _lastCursor = null;
    }

    if (paginate && !hasNext) {
      return [];
    }

    CursorPageResponse<T, C> res =
        await getCursorPagedItems(lastCursor: _lastCursor);

    _lastCursor = res.lastCursor;

    if (paginate) {
      state.add(res.list);
    } else {
      state.replaceAll(res.list);
    }

    return res.list;
  }
}
