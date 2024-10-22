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

  // 생성자: 상품 목록을 받아 쇼핑몰 초기화
  ShoppingMall(this.productList);

  // 필수기능: 상품 목록을 출력하는 메서드
  void showProducts() {
    for (var product in productList) {
      print('${product.name} / ${product.price}원');
    }
  }

  // 필수기능: 상품을 장바구니에 담는 메서드
  void addToCart(String productName, int quantity) {
    var product = productList.firstWhere(
      (product) => product.name == productName,
      orElse: () => Product('', 0),
    );
    if (product.name.isEmpty) {
      print('입력값이 올바르지 않아요 !');
    } else if (quantity <= 0) {
      print('0개보다 많은 개수의 상품만 담을 수 있어요 !');
    } else {
      cart.update(product, (value) => value + quantity,
          ifAbsent: () => quantity);
      print('장바구니에 상품이 담겼어요 !');
    }
  }

  // 필수기능 : 장바구니에 담은 상품들의 총 가격을 볼 수 있는 기능
  void showTotal() {
    int totalPrice = cart.entries
        .fold(0, (sum, entry) => sum + entry.key.price * entry.value);
    print('장바구니에 ${totalPrice}원 어치를 담으셨네요 !');
  }
}

// 메인 함수: 프로그램 진입, 초기 상품 목록 생성
void main() {
  List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];

  // ShoppingMall 인스턴스 생성
  ShoppingMall mall = ShoppingMall(products);

  // 필수기능: 메뉴 출력
  while (true) {
    print('\n' + '-' * 80);
    print(
        '[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
    print('-' * 80);

    // 사용자로부터 메뉴 선택 입력 받기
    stdout.write('선택: ');
    String? input = stdin.readLineSync();

    if (input == null) {
      print('입력이 없습니다. 다시 시도해 주세요.');
      continue;
    }

    // 선택된 메뉴에 따라 기능 실행
    switch (input.trim()) {
      case '1': // 필수기능: 상품 목록 보기
        mall.showProducts();
      case '2': // 필수기능: 장바구니에 상품 담기
        stdout.write('상품 이름을 입력해 주세요: ');
        String? productName = stdin.readLineSync();
        stdout.write('상품 개수를 입력해 주세요: ');
        String? quantityInput = stdin.readLineSync();
        int? quantity = int.tryParse(quantityInput ?? '');
        if (productName != null && productName.isNotEmpty && quantity != null) {
          mall.addToCart(productName, quantity);
        } else {
          print('입력값이 올바르지 않아요 !');
        }
      case '3': // 필수기능 : 장바구니에 담은 상품들의 총 가격을 볼 수 있는 기능
        mall.showTotal();
      case '4': // 필수기능 : 쇼핑몰 프로그램을 종료할 수 있는 기능
        print('이용해 주셔서 감사합니다 ~ 안녕히 가세요 !');
        return;
      default: //필수기능 : 1, 2, 3, 4 외의 값을 입력했을 때 검증
        print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
    }
  }
}
