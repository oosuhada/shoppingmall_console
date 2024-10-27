import 'dart:io';

// 필수기능: 상품을 정의하기 위한 Product 클래스
class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

// 필수기능: 쇼핑몰을 정의하기 위한 ShoppingMall 클래스
class ShoppingMall {
  List<Product> productList;
  Map<Product, int> cart = {};
  int maxQuantity = 10; //최대 구매 수량 10개로 제한

  // 생성자: 상품 목록을 받아 쇼핑몰 초기화
  ShoppingMall(this.productList);

  // 필수기능: 상품 목록을 출력하는 메서드
  void showProducts() {
    productList.asMap().forEach((index, product) {
      print('${index + 1}. ${product.name} / ${product.price}원');
    });
  }

  // 자유 도전기능: 상품 목록을 수정하는 기능
  void modifyProductList() {
    print('추가할 상품이 있다면 add, 제거할 상품이 있다면 remove를 입력해주세요.');
    String? action = stdin.readLineSync()?.toLowerCase();
    //사용자 입력 동일하게 처리, null안정성 추가

    if (action == 'add') {
      _addProduct();
    } else if (action == 'remove') {
      _removeProduct();
    } else {
      print('올바르지 않은 입력입니다.');
    }
  }

  // Shoppingmall 내부 메서드: 목록 수정 - 상품을 추가하는 기능 구현
  void _addProduct() {
    stdout.write('추가할 상품 이름을 입력해 주세요: ');
    String? name = stdin.readLineSync();
    if (name == null || name.isEmpty) {
      print('상품 이름이 올바르지 않습니다.');
      return;
    }

    // 중복 상품 체크
    if (productList.any((product) => product.name == name)) {
      print('이미 목록에 존재하는 상품입니다.');
      return;
    }

    stdout.write('상품의 가격을 입력해 주세요: ');
    String? priceInput = stdin.readLineSync();
    int? price = int.tryParse(priceInput ?? '');

    if (price != null && price > 0) {
      print(
          '\'$name\' 상품 \'$price\'원을 목록에 추가하시겠습니까? 추가하시려면 Yes, 취소하시려면 No를 입력해주세요.'); // 목록 수정 한번 더 컨펌
      String? confirm = stdin.readLineSync()?.toLowerCase();
      if (confirm == 'yes') {
        productList.add(Product(name, price));
        print('$name 상품이 추가되었습니다.');
      } else {
        print('상품 추가가 취소되었습니다.');
      }
    } else {
      print('입력값이 올바르지 않아요!');
    }
  }

  // Shoppingmall 내부 메서드: 목록 수정 - 상품을 제거하는 기능 구현
  void _removeProduct() {
    stdout.write('제거할 상품 이름을 입력해 주세요: ');
    String? name = stdin.readLineSync();
    if (name == null || name.isEmpty) {
      print('상품 이름이 올바르지 않습니다.');
      return;
    }

    Product? productToRemove = productList.firstWhere(
      (product) => product.name == name,
      orElse: () => Product('', 0),
    );

    if (productToRemove.name.isEmpty) {
      print('해당 상품이 목록에 존재하지 않습니다.');
      return;
    }

    print(
        '\'${productToRemove.name}\' 상품 \'${productToRemove.price}\'원을 목록에서 제거하시겠습니까? 제거하시려면 Yes, 취소하시려면 No를 입력해주세요.'); // 목록 수정 한번 더 컨펌
    String? confirm = stdin.readLineSync()?.toLowerCase();
    if (confirm == 'yes') {
      productList.remove(productToRemove);
      print('${productToRemove.name} 상품이 제거되었습니다.');
    } else {
      print('상품 제거가 취소되었습니다.');
    }
  }

  // 자유 도전기능: 상품을 이름 또는 번호로 찾는 기능 추가
  Product? findProduct(String input) {
    int? index = int.tryParse(input);
    if (index != null && index > 0 && index <= productList.length) {
      return productList[index - 1];
    } else {
      return productList.firstWhere(
        (product) => product.name == input,
        orElse: () => Product('', 0),
      );
    }
  }

