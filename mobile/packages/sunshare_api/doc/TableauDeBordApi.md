# sunshare_api.api.TableauDeBordApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**readMyCurves**](TableauDeBordApi.md#readmycurves) | **GET** /api/v1/me/curves | Read My Curves
[**readMyDashboard**](TableauDeBordApi.md#readmydashboard) | **GET** /api/v1/me/dashboard | Read My Dashboard


# **readMyCurves**
> DayCurves readMyCurves(date)

Read My Curves

Pas de 30 min de la journée : consommation, production et énergie locale de l'utilisateur.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getTableauDeBordApi();
final Date date = 2013-10-20; // Date | Journée française (défaut : hier)

try {
    final response = api.readMyCurves(date);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TableauDeBordApi->readMyCurves: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **Date**| Journée française (défaut : hier) | [optional] 

### Return type

[**DayCurves**](DayCurves.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readMyDashboard**
> Dashboard readMyDashboard(period)

Read My Dashboard

Chiffres du mois : énergie locale, montant estimé, CO2 évité, taux d'autoconsommation.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getTableauDeBordApi();
final String period = period_example; // String | Mois AAAA-MM (défaut : en cours)

try {
    final response = api.readMyDashboard(period);
    print(response);
} catch on DioException (e) {
    print('Exception when calling TableauDeBordApi->readMyDashboard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**| Mois AAAA-MM (défaut : en cours) | [optional] 

### Return type

[**Dashboard**](Dashboard.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

