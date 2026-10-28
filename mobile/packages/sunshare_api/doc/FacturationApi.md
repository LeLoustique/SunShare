# sunshare_api.api.FacturationApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**downloadStatementPdf**](FacturationApi.md#downloadstatementpdf) | **GET** /api/v1/statements/{statement_id}/pdf | Download Statement Pdf
[**listMyStatements**](FacturationApi.md#listmystatements) | **GET** /api/v1/me/statements | List My Statements
[**readStatement**](FacturationApi.md#readstatement) | **GET** /api/v1/statements/{statement_id} | Read Statement


# **downloadStatementPdf**
> Uint8List downloadStatementPdf(statementId)

Download Statement Pdf

PDF du relevé : celui archivé à l'émission, ou un aperçu « BROUILLON » pour l'administrateur.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getFacturationApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.downloadStatementPdf(statementId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacturationApi->downloadStatementPdf: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMyStatements**
> BuiltList<StatementOut> listMyStatements()

List My Statements

Relevés émis de l'utilisateur, du plus récent au plus ancien (brouillons cachés).

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getFacturationApi();

try {
    final response = api.listMyStatements();
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacturationApi->listMyStatements: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;StatementOut&gt;**](StatementOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readStatement**
> StatementOut readStatement(statementId)

Read Statement

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getFacturationApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.readStatement(statementId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling FacturationApi->readStatement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  | 

### Return type

[**StatementOut**](StatementOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

