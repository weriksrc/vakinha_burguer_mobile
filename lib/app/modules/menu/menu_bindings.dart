import 'package:get/get.dart';
import 'package:vakinha_burger_mobile/app/repositories/products/produtc_repository.dart';
import 'package:vakinha_burger_mobile/app/repositories/products/produtc_repository_impl.dart';
import './menu_controller.dart';

class MenuBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProdutcRepository>(
        () => ProdutcRepositoryImp(restClient: Get.find()));
    Get.put(MenuController(produtcRepository: Get.find()));
  }
}
