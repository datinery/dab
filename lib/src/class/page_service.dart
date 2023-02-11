import 'dart:async';

import 'package:dab/dab.dart';

typedef GetPagedItemsFn<T, P> = FutureOr<List<T>> Function({
  required int pageSize,
  required int offset,
  required P params,
});

typedef HasNextFn<T> = bool Function(List<T> items);

class PageService<T, K, S extends BaseState<T, K>, P> {
  final S state;
  final int pageSize;
  final GetPagedItemsFn<T, P> getPagedItemsFn;

  PageService({
    required this.pageSize,
    required this.getPagedItemsFn,
    required this.state,
  });

  bool _hasNext = true;
  int _page = 0;

  bool get hasNext => _hasNext;
  int get page => _page;

  Future<List<T>> getItems({required bool paginate, required P params}) async {
    if (paginate == false) {
      _page = 0;
      _hasNext = true;
    }

    if (paginate == true && _hasNext == false) {
      return [];
    }

    List<T> res = await getPagedItemsFn(
      pageSize: pageSize,
      offset: _page * pageSize,
      params: params,
    );

    _page += 1;
    _hasNext = res.length > 0;

    if (paginate) {
      state.add(res);
    } else {
      state.replaceAll(res);
    }

    return res;
  }
}
