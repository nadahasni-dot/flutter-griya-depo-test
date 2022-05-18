import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../constants/api_endpoint.dart';
import '../models/achievement_model.dart';
import '../services/network_service.dart';
import '../services/response_call.dart';

class AchievementProvider extends ChangeNotifier {
  ResponseCall apiCall = ResponseCall.loading('loading');
  List<Achievement> listAchievements = [];

  TextEditingController inputAchievement = TextEditingController();
  TextEditingController inputLevel = TextEditingController();
  TextEditingController inputOrganizer = TextEditingController();
  TextEditingController inputYear = TextEditingController();

  resetInput() {
    inputAchievement.clear();
    inputLevel.clear();
    inputOrganizer.clear();
    inputYear.clear();
  }

  Future<void> getListAchievement([bool isFirst = true]) async {
    apiCall = ResponseCall.loading('loading');

    if (!isFirst) {
      notifyListeners();
    }

    try {
      final response =
          await NetworkService.get(ApiEndpoint.getAchievements, null);

      if (response['success']) {
        final result = AchievementModel.fromJson(response);

        listAchievements.clear();
        listAchievements.addAll(result.data);

        apiCall = ResponseCall.completed(response['message']);
      } else {
        apiCall = ResponseCall.error(response['message']);
      }
    } catch (e) {
      log('ERROR GET DATA: ${e.toString()}');
      apiCall = ResponseCall.error(e.toString());
    }

    notifyListeners();
  }

  Future<bool> createAchievement({
    required String name,
    required String level,
    required String organizer,
    required String year,
    required File file,
  }) async {
    final params = {
      'achievement_name': name,
      'level': level,
      'organizer': organizer,
      'year': year,
    };

    try {
      final response = await NetworkService.postWithImages(
        ApiEndpoint.createAchievements,
        params,
        [file],
      );

      if (response['success']) {
        resetInput();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('ERROR CREATE: ${e.toString()}');
      return false;
    }
  }

  Future<bool> editAchievement({
    required int id,
    required String name,
    required String level,
    required String organizer,
    required String year,
    required File file,
  }) async {
    final params = {
      'id': id.toString(),
      'achievement_name': name,
      'level': level,
      'organizer': organizer,
      'year': year,
    };

    try {
      final response = await NetworkService.postWithImages(
        ApiEndpoint.updateAchievements,
        params,
        [file],
      );

      if (response['success']) {
        resetInput();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('ERROR UPDATE: ${e.toString()}');
      return false;
    }
  }

  Future<bool> deleteAchievement(int id) async {
    try {
      final response = await NetworkService.post(
        ApiEndpoint.deleteAchievements,
        {'id': id.toString()},
      );

      if (response['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('ERROR DELETE DATA: ${e.toString()}');
      return false;
    }
  }
}
