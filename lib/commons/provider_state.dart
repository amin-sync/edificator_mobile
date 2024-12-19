class ProviderState<T> {
  bool isLoading;
  bool success;
  T? response;

  ProviderState({this.isLoading = false, this.success = false, this.response});
}
