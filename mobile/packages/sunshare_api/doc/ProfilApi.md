# sunshare_api.api.ProfilApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**readMe**](ProfilApi.md#readme) | **GET** /api/v1/me | Read Me


# **readMe**
> UserOut readMe()

Read Me

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getProfilApi();

try {
    final response = api.readMe();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProfilApi->readMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserOut**](UserOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

