import 'dart:convert';

import 'package:albanote_project/data/entity/login/member_login_response_dto.dart';
import 'package:albanote_project/data/repository/repository_config.dart';
import 'package:albanote_project/di/model/member/os_type.dart';
import 'package:albanote_project/domain/repository/login/login_repository.dart';
import 'package:dio/dio.dart';

import '../../../di/model/member/social_login_type.dart';
import '../../entity/common/response_entity.dart';

class LoginRepositoryImpl extends LoginRepository {
  LoginRepositoryImpl(this.dio);

  final Dio dio;

  /// 로그인 및 회원가입
  @override
  Future<ResponseEntity<MemberLoginResponseDTO>> postLogin(String idToken, String accessToken) async {
    const uri = '/login';
    try {
      var response = await dio.post(RepositoryConfig.serverUrl + uri,
          options: Options(headers: {'Authorization': RepositoryConfig.basicToken}),
          data: {
            'socialId': idToken,
            'socialLoginType': SocialLoginType.KAKAO.name,
            'osType': OsType.ANDROID.name,
          });
      if (response.statusCode == 200) {
        var dto = MemberLoginResponseDTO.fromJson(jsonDecode(response.data));
        return ResponseEntity.success(dto);
      } else {
        return onErrorHandler(response);
      }
    } on DioError catch (e) {
      return onDioErrorHandler(e);
    }
  }
}
