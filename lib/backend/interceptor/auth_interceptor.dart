import 'package:aandm/backend/service/auth_backend_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/models/interceptor_contract.dart';
import 'package:http_interceptor/models/retry_policy.dart';

//IMP http_interceptor and http plugin used for this

// 1 Interceptor class
class AuthorizationInterceptor implements InterceptorContract {
  // We need to intercept request
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    try {
      if (!request.headers.containsKey('content-type')) {
        request.headers['content-type'] = 'application/json; charset=utf-8';
      }
      if (!request.headers.containsKey('Cache-Control')) {
        request.headers['Cache-Control'] =
            'no-cache, no-store, must-revalidate, post-check=0, pre-check=0';
      }
      if (!request.headers.containsKey('Pragma')) {
        request.headers['Pragma'] = 'no-cache';
      }
      if (!request.headers.containsKey('Expires')) {
        request.headers['Expires'] = '0';
      }

      if (AuthBackend().loggedInUser?.accessToken != null &&
          !request.headers.containsKey('authorization')) {
        request.headers['authorization'] =
            'Bearer ${AuthBackend().loggedInUser!.accessToken}';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error beim Intercepten der Anfrage');
    }

    return request;
  }

  // Currently we do not have any need to intercept response
  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() async => true;
  @override
  Future<bool> shouldInterceptResponse() async => true;
}

//This is where request retry
class ExpiredTokenRetryPolicy extends RetryPolicy {
  //Number of retry
  @override
  // ignore: overridden_fields
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    //This is where we need to update our token on 401 response
    if (response.statusCode == 401 &&
        AuthBackend().loggedInUser?.refreshToken != null &&
        !response.request!.url.toString().contains('/refresh') &&
        !response.request!.url.toString().contains('/login')) {
      //Refresh your token here. Make refresh token method where you get new token from
      //API and set it to your local data
      await AuthBackend().postRefresh(); //Find below the code of this function
      return true;
    }
    return false;
  }
}
