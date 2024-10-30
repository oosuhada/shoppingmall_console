import 'dart:io';
import 'shoppingmall_models.dart';
import 'authentication.dart';

// 필수기능: 쇼핑몰을 정의하기 위한 ShoppingMall 클래스
class ShoppingMall {
  List<Product> productList;
  Map<Product, int> cart = {};
  int maxQuantity = 10; //최대 구매 수량 10개로 제한

  // 생성자: 상품 목록을 받아 쇼핑몰 초기화
  ShoppingMall(this.productList);

  // 필수기능: 상품 목록을 출력하는 메서드
  // 자유 도전기능: 성별, 사이즈 요소 추가
  // 품목번호가 너무 길어져서 product code 추가
  void showProducts() {
    Map<String, List<Product>> categorizedProducts = {};

    for (var product in productList) {
      String category = '${product.gender} ${product.name}';
      if (!categorizedProducts.containsKey(category)) {
        categorizedProducts[category] = [];
      }
      categorizedProducts[category]!.add(product);
    }

    categorizedProducts.forEach((category, products) {
      print('\n[$category]');
      products.forEach((product) {
        print(
            '${product.productCode}. ${product.size} 사이즈 / ${product.price}원');
      });
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

  // advanced3에서 장바구니 정보 연동을 위해 상세 내역을 생성하는 getter 추가
  int get totalItems {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  List<String> get cartDetails {
    return cart.entries.map((entry) {
      Product product = entry.key;
      int quantity = entry.value;
      return '${product.name} ${quantity}개';
    }).toList();
  }

  int get totalPrice {
    return cart.entries.fold(0, (sum, entry) {
      Product product = entry.key;
      int quantity = entry.value;
      return sum + (product.price * quantity);
    });
  }

  // advanced3에서 장바구니 상태 출력 메서드 추가
  void printCartStatus() {
    print(
        '${currentUser.id}님 장바구니에 총 $totalItems개 상품이 담겨있습니다. 총 ${totalPrice}원 입니다!');
  }

  // Shoppingmall 내부 메서드: 목록 수정 - 상품을 추가하는 기능 구현
  // 자유 도전기능: 성별, 사이즈 요소 추가
  void _addProduct() {
    stdout.write('성별을 선택해주세요 (남성/여성): ');
    String? gender = stdin.readLineSync();
    if (gender != '남성' && gender != '여성') {
      print('올바른 성별을 입력해주세요.');
      return;
    }

    stdout.write('추가할 상품 이름을 입력해 주세요 : ');
    String? name = stdin.readLineSync();
    if (name == null || name.isEmpty) {
      print('상품 이름이 올바르지 않습니다.');
      return;
    }

    // 중복 상품 체크
    if (productList
        .any((product) => product.name == name && product.gender == gender)) {
      print('이미 목록에 존재하는 상품입니다.');
      return;
    }

    stdout.write('상품의 가격을 입력해 주세요: ');
    String? priceInput = stdin.readLineSync();
    int? price = int.tryParse(priceInput ?? '');

    if (price != null && price > 0) {
      print(
          '\'$gender $name\' 상품 \'$price\'원을 목록에 추가하시겠습니까? 추가하시려면 Yes, 취소하시려면 No를 입력해주세요.');
      String? confirm = stdin.readLineSync()?.toLowerCase();
      if (confirm == 'yes') {
        // 품목 추가시 자동으로 S, M, L, XL 사이즈 추가되도록 수정
        List<String> sizes = ['S', 'M', 'L'];

        // 마지막 상품 번호 찾기 (또는 0부터 시작) -> 더 이해가 필요한 부분
        int lastProductNumber = 0;
        for (var product in productList) {
          int? productNum = int.tryParse(product.productCode.substring(1, 2));
          if (productNum != null && productNum > lastProductNumber) {
            lastProductNumber = productNum;
          }
        } //advanced3 파일에서 null체크 방식 수정
        int newProductNumber = lastProductNumber + 1;

        // 각 사이즈에 대해 새로운 제품 라스트에 추가
        for (String size in sizes) {
          String productCode =
              '${gender == '여성' ? '0' : '1'}$newProductNumber${sizes.indexOf(size)}';
          productList.add(Product(productCode, gender!, name, price, size));
        }

        print('$gender $name 상품이 추가되었습니다.');
      } else {
        print('상품 추가가 취소되었습니다.');
      }
    } else {
      print('입력값이 올바르지 않아요!');
    }
  }

  // Shoppingmall 내부 메서드: 목록 수정 - 상품을 제거하는 기능 구현
  // advanced3 파일에서 상품이름 입력 시 모든 사이즈 삭제되도록 수정
  void _removeProduct() {
    stdout.write('제거할 상품명을 양말, 스웨터 등으로 입력해 주세요: ');
    String? name = stdin.readLineSync();
    if (name == null || name.isEmpty) {
      print('상품명이 올바르지 않습니다.');
      return;
    }

    // 해당 이름에 해당되는 모든 상품 검색
    List<Product> matchedProducts =
        productList.where((product) => product.name == name).toList();

    if (matchedProducts.isEmpty) {
      print('해당 상품이 목록에 존재하지 않습니다.');
      return;
    }

    // 제거할 상품들의 성별과 사이즈 정보 함께 출력
    print('제거 가능한 상품들입니다:');
    for (int i = 0; i < matchedProducts.length; i++) {
      print(
          '[$i] ${matchedProducts[i].gender} ${matchedProducts[i].name} ${matchedProducts[i].size} 사이즈 / ${matchedProducts[i].price}원');
    }

    stdout.write('제거할 상품의 번호를 \'모두\' 입력해주세요 (예: 0,1,2): ');
    String? indexInput = stdin.readLineSync();

    if (indexInput == null || indexInput.isEmpty) {
      print('잘못된 입력입니다.');
      return;
    }

    // 입력된 번호들을 파싱 - advanced3에서 다중선택 가능하도록 수정
    List<int> indices = indexInput
        .split(',')
        .map((e) => int.tryParse(e.trim()))
        .where((e) => e != null && e >= 0 && e < matchedProducts.length)
        .cast<int>()
        .toList();

    if (indices.isEmpty) {
      print('잘못된 번호를 입력하셨습니다.');
      return;
    }

    // 제거할 상품들 선택
    List<Product> productsToRemove =
        indices.map((index) => matchedProducts[index]).toList();

    print('다음 상품들을 제거하시겠습니까?');
    for (var product in productsToRemove) {
      print(
          '\'${product.gender} ${product.name} ${product.size} \' 상품 \'${product.price}\'원');
    }

    stdout.write('제거하시려면 Yes, 취소하시려면 No를 입력해주세요: ');
    String? confirm = stdin.readLineSync()?.toLowerCase();

    if (confirm == 'yes') {
      // 선택된 상품들 제거
      productsToRemove.forEach((product) => productList.remove(product));
      print('선택하신 상품들이 제거되었습니다.'); //getter 사용하여 간단하게 수정
    } else {
      print('상품 제거가 취소되었습니다.');
    }
  }

// 필수기능: 장바구니에 담는 메서드 + 자유 도전기능: 최대 구매 수량 제한
  void addToCart(String input, int quantity) {
    var product = findProduct(input);

    if (product == null || product.name.isEmpty) {
      print('입력값이 올바르지 않아요 !');
      return;
    }

    if (quantity <= 0 || quantity > maxQuantity) {
      print('1개에서 $maxQuantity개 사이의 수량만 담을 수 있어요 !');
      return;
    }

    int currentQuantity = cart[product] ?? 0;

    int newQuantity = currentQuantity + quantity;

    if (newQuantity > maxQuantity) {
      print('최대 구매 수량을 초과했습니다. 현재 장바구니에 ${currentQuantity}개가 있습니다.');
      return;
    }

    cart[product] = newQuantity;

    print(
        '장바구니에 \'${product.fullName} 상품이 \'$quantity개\' 담겼어요!'); //getter 사용하여 간단하게 수정
    printCartStatus();
  }

// findProduct 오류 해결하기 위한 메서드 추가
  Product? findProduct(String input) {
    // 숫자 입력인 경우 (인덱스)
    int? index = int.tryParse(input);
    if (index != null && index > 0 && index <= productList.length) {
      return productList[index - 1];
    }

    // 문자열 입력인 경우 (상품 이름) findProduct 메서드도 productCode를 고려하도록 수정
    return productList.firstWhere(
      (product) => product.productCode == input || product.name == input,
      orElse: () => Product('', '', '', 0, ''),
    );
  }

  // 자유 도전기능: 장바구니에서 상품을 제거하는 기능
  void removeFromCart(String input, int quantity) {
    var product = findProduct(input);

    if (product == null || product.name.isEmpty || !cart.containsKey(product)) {
      print('장바구니에 해당 상품이 없습니다.');
      return;
    }

    int currentQuantity = cart[product]!;

    if (quantity >= currentQuantity) {
      cart.remove(product);
      print('${product.name}이(가) 장바구니에서 모두 제거되었습니다.');
    } else {
      cart[product] = currentQuantity - quantity;
      print(
          '${product.fullName} ${quantity}개가 장바구니에서 제거되었습니다.'); //getter 사용하여 간단하게 수정
      printCartStatus();
    }
  }

  // 자유 도전기능: 장바구니 상품 수량을 직접 수정하는 메서드 추가
  void modifyCartQuantity(String input, int newQuantity) {
    var product = findProduct(input);
    if (product == null || product.name.isEmpty) {
      print('입력값이 올바르지 않아요 !');
      return;
    }
    if (newQuantity <= 0 || newQuantity > maxQuantity) {
      print('1개에서 $maxQuantity개 사이의 수량만 담을 수 있어요 !');
      return;
    }
    // 현재 수량과 새로운 수량 비교 위해 현재 수량 저장
    int? currentQuantity = cart[product];

    if (newQuantity == 0) {
      cart.remove(product);
      print('${product.name}이(가) 장바구니에서 제거되었습니다.');
    } else {
      // 현재 수량과 새로운 수량 비교하도록 수정
      cart[product] = newQuantity;
      print(
          '${product.productCode}. ${product.fullName} 상품의 수량이 $currentQuantity개에서 $newQuantity개로 변경되었습니다.');
      printCartStatus();
    }
  }

  // 추가 도전기능: 장바구니에 담은 상품들의 목록과 가격을 볼 수 있는 기능
  // 자유 도전기능: 장바구니 총합 출력 메서드, 유저 이름 및 상품별 가격 합계 기능 추가
  // advanced3에서 장바구니 상세보기로 showTotal 내용 수정
  void showTotal() {
    if (cart.isEmpty) {
      print('장바구니에 담긴 상품이 없습니다.');
      return;
    }

    Map<String, List<CartItem>> categorizedItems = {};
    int totalItems = 0;
    int totalPrice = 0;

    cart.forEach((product, quantity) {
      String category = product.name;
      String key = product.fullName; //getter 사용하여 간단하게 수정

      if (!categorizedItems.containsKey(category)) {
        categorizedItems[category] = [];
      }

      categorizedItems[category]!
          .add(CartItem(key, quantity, product.price, product.productCode));
      totalItems += quantity;
      totalPrice += quantity * product.price;
    });

    print('${currentUser.id}님, 현재 장바구니에');

    categorizedItems.forEach((category, items) {
      print('\n$category 카테고리에서');
      for (var item in items) {
        int itemTotal = item.quantity * item.price;
        print(
            '${item.productCode}. ${item.key} ${item.quantity}개 ${itemTotal}원');
      }
    });

    print('\n총 $totalItems개 상품이 장바구니에 담겨있습니다.');
    print('총 금액은 $totalPrice원 입니다.');
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

// 장바구니 아이템을 위한 추가 클래스
class CartItem {
  String key;
  int quantity;
  int price;
  String productCode; // 추가
  CartItem(this.key, this.quantity, this.price, this.productCode);
}
