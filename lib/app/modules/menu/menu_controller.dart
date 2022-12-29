import 'dart:developer';

import 'package:get/get.dart';
import 'package:vakinha_burger_mobile/app/core/mixins/loader_mixin.dart';
import 'package:vakinha_burger_mobile/app/core/mixins/messages_mixin.dart';
import 'package:vakinha_burger_mobile/app/models/product_model.dart';
import 'package:vakinha_burger_mobile/app/repositories/products/produtc_repository.dart';

class MenuController extends GetxController with LoaderMixin, MessagesMixin {
  final ProdutcRepository _produtcRepository;

  final _loading = false.obs;
  final _message = Rxn<MessageModel>();
  final menu = <ProductModel>[].obs;

  MenuController({
    required ProdutcRepository produtcRepository,
  }) : _produtcRepository = produtcRepository;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    try {
      _loading.toggle();
      await findAllProducts();
      _loading.toggle();
    } catch (e, s) {
      _loading.toggle();
      log(
        'Erro ao buscar produtos',
        error: e,
        stackTrace: s,
      );
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao buscar menu',
          type: MessageType.error,
        ),
      );
    }
  }

  Future<void> findAllProducts() async {
    final products = await _produtcRepository.findAll();
    menu.assignAll(products);
  }

  Future<void> refreshPage() async {
    try {
      await findAllProducts();
    } catch (e, s) {
      log(
        'Erro ao buscar produtos',
        error: e,
        stackTrace: s,
      );
      _message(
        MessageModel(
          title: 'Erro',
          message: 'Erro ao buscar menu',
          type: MessageType.error,
        ),
      );
    }
  }
}
