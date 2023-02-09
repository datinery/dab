import 'dart:async';

import 'package:dab/dab.dart';

typedef GetCursorPagedItemsFn<T, C, P> = FutureOr<CursorPageResponse<T, C>>
    Function({
  required C? cursor,
  required P params,
});

class CursorPageResponse<T, C> {
  final List<T> list;
  final C? cursor;

  const CursorPageResponse({
    required this.list,
    required this.cursor,
  });
}

class CursorPageService<T, K, C, S extends BaseState<T, K>, P> {
  final S state;
  final GetCursorPagedItemsFn<T, C, P> getCursorPagedItemsFn;

  CursorPageService({
    required this.getCursorPagedItemsFn,
    required this.state,
  });

  C? _cursor;
  bool _hasNext = true;

  C? get lastCursor => _cursor;
  bool get hasNext => _hasNext;

  Future<List<T>> getItems({bool paginate = false, required P params}) async {
    if (paginate == false) {
      // reset
      _hasNext = true;
      _cursor = null;
    }

    if (paginate == true && _hasNext == false) {
      return [];
    }

    CursorPageResponse<T, C> res = await getCursorPagedItemsFn(
      cursor: _cursor,
      params: params,
    );

    _hasNext = res.list.length > 0;
    _cursor = res.cursor;

    if (paginate) {
      state.add(res.list);
    } else {
      state.replaceAll(res.list);
    }

    return res.list;
  }
}
