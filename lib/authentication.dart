import 'dart:io';
import '/Users/gabriel/workspace/shoppingmall/shoppingmall/lib/shoppingmall_models.dart';

// 자유 도전기능: 로그인 기능 추가2
class User {
  String id;
  String password;

  User(this.id, this.password);
}

User currentUser = User('user', 'password');

// 자유 도전기능: 로그인 기능 추가1
bool login() {
  String correctId = 'user';
  String correctPassword = 'password';

  print('로그인이 필요합니다.');
  print('초기 아이디: $correctId');
  print('초기 비밀번호: $correctPassword');

  while (true) {
    // 사용자로부터 아이디 입력 받기
    stdout.write('아이디를 입력하세요: ');
    String? id = stdin.readLineSync();
    // 사용자로부터 비밀번호 입력 받기
    stdout.write('비밀번호를 입력하세요: ');
    String? password = stdin.readLineSync();

    // 입력된 아이디와 비밀번호 확인
    if (id == correctId && password == correctPassword) {
      print('안녕하세요, user님! shoppingmall에 오신 것을 환영합니다!!');
      return true;
    } else {
      print('로그인 실패. 다시 시도해주세요.');
    }
  }
}

// 자유 도전기능: 로그인 기능 추가2. 아이디와 비밀번호 변경기능
void changeCredentials() {
  stdout.write('새로운 아이디를 입력하세요: ');
  String? newId = stdin.readLineSync();
  stdout.write('새로운 비밀번호를 입력하세요: ');
  String? newPassword = stdin.readLineSync();

  if (newId != null &&
      newId.isNotEmpty &&
      newPassword != null &&
      newPassword.isNotEmpty) {
    currentUser.id = newId;
    currentUser.password = newPassword;
    print('아이디와 비밀번호가 성공적으로 변경되었습니다.');
  } else {
    print('올바르지 않은 입력입니다. 변경이 취소되었습니다.');
  }
}
