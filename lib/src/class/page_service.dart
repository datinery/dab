import 'package:dab/dab.dart';
import 'package:flutter/foundation.dart';

class PagedResponse<T> {
  final List<T> data;
  final bool hasNext;

  PagedResponse({required this.data, required this.hasNext});
}

abstract class PageService<T, S extends BaseState> {
  @protected
  late S state;

  bool _hasSetIsLoaded = false;
  bool _hasNext = true;
  int _page = 1;

  Future<PagedResponse<T>> requestPagination<P>(int page, P? params);

  Future<List<T>?> getItems<P>({bool paginate = false, P? params}) async {
    if (paginate == true && _hasNext == false) {
      return null;
    }

    if (paginate == false) {
      _page = 1;
      _hasNext = true;
    }

    var res;

    try {
      res = await requestPagination<P>(_page, params);
      _page += 1;
    } finally {
      if (!_hasSetIsLoaded) {
        _hasSetIsLoaded = true;
      }
    }

    _hasNext = res.hasNext;

    if (paginate) {
      state.add(res.data);
    } else {
      state.replaceAll(res.data);
    }

    return res.data;
  }
}
