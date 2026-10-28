# sunshare_api.api.AdressesApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**searchAddresses**](AdressesApi.md#searchaddresses) | **GET** /api/v1/addresses | Search Addresses


# **searchAddresses**
> BuiltList<AddressSuggestion> searchAddresses(q)

Search Addresses

Suggestions d'adresses précises (numéro ou lieu-dit) pendant la saisie.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdressesApi();
final String q = q_example; // String | 

try {
    final response = api.searchAddresses(q);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdressesApi->searchAddresses: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | 

### Return type

[**BuiltList&lt;AddressSuggestion&gt;**](AddressSuggestion.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

