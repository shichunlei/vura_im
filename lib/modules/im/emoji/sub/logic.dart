import 'package:vura/base/base_list_logic.dart';
import 'package:vura/entities/emoji.dart';

class EmojiLogic extends BaseListLogic<EmojiEntity> {
  final String type;

  EmojiLogic(this.type);

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  Future<List<EmojiEntity>> loadData() async {
    return EmojiEntity.getEmoji(type);
  }
}
