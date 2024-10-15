class CachedObject<T> {

  T _object;
  final int _validFor; // in ms

  int _lastUpdate = DateTime.now().millisecondsSinceEpoch;
  int _lastFetch = DateTime.now().millisecondsSinceEpoch;

  CachedObject ({
    required T object,
    required int validFor,
  }) :_object = object, _validFor = validFor;

  /// Get the object
  T get() {
    _lastFetch = DateTime.now().millisecondsSinceEpoch;
    return _object;
  }

  /// Update cached object with new data
  void set(T object) {
    _lastFetch = DateTime.now().millisecondsSinceEpoch;
    _lastUpdate = _lastFetch;
    _object = object;
  }

  /// Invalidate cached object
  void invalidate() {
    this._lastUpdate = 0;
  }

  /// Check if cached object is still valid
  bool isValid() {
    int now = DateTime.now().millisecondsSinceEpoch;
    return now - _lastUpdate < _validFor;
  }
}
