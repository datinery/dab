import 'dart:async';

import 'package:dab/dab.dart';

typedef GetPagedItemsFn<T, P> = FutureOr<List<T>> Function({
  required int limit,
  required int offset,
  required P params,
});

typedef HasNextFn<T> = bool Function(List<T> items);

class PageService<T, K, S extends BaseState<T, K>, P> {
  final S state;
  final int pageSize;
  final GetPagedItemsFn<T, P> getPagedItemsFn;
  final HasNextFn<T>? hasNextFn;

  PageService({
    required this.pageSize,
    required this.getPagedItemsFn,
    required this.state,
    this.hasNextFn,
  });

  bool _hasNext = true;
  int _page = 1;

  bool get hasNext => _hasNext;
  int get page => _page;

  Future<List<T>> getItems({bool paginate = false, required P params}) async {
    if (paginate == true && _hasNext == false) {
      return [];
    }

    if (paginate == false) {
      _page = 1;
      _hasNext = true;
    }

    final limit = pageSize;
    final offset = (_page - 1) * pageSize;

    List<T> res = await getPagedItemsFn(
      limit: limit,
      offset: offset,
      params: params,
    );

    _page += 1;

    if (hasNextFn != null) {
      _hasNext = hasNextFn!(state.items..addAll(res));
    } else {
      _hasNext = res.length > 0;
    }

    if (paginate) {
      state.add(res);
    } else {
      _hasNext = true;
      state.replaceAll(res);
    }

    return res;
  }
}
