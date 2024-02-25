import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/base_controller.dart';
import 'package:PrimeTasche/main.dart';

class InfoController extends BaseController {
  int adreste = 0;
  int kuryede = 0;
  Future<bool> getInfo() async {
    adreste = 0;
    kuryede = 0;

    var asd = container.read(bagListProvider).cantaVer();
    asd.forEach(
      (key, value) {
        if (value["lastUser"] == auth.currentUser!.email) {
          if (value["inAdress"]) {
            adreste++;
          }
          if (value["inCourier"]) {
            kuryede++;
          }
        }
      },
    );
    return Future(() => true);
  }

  Future<bool> getInfoByMail(String mail) {
    state = DataState.loading;
    adreste = 0;
    kuryede = 0;

    var asd = container.read(bagListProvider).cantaVer();
    asd.forEach(
      (key, value) {
        if (value["lastUser"] == mail) {
          if (value["inAdress"]) {
            adreste++;
          }
          if (value["inCourier"]) {
            kuryede++;
          }
        }
      },
    );
    state = DataState.loading;
    return Future(() => true);
  }
}

final infoProvider = ChangeNotifierProvider<InfoController>((_) => InfoController());
