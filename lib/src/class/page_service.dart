import 'dart:async';

import 'package:dab/dab.dart';

abstract class PageService<T, K> {
  final PageState<T, K> state;
  final int pageSize;

  PageService({
    required this.pageSize,
    required this.state,
  });

  bool _hasNext = true;
  int _page = 0;

  bool get hasNext => _hasNext;
  int get page => _page;

  FutureOr<List<T>> getPagedItems({required int pageSize, required int offset});

  Future<List<T>> getItems({required bool paginate}) async {
    if (paginate == false) {
      _page = 0;
      _hasNext = true;
    }

    if (paginate == true && _hasNext == false) {
      return [];
    }

    List<T> res =
        await getPagedItems(pageSize: pageSize, offset: _page * pageSize);

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
