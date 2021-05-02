import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase provider, Object? value) {
    print('Provider Created');
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$value"
}''');
  }

  @override
  void didUpdateProvider(ProviderBase provider, Object? newValue) {
    print('Provider Updated');
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }

  @override
  void didDisposeProvider(ProviderBase provider) {
    print('Provider Disposed');
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
}''');
  }
}
