import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/package_type.dart';
import 'package:huops/models/package_type_pricing.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/http.service.dart';

class PackageTypePricingRequest extends HttpService {
  //
  Future<List<PackageTypePricing>> getPricings() async {
    final apiResult = await get(Api.packagePricing);
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List).map((jsonObject) {
        return PackageTypePricing.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<ApiResponse> newPricing(Map<String, dynamic> data) async {
    final apiResult = await post(
      Api.packagePricing,
      {...data, "vendor_id": AuthServices.currentVendor?.id},
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> updateDetails(
    PackageTypePricing packageTypePricing, {
    Map<String, dynamic>? data,
  }) async {
    final apiResult = await patch(
      Api.packagePricing + "/${packageTypePricing.id}",
      data == null ? packageTypePricing.toJson() : data,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> deletePricing(
    PackageTypePricing packageTypePricing,
  ) async {
    final apiResult = await delete(
      Api.packagePricing + "/${packageTypePricing.id}",
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<List<PackageType>> getPackageTypes() async {
    final apiResult = await get(Api.packageTypes);
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List).map((jsonObject) {
        return PackageType.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }
}
