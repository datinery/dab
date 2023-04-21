import 'dart:async';

import 'package:dab/dab.dart';

class CursorPageResponse<T, C> {
  final List<T> list;
  final C? currentCursor;

  const CursorPageResponse({
    required this.list,
    required this.currentCursor,
  });

  factory CursorPageResponse.empty() =>
      const CursorPageResponse(list: [], currentCursor: null);
}

abstract class CursorPageService<T, K, C> {
  final BaseState<T, K> state;

  CursorPageService({required this.state});

  C? _previousCursor;
  bool _hasNext = true;

  C? get previousCursor => _previousCursor;
  bool get hasNext => _hasNext;

  FutureOr<CursorPageResponse<T, C>> getCursorPagedItems({C? previousCursor});

  Future<List<T>> getItems({bool paginate = false}) async {
    if (paginate == false) {
      // reset
      _hasNext = true;
      _previousCursor = null;
    }

    if (paginate == true && _hasNext == false) {
      return [];
    }

    CursorPageResponse<T, C> res =
        await getCursorPagedItems(previousCursor: _previousCursor);

    _hasNext = res.list.length > 0;
    _previousCursor = res.currentCursor;

    if (paginate) {
      state.add(res.list);
    } else {
      state.replaceAll(res.list);
    }

    return res.list;
  }
}
