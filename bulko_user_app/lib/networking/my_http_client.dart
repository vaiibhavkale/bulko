import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return new MyHttpClient(super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true);
  }
}

class MyHttpClient implements HttpClient {
  HttpClient _realClient;

  MyHttpClient(this._realClient);

  @override
  bool get autoUncompress => _realClient.autoUncompress;

  @override
  set autoUncompress(bool value) => _realClient.autoUncompress = value;

  @override
  Duration? get connectionTimeout => _realClient.connectionTimeout;

  @override
  set connectionTimeout(Duration? value) =>
      _realClient.connectionTimeout = value;

  @override
  Duration get idleTimeout => _realClient.idleTimeout;

  @override
  set idleTimeout(Duration value) => _realClient.idleTimeout = value;

  @override
  int? get maxConnectionsPerHost => _realClient.maxConnectionsPerHost;

  @override
  set maxConnectionsPerHost(int? value) =>
      _realClient.maxConnectionsPerHost = value;

  @override
  String? get userAgent => _realClient.userAgent;

  @override
  set userAgent(String? value) => _realClient.userAgent = value;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) =>
      _realClient.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(String host, int port, String realm,
      HttpClientCredentials credentials) =>
      _realClient.addProxyCredentials(host, port, realm, credentials);

  @override
  void set authenticate(
      Future<bool> Function(Uri url, String scheme, String? realm)? f) =>
      _realClient.authenticate = f;

  @override
  void set authenticateProxy(
      Future<bool> Function(
          String host, int port, String scheme, String? realm)?
      f) =>
      _realClient.authenticateProxy = f;

  @override
  void set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)?
      callback) =>
      _realClient.badCertificateCallback = callback;

  @override
  void close({bool force = false}) => _realClient.close(force: force);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _realClient.delete(host, port, path);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _realClient.deleteUrl(url);

  @override
  void set findProxy(String Function(Uri url)? f) => _realClient.findProxy = f;

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _updateHeaders(_realClient.get(host, port, path));

  Future<HttpClientRequest> _updateHeaders(
      Future<HttpClientRequest> httpClientRequest) async {
    return (await httpClientRequest)
      ..headers.add("Access-Control-Allow-Origin", "*")
      ..headers.add("Access-Control-Allow-Headers",
          "Origin, X-Requested-With, Content-Type, Accept, Authorization")
      ..headers
          .add("Access-Control-Allow-Methods", "PUT, POST, DELETE, GET, PATCH");
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      _updateHeaders(_realClient.getUrl(url.replace(path: url.path)));

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _realClient.head(host, port, path);

  @override
  Future<HttpClientRequest> headUrl(Uri url) => _realClient.headUrl(url);

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) =>
      _realClient.open(method, host, port, path);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      _realClient.openUrl(method, url);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _realClient.patch(host, port, path);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _realClient.patchUrl(url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _realClient.post(host, port, path);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _realClient.postUrl(url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _realClient.put(host, port, path);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => _realClient.putUrl(url);

  @override
  Future<ConnectionTask<Socket>> Function(Uri url, String proxyHost, int proxyPort)? connectionFactory;

  @override
  Function(String line)? keyLog;
}
