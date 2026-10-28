# sunshare_api.api.CompteursApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createMeter**](CompteursApi.md#createmeter) | **POST** /api/v1/meters | Create Meter
[**deleteMeter**](CompteursApi.md#deletemeter) | **DELETE** /api/v1/meters/{meter_id} | Delete Meter
[**listMeters**](CompteursApi.md#listmeters) | **GET** /api/v1/meters | List Meters


# **createMeter**
> MeterOut createMeter(meterCreate)

Create Meter

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getCompteursApi();
final MeterCreate meterCreate = ; // MeterCreate | 

try {
    final response = api.createMeter(meterCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompteursApi->createMeter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **meterCreate** | [**MeterCreate**](MeterCreate.md)|  | 

### Return type

[**MeterOut**](MeterOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMeter**
> deleteMeter(meterId)

Delete Meter

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getCompteursApi();
final String meterId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.deleteMeter(meterId);
} catch on DioException (e) {
    print('Exception when calling CompteursApi->deleteMeter: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **meterId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMeters**
> BuiltList<MeterOut> listMeters()

List Meters

Compteurs de l'utilisateur connecté (jamais ceux des autres).

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getCompteursApi();

try {
    final response = api.listMeters();
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompteursApi->listMeters: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;MeterOut&gt;**](MeterOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

