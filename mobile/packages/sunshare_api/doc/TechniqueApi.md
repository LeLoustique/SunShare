# sunshare_api.api.TechniqueApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**health**](TechniqueApi.md#health) | **GET** /health | Health


# **health**
> HealthOut health()

Health

Vérifie que l'API joint la base et que les extensions sont actives.

### Example
```dart
import 'package:sunshare_api/api.dart';

final api = SunshareApi().getTechniqueApi();

try {
    final response = api.health();
    print(response);
} catch on DioException (e) {
    print('Exception when calling TechniqueApi->health: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**HealthOut**](HealthOut.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

