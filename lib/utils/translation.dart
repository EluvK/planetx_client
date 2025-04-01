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
    "service_address": {
      "en_US": "Server Address",
      "zh_CN": "服务器地址",
    },
    "server_version": {
      "en_US": "Server Version @version",
      "zh_CN": "服务器版本 @version",
    },
    "client_version": {
      "en_US": "Client Version @version",
      "zh_CN": "客户端版本 @version",
    },
    "language": {
      "en_US": "Language",
      "zh_CN": "语言(Language)",
    },
    "room_number_hint": {
      "en_US": "Room Number",
      "zh_CN": "房间号",
    },
    "home_create_room": {
      "en_US": "Create Room",
      "zh_CN": "创建房间",
    },
    "home_join_room": {
      "en_US": "Join Room",
      "zh_CN": "加入房间",
    },
    "server_resp_title_unknown": {
      "en_US": "Unknown",
      "zh_CN": "未知",
    },
    "server_resp_title_version": {
      "en_US": "Server Version",
      "zh_CN": "服务器版本",
    },
    "server_resp_title_rejoin_room": {
      "en_US": "Rejoin Room",
      "zh_CN": "重新加入房间",
    },
    "server_resp_title_room_errors": {
      "en_US": "Room Errors",
      "zh_CN": "房间错误",
    },
    "server_resp_title_op_errors": {
      "en_US": "Operation Errors",
      "zh_CN": "操作错误",
    },
    "room_error_room_not_found": {
      "en_US": "Room Not Found",
      "zh_CN": "房间不存在",
    },
    "room_error_room_started": {
      "en_US": "Room Already Started Game",
      "zh_CN": "房间已开始游戏",
    },
    "room_error_room_full": {
      "en_US": "Room Full",
      "zh_CN": "房间已满",
    },
    "room_error_user_not_found_in_room": {
      "en_US": "User Not Found In Room",
      "zh_CN": "用户不在房间内",
    },
    "op_error_user_not_found_in_room": {
      "en_US": "User Not Found In Room",
      "zh_CN": "用户不在房间内",
    },
    "op_error_game_not_found": {
      "en_US": "Game Not Found",
      "zh_CN": "游戏不存在",
    },
    "op_error_not_users_turn": {
      "en_US": "Not Your Turn",
      "zh_CN": "不是你的回合",
    },
    "op_error_invalid_move_in_stage": {
      "en_US": "Invalid Move In Current Stage",
      "zh_CN": "当前阶段无法进行此操作",
    },
    "op_error_invalid_index": {
      "en_US": "Invalid Index",
      "zh_CN": "无效的星区序号",
    },
    "op_error_invalid_clue": {
      "en_US": "Invalid Clue",
      "zh_CN": "无效研究",
    },
    "op_error_invalid_sector_type": {
      "en_US": "Invalid Sector Type",
      "zh_CN": "无效天体类型",
    },
    "op_error_invalid_index_of_prime": {
      "en_US": "Invalid index for Comet should be prime",
      "zh_CN": "彗星的序号应该是质数",
    },
    "op_error_token_not_enough": {
      "en_US": "Token Not Enough",
      "zh_CN": "Token 不足",
    },
    "op_error_sector_already_revealed": {
      "en_US": "Sector Already Revealed",
      "zh_CN": "该区天体已被揭示",
    },
    "op_error_target_time_exhausted": {
      "en_US": "`Target` Exhausted",
      "zh_CN": "扫描次数已用完",
    },
    "op_error_research_continuously": {
      "en_US": "Research Continuously",
      "zh_CN": "无法进行连续研究",
    },
    "op_error_end_game_can_not_locate": {
      "en_US": "End Game Can Not Locate",
      "zh_CN": "无法进行定位操作",
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
    "room_button_leave_confirm": {
      "en_US": "Are you sure to leave?",
      "zh_CN": "确定要离开吗？",
    },
    "cancel": {
      "en_US": "Cancel",
      "zh_CN": "取消",
    },
    "confirm": {
      "en_US": "Confirm",
      "zh_CN": "确定",
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
    "picker_title_sector": {
      "en_US": "Select Object",
      "zh_CN": "选择天体",
    },
    "picker_title_token": {
      "en_US": "Select Token",
      "zh_CN": "选择Token",
    },
    "picker_item_none_token": {
      "en_US": "None",
      "zh_CN": "不使用",
    },
    "picker_title_clue": {
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
