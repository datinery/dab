import 'dart:async';

import 'package:dab/dab.dart';
import 'package:flutter/foundation.dart';

class GetPagedItemsParams<P> {
  final int limit;
  final int offset;
  final P customParams;

  const GetPagedItemsParams({
    required this.limit,
    required this.offset,
    required this.customParams,
  });
}

typedef GetPagedItemsFn<T, P> = FutureOr<List<T>> Function(
  GetPagedItemsParams<P> params,
);

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
    List<T> res = await getPagedItemsFn(GetPagedItemsParams(
      limit: limit,
      offset: offset,
      customParams: params,
    ));

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
