import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/user.dart';
import 'package:huops/services/http.service.dart';

class UserRequest extends HttpService {
  //
  Future<List<User>> getUsers({
    String? role,
  }) async {
    final apiResult = await get(
      Api.users,
      queryParameters: {
        "role": role,
      },
      // "/all/drivers"
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return User.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }
}