  // 필수기능: 상품을 장바구니에 담는 메서드 + 자유 도전기능: 최대 구매 수량 제한
  void addToCart(String input, int quantity) {
    var product = findProduct(input);
    if (product == null || product.name.isEmpty) {
      print('입력값이 올바르지 않아요 !');
    } else if (quantity <= 0 || quantity > maxQuantity) {
      print('1개에서 $maxQuantity개 사이의 수량만 담을 수 있어요 !');
    } else {
      int currentQuantity = cart[product] ?? 0;
      int newQuantity = currentQuantity + quantity;
      if (newQuantity > maxQuantity) {
        print('최대 구매 수량을 초과했습니다. 현재 장바구니에 ${currentQuantity}개가 있습니다.');
      } else {
        cart[product] = newQuantity;
        print(
            '장바구니에 \'${product.name}\' 상품이 \'$quantity개\' 담겼어요!'); // 자유 도전기능: 장바구니에 담은 상품 이름과 수량 출력
      }
    }
  }

  // 자유 도전기능: 장바구니에서 상품을 제거하는 기능
  void removeFromCart(String input, int quantity) {
    var product = findProduct(input);
    if (product == null || product.name.isEmpty || !cart.containsKey(product)) {
      // 잘못된 입력 방지
      print('장바구니에 해당 상품이 없습니다.');
    } else {
      int currentQuantity = cart[product]!;
      if (quantity >= currentQuantity) {
        cart.remove(product);
        print('${product.name}이(가) 장바구니에서 모두 제거되었습니다.');
      } else {
        cart[product] = currentQuantity - quantity;
        print('${product.name} ${quantity}개가 장바구니에서 제거되었습니다.');
      }
    }
  }

  // 자유 도전기능: 장바구니 상품 수량을 직접 수정하는 기능
  void modifyCartQuantity(String input, int newQuantity) {
    var product = findProduct(input);
    if (product == null || product.name.isEmpty || !cart.containsKey(product)) {
      // 잘못된 입력 방지
      print('장바구니에 해당 상품이 없습니다.');
    } else if (newQuantity <= 0 || newQuantity > maxQuantity) {
      print('1개에서 $maxQuantity개 사이의 수량만 가능합니다.');
    } else {
      cart[product] = newQuantity;
      print('${product.name}의 수량이 ${newQuantity}개로 수정되었습니다.');
    }
  }

  // 추가 도전기능: 장바구니에 담은 상품들의 목록과 가격을 볼 수 있는 기능
  void showTotal() {
    if (cart.isEmpty) {
      print('장바구니에 담긴 상품이 없습니다.');
      return;
    }

    List<String> cartItems = [];
    int totalPrice = 0;

    cart.forEach((product, quantity) {
      cartItems.add('${product.name} ${quantity}개');
      totalPrice += product.price * quantity;
    });

    print('장바구니에 ${cartItems.join(", ")}가 담겨있네요. 총 ${totalPrice}원 입니다!');
  }

  // 추가 도전기능: 장바구니를 초기화할 수 있는 기능
  void clearCart() {
    if (cart.isEmpty) {
      print('이미 장바구니가 비어있습니다.');
    } else {
      cart.clear();
      print('장바구니를 초기화합니다.');
    }
  }
}

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

// 메인 함수: 프로그램 진입
void main() {
  // 자유 도전기능: 로그인 기능 실행
  if (!login()) {
    print('프로그램을 종료합니다.');
    return;
  }

  // 필수기능: 초기 상품 목록 생성
  List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];

  // ShoppingMall 인스턴스 생성
  ShoppingMall mall = ShoppingMall(products);

  // 메인 메뉴: 사용자 입력에 따라 기능 실행
  // 자유 도전기능: 메인 메뉴 기능 추가
  while (true) {
    print('\n' + '-' * 80);
    print('[1] 상품 목록 보기 / [2] 상품 목록 수정하기 / [3] 목록에서 장바구니에 담기');
    print('[4] 장바구니에서 상품 빼기 / [5] 장바구니 상품 수량 직접 수정하기');
    print('[6] 장바구니에 담긴 상품의 총 가격 보기 / [7] 장바구니 초기화 / [8] 프로그램 종료');
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
        stdout.write('상품 이름을 입력하거나 품목숫자를 입력해 주세요: ');
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
        stdout.write('장바구니에서 뺄 상품 이름을 입력하거나 품목숫자를 입력해 주세요: ');
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
        stdout.write('수정할 상품 이름을 입력하거나 품목숫자를 입력해 주세요: ');
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
          print(
              '${currentUser.id}님 이용해 주셔서 감사합니다 ~ 안녕히 가세요 !'); // 자유 도전기능: 유저 이름 추가
          return;
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
