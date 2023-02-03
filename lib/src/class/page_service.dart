import 'dart:async';

import 'package:dab/dab.dart';
import 'package:flutter/foundation.dart';

typedef GetPagedItemsFn<T, P> = FutureOr<List<T>> Function({
  required int limit,
  required int offset,
  required P params,
});

class PageService<T, S extends BaseState, P> {
  @protected
  late S state;
  final int pageSize;
  final GetPagedItemsFn<T, P> getPagedItemsFn;

  PageService({required this.pageSize, required this.getPagedItemsFn});

  bool _hasNext = true;
  int _page = 1;

  Future<List<T>> getItems({bool paginate = false, required P params}) async {
    if (paginate == true && _hasNext == false) {
      return [];
    }

    if (paginate == false) {
      _page = 1;
      _hasNext = true;
    }

    final limit = pageSize + 1;
    final offset = (_page - 1) * pageSize;
    List<T> res = await getPagedItemsFn(
      limit: limit,
      offset: offset,
      params: params,
    );

    _page += 1;
    _hasNext = res.length > pageSize;

    if (_hasNext) {
      res = res.sublist(0, pageSize);
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
