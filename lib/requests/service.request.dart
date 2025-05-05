import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:huops/constants/api.dart';
import 'package:huops/models/api_response.dart';
import 'package:huops/models/service.dart';
import 'package:huops/services/auth.service.dart';
import 'package:huops/services/http.service.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/event_ticket_model/event_ticket.dart';

class ServiceRequest extends HttpService {
  //
  Future<List<Service>> getServices({
    Map<String, dynamic>? queryParams,
    int? page = 1,
  }) async {
    final apiResult = await get(
      Api.services,
      queryParameters: {
        ...(queryParams != null ? queryParams : {}),
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      if (page == null || page == 0) {
        return (apiResponse.body as List)
            .map((jsonObject) => Service.fromJson(jsonObject))
            .toList();
      } else {
        return apiResponse.data
            .map((jsonObject) => Service.fromJson(jsonObject))
            .toList();
      }
    }

    throw apiResponse.message;
  }

  //
  Future<Service> serviceDetails(int id) async {
    //
    final apiResult = await get("${Api.services}/$id");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      // print("****************************** are ${apiResponse.body}");

      return Service.fromJson(apiResponse.body);
    }

    throw apiResponse.message;
  }

  Future<ApiResponse> deleteService(Service service) async {
    final apiResult = await delete(
      Api.services + "/${service.id}",
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updateService(
    Service service, {
    Map<String, dynamic>? data,
    List<File>? photos,
  }) async {
    final postBody = {
      "_method": "PUT",
      ...(data == null ? service.toJson() : data),
      "vendor_id": (await AuthServices.getCurrentVendor(force: true)).id,
    };

    FormData formData = FormData.fromMap(postBody);
    for (File file in photos ?? []) {
      formData.files.addAll([
        MapEntry("photos[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    final apiResult = await postWithFiles(
      Api.services + "/${service.id}",
      null,
      formData: formData,
    );

    //
    return ApiResponse.fromResponse(apiResult);
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  Future<ApiResponse> newService(
      {required Map<String, dynamic> data,
      List<File>? photos,
      List<TimeOfDay>? selectedTimes,
      List<EventTicket>? eventsTickets}) async {
    /// add event time to the body
    Map<String, String>? eventTime = {};
    //  add for each index
    selectedTimes?.asMap().forEach((index, time) {
      eventTime.addAll({"event_time[$index][time]": formatTime(time)});
    });

    /// add ticket type to the body
    Map<String, String>? ticketName = {};
    eventsTickets?.asMap().forEach((index, ticket) {
      ticketName.addAll({"ticket_type[$index][name]": ticket.name});
    });

    /// add ticket price to the body
    Map<String, dynamic>? ticketPrice = {};
    eventsTickets?.asMap().forEach((index, ticket) {
      ticketPrice
          .addAll({"ticket_type[$index][price]": ticket.price.toString()});
    });

    final postBody = {
      ...data,
      ...eventTime,
      ...ticketName,
      ...ticketPrice,
      "vendor_id": (await AuthServices.getCurrentVendor(force: true)).id,
    };

    FormData formData = FormData.fromMap(postBody);
    for (File file in photos ?? []) {
      //  send photos[]:file.path
      formData.files.addAll([
        MapEntry("photos[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    final apiResult = await postWithFiles(
      Api.services,
      null,
      formData: formData,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<String>> getServiceDurations() async {
    final apiResult = await get(Api.serviceDurations);

    final apiResponse = ApiResponse.fromResponse(apiResult);

    if (apiResponse.allGood) {
      return (apiResponse.body as List).map((e) => e.toString()).toList();
    }

    throw apiResponse.message;
  }
}
