import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => _keys;

  static final Map<String, Map<String, String>> _keys = _TranslationHelper.loadTranslations();
}

class _TranslationHelper {
  static final Map<String, dynamic> _translations = {
    "app_name": {
      "en_US": "The Search for Planet X",
      "zh_CN": "X 行星之谜",
    },
    "nickname": {
      "en_US": "Nickname",
      "zh_CN": "昵称",
    },
    "nickname_hint": {
      "zh_CN": "修改后点击刷新生效",
      "en_US": "Refresh to apply",
    },
    "service_address": {
      "en_US": "Server Address",
      "zh_CN": "服务器地址",
    },
    "language": {
      "en_US": "Language",
      "zh_CN": "语言",
    },
    "home_create_room": {
      "en_US": "Create Room",
      "zh_CN": "创建房间",
    },
    "home_join_room": {
      "en_US": "Join Room",
      "zh_CN": "加入房间",
    },
    // component
    "title_clue_log": {
      "en_US": "Research",
      "zh_CN": "研究记录",
    },
    "title_operation_log": {
      "en_US": "Operation",
      "zh_CN": "操作记录",
    },
    "title_conference_log": {
      "en_US": "Conference",
      "zh_CN": "会议记录",
    },
    "cell_user_self": {
      "en_US": "You",
      "zh_CN": "我",
    },
    "cell_user_op_result": {
      "en_US": "Result",
      "zh_CN": "结果",
    },
    "cell_conference_title": {
      "en_US": "Conference",
      "zh_CN": "会议",
    },
    "room_info_room": {
      "en_US": "Room: @room",
      "zh_CN": "房间: @room",
    },
    "room_info_seed": {
      "en_US": "Seed: @seed",
      "zh_CN": "种子: @seed",
    },
    "room_info_mode": {
      "en_US": "Mode: @mode",
      "zh_CN": "难度: @mode",
    },
    "room_button_leave": {
      "en_US": "Leave",
      "zh_CN": "离开",
    },
    "room_button_prepare": {
      "en_US": "Prepare",
      "zh_CN": "准备",
    },
    "room_button_unprepare": {
      "en_US": "Unprepare",
      "zh_CN": "取消",
    },
    "op_name_survey": {
      "en_US": "Survey",
      "zh_CN": "勘测",
    },
    "op_name_target": {
      "en_US": "Target",
      "zh_CN": "扫描",
    },
    "op_name_research": {
      "en_US": "Research",
      "zh_CN": "研究",
    },
    "op_name_locate_x": {
      "en_US": "Locate X",
      "zh_CN": "定位X",
    },
    "op_name_ready_publish": {
      "en_US": "Prepare Theory",
      "zh_CN": "准备理论",
    },
    "op_name_do_publish": {
      "en_US": "Publish Theory",
      "zh_CN": "发表理论",
    },
    "op_button_confirm": {
      "en_US": "Confirm",
      "zh_CN": "确认",
    },
    "starmap_button_confirm": {
      "en_US": "Confirm",
      "zh_CN": "确认",
    },
    "starmap_button_doubt": {
      "en_US": "Doubt",
      "zh_CN": "怀疑",
    },
    "starmap_button_deny": {
      "en_US": "Deny",
      "zh_CN": "否定",
    },
    "starmap_season_spring": {
      "en_US": "Spring",
      "zh_CN": "春分",
    },
    "starmap_season_summer": {
      "en_US": "Summer",
      "zh_CN": "夏至",
    },
    "starmap_season_autumn": {
      "en_US": "Autumn",
      "zh_CN": "秋分",
    },
    "starmap_season_winter": {
      "en_US": "Winter",
      "zh_CN": "冬至",
    },
    // model
    "sector_type_comet": {
      "en_US": "Comet",
      "zh_CN": "彗星",
    },
    "sector_type_asteroid": {
      "en_US": "Asteroid",
      "zh_CN": "小行星",
    },
    "sector_type_dwarf": {
      "en_US": "Dwarf Planet",
      "zh_CN": "矮行星",
    },
    "sector_type_nubula": {
      "en_US": "Nebula",
      "zh_CN": "气体云",
    },
    "sector_type_space": {
      "en_US": "Space",
      "zh_CN": "空域",
    },
    "sector_type_x": {
      "en_US": "Planet X",
      "zh_CN": "X 行星",
    },
    "operation_survey": {
      "en_US": "Survey @start - @end @type",
      "zh_CN": "勘测 @start - @end @type",
    },
    "operation_target": {
      "en_US": "Target @index",
      "zh_CN": "扫描 @index",
    },
    "operation_research": {
      "en_US": "Research @index",
      "zh_CN": "研究 @index",
    },
    "operation_locate_x": {
      "en_US": "Locate X",
      "zh_CN": "定位X",
    },
    "operation_ready_publish": {
      "en_US": "Prepare Theory @types",
      "zh_CN": "准备理论",
    },
    "operation_do_publish": {
      "en_US": "Publish Theory @types",
      "zh_CN": "发表理论",
    },
    "operation_result_ready_publish": {
      "en_US": "Theory Number @cnt:",
      "zh_CN": "理论 @cnt 篇:",
    },
    "operation_result_do_publish": {
      "en_US": "(@index, @type)",
      "zh_CN": "(@index, @type)",
    },
    // picker
    "picker_title_sector":{
      "en_US": "Select Object",
      "zh_CN": "选择天体",
    },
    "picker_title_token":{
      "en_US": "Select Token",
      "zh_CN": "选择Token",
    },
    "picker_item_none_token":{
      "en_US": "None",
      "zh_CN": "不使用",
    },
    "picker_title_clue":{
      "en_US": "Select Item",
      "zh_CN": "选择研究",
    },
  };
  static Map<String, Map<String, String>> loadTranslations() {
    return convertTranslation(_translations);
  }

  static Map<String, Map<String, String>> convertTranslation(Map<String, dynamic> translations) {
    final Map<String, Map<String, String>> keys = {};

    translations.forEach((key, value) {
      value.forEach((lang, translation) {
        keys.putIfAbsent(lang, () => {})[key] = translation;
      });
    });
    print(keys);
    return keys;
  }
}
