# sunshare_api.api.BouclesApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cancelMembership**](BouclesApi.md#cancelmembership) | **DELETE** /api/v1/me/memberships/{membership_id} | Cancel Membership
[**joinLoop**](BouclesApi.md#joinloop) | **POST** /api/v1/loops/{loop_id}/join | Join Loop
[**listAvailableLoops**](BouclesApi.md#listavailableloops) | **GET** /api/v1/loops/available | List Available Loops
[**listMyMemberships**](BouclesApi.md#listmymemberships) | **GET** /api/v1/me/memberships | List My Memberships
[**readLoop**](BouclesApi.md#readloop) | **GET** /api/v1/loops/{loop_id} | Read Loop


# **cancelMembership**
> cancelMembership(membershipId)

Cancel Membership

Annule une demande encore en attente (la sortie d'un membre actif viendra plus tard).

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getBouclesApi();
final String membershipId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.cancelMembership(membershipId);
} catch on DioException (e) {
    print('Exception when calling BouclesApi->cancelMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **membershipId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinLoop**
> MembershipOut joinLoop(loopId, joinRequest)

Join Loop

Demande d'adhésion d'un compteur ; validée ensuite par l'administrateur de la PMO.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getBouclesApi();
final String loopId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final JoinRequest joinRequest = ; // JoinRequest | 

try {
    final response = api.joinLoop(loopId, joinRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BouclesApi->joinLoop: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopId** | **String**|  | 
 **joinRequest** | [**JoinRequest**](JoinRequest.md)|  | 

### Return type

[**MembershipOut**](MembershipOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAvailableLoops**
> BuiltList<AvailableLoop> listAvailableLoops()

List Available Loops

Boucles ouvertes que les compteurs libres de l'utilisateur peuvent rejoindre.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getBouclesApi();

try {
    final response = api.listAvailableLoops();
    print(response);
} catch on DioException (e) {
    print('Exception when calling BouclesApi->listAvailableLoops: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;AvailableLoop&gt;**](AvailableLoop.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMyMemberships**
> BuiltList<MembershipOut> listMyMemberships()

List My Memberships

Demandes et participations de l'utilisateur, toutes boucles et tous statuts confondus.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getBouclesApi();

try {
    final response = api.listMyMemberships();
    print(response);
} catch on DioException (e) {
    print('Exception when calling BouclesApi->listMyMemberships: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;MembershipOut&gt;**](MembershipOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readLoop**
> LoopOut readLoop(loopId)

Read Loop

Détail d'une boucle, réservé à ses membres (demande en cours comprise) et à l'administrateur.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getBouclesApi();
final String loopId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.readLoop(loopId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BouclesApi->readLoop: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopId** | **String**|  | 

### Return type

[**LoopOut**](LoopOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

