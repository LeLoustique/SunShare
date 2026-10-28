# sunshare_api.api.AdminApi

## Load the API package
```dart
import 'package:sunshare_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adminApproveMember**](AdminApi.md#adminapprovemember) | **POST** /api/v1/admin/loops/{loop_id}/members/{member_id}/approve | Admin Approve Member
[**adminCreateLoop**](AdminApi.md#admincreateloop) | **POST** /api/v1/admin/loops | Admin Create Loop
[**adminListLoops**](AdminApi.md#adminlistloops) | **GET** /api/v1/admin/loops | Admin List Loops
[**adminListMembers**](AdminApi.md#adminlistmembers) | **GET** /api/v1/admin/loops/{loop_id}/members | Admin List Members
[**adminRejectMember**](AdminApi.md#adminrejectmember) | **POST** /api/v1/admin/loops/{loop_id}/members/{member_id}/reject | Admin Reject Member
[**adminUpdateLoop**](AdminApi.md#adminupdateloop) | **PATCH** /api/v1/admin/loops/{loop_id} | Admin Update Loop


# **adminApproveMember**
> AdminMemberOut adminApproveMember(loopId, memberId, approveRequest)

Admin Approve Member

Valide l'adhésion et fixe la date d'entrée dans l'opération.  Pas de nouveau contrôle du périmètre : une demande en attente y est déjà prise en compte.

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdminApi();
final String loopId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String memberId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ApproveRequest approveRequest = ; // ApproveRequest | 

try {
    final response = api.adminApproveMember(loopId, memberId, approveRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminApi->adminApproveMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopId** | **String**|  | 
 **memberId** | **String**|  | 
 **approveRequest** | [**ApproveRequest**](ApproveRequest.md)|  | 

### Return type

[**AdminMemberOut**](AdminMemberOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminCreateLoop**
> AdminLoopOut adminCreateLoop(loopCreate)

Admin Create Loop

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdminApi();
final LoopCreate loopCreate = ; // LoopCreate | 

try {
    final response = api.adminCreateLoop(loopCreate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminApi->adminCreateLoop: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopCreate** | [**LoopCreate**](LoopCreate.md)|  | 

### Return type

[**AdminLoopOut**](AdminLoopOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListLoops**
> BuiltList<AdminLoopOut> adminListLoops()

Admin List Loops

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdminApi();

try {
    final response = api.adminListLoops();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminApi->adminListLoops: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;AdminLoopOut&gt;**](AdminLoopOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminListMembers**
> BuiltList<AdminMemberOut> adminListMembers(loopId)

Admin List Members

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdminApi();
final String loopId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminListMembers(loopId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminApi->adminListMembers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopId** | **String**|  | 

### Return type

[**BuiltList&lt;AdminMemberOut&gt;**](AdminMemberOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminRejectMember**
> AdminMemberOut adminRejectMember(loopId, memberId)

Admin Reject Member

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdminApi();
final String loopId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String memberId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.adminRejectMember(loopId, memberId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminApi->adminRejectMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopId** | **String**|  | 
 **memberId** | **String**|  | 

### Return type

[**AdminMemberOut**](AdminMemberOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adminUpdateLoop**
> AdminLoopOut adminUpdateLoop(loopId, loopUpdate)

Admin Update Loop

### Example
```dart
import 'package:sunshare_api/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = SunshareApi().getAdminApi();
final String loopId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final LoopUpdate loopUpdate = ; // LoopUpdate | 

try {
    final response = api.adminUpdateLoop(loopId, loopUpdate);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdminApi->adminUpdateLoop: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loopId** | **String**|  | 
 **loopUpdate** | [**LoopUpdate**](LoopUpdate.md)|  | 

### Return type

[**AdminLoopOut**](AdminLoopOut.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

