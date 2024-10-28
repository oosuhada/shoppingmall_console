import 'dart:io';
import '/Users/gabriel/workspace/shoppingmall/shoppingmall/lib/shoppingmall_models.dart';
import '/Users/gabriel/workspace/shoppingmall/shoppingmall/lib/shoppingmall_class.dart';
import '/Users/gabriel/workspace/shoppingmall/shoppingmall/lib/authentication.dart';

// 메인 함수: 프로그램 진입
void main() {
  // 자유 도전기능: 로그인 기능 실행
  if (!login()) {
    print('프로그램을 종료합니다.');
    return;
  }

  // 필수기능: 초기 상품 목록 생성 -> 자유 도전기능: 제품 생성 함수 성별, 사이즈 추가하여 수정
  List<Product> products = [];
  List<String> genders = ['여성', '남성'];
  List<String> names = ['셔츠', '원피스', '반팔티', '반바지', '양말'];
  List<int> prices = [45000, 50000, 15000, 38000, 5000];
  List<String> sizes = ['S', 'M', 'L'];

  for (int genderIndex = 0; genderIndex < genders.length; genderIndex++) {
    for (int nameIndex = 0; nameIndex < names.length; nameIndex++) {
      // 남성 원피스 제외
      if (genders[genderIndex] == '남성' && names[nameIndex] == '원피스') continue;

      for (int sizeIndex = 0; sizeIndex < sizes.length; sizeIndex++) {
        // 고유한 제품 코드 생성 (성별 0/1, 상품 0~4, 사이즈 0~2)
        String productCode = '${genderIndex}${nameIndex}${sizeIndex}';

        products.add(Product(
          productCode,
          genders[genderIndex],
          names[nameIndex],
          prices[nameIndex],
          sizes[sizeIndex],
        ));
      }
    }
  }

  // ShoppingMall 인스턴스 생성
  // products 변수를 generateProducts() 함수의 반환값으로 초기화하기 위해 수정
  ShoppingMall mall = ShoppingMall(products);

  // 메인 메뉴: 사용자 입력에 따라 기능 실행
  // 자유 도전기능: 메인 메뉴 기능 추가
  while (true) {
    print('\n' + '-' * 80);
    print('[1] 상품 목록 보기 / [2] 상품 목록 수정하기 / [3] 목록에서 장바구니에 담기');
    print('[4] 장바구니에서 상품 빼기 / [5] 장바구니 상품 수량 직접 수정하기');
    print('[6] 장바구니 상세보기 / [7] 장바구니 초기화 / [8] 프로그램 종료');
    print('[9] 아이디, 비밀번호 변경');
    print('-' * 80);

    // 사용자로부터 메뉴 선택 입력 받기
    stdout.write('선택: ');
    String? input = stdin.readLineSync();

    // 선택된 메뉴에 따라 기능 실행
    switch (input) {
      case '1':
        // 필수기능: 상품 목록 보기
        mall.showProducts();
      case '2':
        // 자유 도전기능: 상품 목록 수정하기
        mall.modifyProductList();
      case '3':
        // 필수기능: 장바구니에 상품 담기
        stdout.write('상품의 품목번호를 입력해 주세요: ');
        String? productInput = stdin.readLineSync();
        stdout.write('상품 개수를 입력해 주세요: ');
        String? quantityInput = stdin.readLineSync();
        int? quantity = int.tryParse(quantityInput ?? '');
        if (productInput != null &&
            productInput.isNotEmpty &&
            quantity != null) {
          mall.addToCart(productInput, quantity);
        } else {
          print('입력값이 올바르지 않아요 !');
        }
      case '4':
        // 자유 도전기능: 장바구니에서 상품 빼기
        stdout.write('장바구니에서 뺄 상품의 품목번호를 입력해 주세요: ');
        String? productInput = stdin.readLineSync();
        stdout.write('뺄 상품 개수를 입력해 주세요: ');
        String? quantityInput = stdin.readLineSync();
        int? quantity = int.tryParse(quantityInput ?? '');
        if (productInput != null &&
            productInput.isNotEmpty &&
            quantity != null) {
          mall.removeFromCart(productInput, quantity);
        } else {
          print('입력값이 올바르지 않아요 !');
        }
      case '5':
        // 자유 도전기능: 장바구니 상품 수량 직접 수정하기
        stdout.write('수정할 상품의 품목번호를 입력해 주세요: ');
        String? productInput = stdin.readLineSync();
        stdout.write('새로운 수량을 입력해 주세요: ');
        String? quantityInput = stdin.readLineSync();
        int? quantity = int.tryParse(quantityInput ?? '');
        if (productInput != null &&
            productInput.isNotEmpty &&
            quantity != null) {
          mall.modifyCartQuantity(productInput, quantity);
        } else {
          print('입력값이 올바르지 않아요 !');
        }
      case '6':
        // 추가 도전기능: 장바구니에 담긴 상품의 총 가격 보기
        // 총 가격 case 3,4,5에 표시하고 장바구니 상세보기로 수정
        mall.showTotal();
        break;
      case '7':
        // 추가 도전기능: 장바구니 초기화
        mall.clearCart();
      case '8':
        // 추가 도전기능: 쇼핑몰 프로그램을 종료할 시 한번 더 종료할 것인지 물어보는 기능
        stdout.write('정말 종료하시겠습니까? (9를 입력하면 종료): ');
        String? confirmInput = stdin.readLineSync();
        if (confirmInput == '9') {
          print('${currentUser.id}님 이용해 주셔서 감사합니다 ~ 안녕히 가세요 !');
          // 자유 도전기능: 유저 이름 추가
          return; // 프로그램 종료되지 않고 다시 메인메뉴 실행되는 부분때문에 추가
        } else {
          print('종료하지 않습니다.');
        }
      case '9': // 자유 도전기능: 로그인 기능 추가2. 아이디와 비밀번호 변경기능
        changeCredentials();
      default:
        // 잘못된 입력 검증
        print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
    }
  }
}
