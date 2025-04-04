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
    "preferSeason": {
      "en_US": "Prefer Season",
      "zh_CN": "首选季节",
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
    // rules:
    "rule_title": {
      "en_US": "Rules",
      "zh_CN": "规则",
    },
    "sector_rules": {
      "en_US": "Sector Rules",
      "zh_CN": "天体规则",
    },
    "rules_comet": {
      "en_US": "2, only in particular sectors (prime)",
      "zh_CN": "2个，在特定位置出现（质数）",
    },
    "rules_asteroid": {
      "en_US": "4, adjacent to another asteroid",
      "zh_CN": "4个，和另一个小行星相邻",
    },
    "rules_dwarf_planet_standard": {
      "en_US": "1, not adjacent to planet X",
      "zh_CN": "1个，不和 X 行星相邻",
    },
    "rules_dwarf_planet_expert": {
      "zh_CN": "4个，在一个连续的6格区间内，且首尾是矮行星。不和 X 行星相邻。用 ● 表示的话有如下6种可能 \n ●●●○○● | ●●○●○● | ●●○○●● | ●○●●○● | ●○●○●● | ●○○●●●",
      "en_US": "4, in a band of 6, not adjacent to planet X. The first and last are dwarf planets. \n ●●●○○● | ●●○●○● | ●●○○●● | ●○●●○● | ●○●○●● | ●○○●●●",
    },
    "rules_nebula": {
      "en_US": "2, adjacent to a truly space",
      "zh_CN": "2个，和真正的空域相邻",
    },
    "rules_x": {
      "en_US": "1, not adjacent to a dwarf planet, appears space",
      "zh_CN": "1个，不和矮行星相邻，勘测起来像是空域",
    },
    "rules_space_standard": {
      "en_US": "2, remember, planet X appears space",
      "zh_CN": "2个，记住，X 行星看起来也像空域",
    },
    "rules_space_expert": {
      "en_US": "5, remember, planet X appears space",
      "zh_CN": "5个，记住，X 行星看起来也像空域",
    },
    "operation_rules": {
      "en_US": "Operation Rules",
      "zh_CN": "操作规则",
    },
    "op_rule_survey": {
      "en_US": "Survey a segment of visible sectors, revealing the number of a certain type of sector",
      "zh_CN": "勘测一段可见星区内的某种天体，揭示其中的数量（X行星也会被记作空域）",
    },
    "op_rule_target": {
      "en_US": "Scan a sector, revealing the type of sector",
      "zh_CN": "扫描一个星区，揭示该星区的类型（X行星也会显示为空域）",
    },
    "op_rule_research": {
      "en_US": "Research a clue, revealing the relationship between one or two sectors",
      "zh_CN": "研究一个课题，获取一种或两种天体之间的关系",
    },
    "op_rule_locate_x": {
      "en_US": "Locate X, requires the type of two adjacent sectors",
      "zh_CN": "定位X，需要同时提供相邻的两个星区的类型",
    },
    "op_rule_ready_publish": {
      "en_US":
          "Prepare Theory, prepare the theory to be published (at most two theories can be published in expert mode)",
      "zh_CN": "准备理论，准备要发表的理论(专家难度下可以至多发布两篇理论)",
    },
    "op_rule_do_publish": {
      "en_US": "Publish Theory, publish the prepared theory. The revealed sector cannot be published again",
      "zh_CN": "发表理论，发表准备好的理论。已经被揭示的星区无法再次发表",
    },
    "gameplay_rules": {
      "en_US": "GamePlay Rules",
      "zh_CN": "流程规则",
    },
    "gameplay_rules_desc": {
      "zh_CN": """
## 游戏分为 3 个阶段：操作阶段、会议阶段、终局阶段。

1. 操作阶段，按照玩家顺位，最前面的玩家进行操作，操作完成后，玩家根据操作不同前进不同步数，顺位轮转到下一个玩家。

2. 当碰到会议标记时，进入会议阶段。所有玩家准备是否发表理论，准备完成后，所有玩家进行会议，公布每个玩家的发表数量，按照位置关系顺序执行发表理论的操作。

会议结束后，所有玩家发表的理论会推进进度一格，推进第三次即被揭晓。发表错误理论的 Token 会被移开，且对应玩家被惩罚前进一格。发表正确则会将该星区所有理论均揭晓，其中错误的同样前进一格。

3. 当某个玩家成功定位到 X 行星时，游戏进入到终局阶段。在成功定位到 X 行星之前顺位的玩家，按顺位还可以执行最后一次操作，定位 X 或者匿名发表理论。其中相距定位玩家较远的玩家至多可以发表两篇理论。

## 其它：

一局游戏至多可以进行两次定位操作。任何人不可以连续进行两次研究操作。

可见星区会随着进程旋转，始终保持在，从最后一个玩家开始，半个圆的范围。勘测 和 扫描操作需要在可见星区内进行。

当遇到X标志时，会公布一条关于X行星的线索。

## 分数结算：

最先正确发表某个星区，+1
正确发表彗星，+3
正确发表小行星，+2
正确发表矮行星，+2 （常规模式下+4）
正确发表气体云，+4 
第一个成功定位到X行星，+10
后续定位到X行星，+(2*距离第一个定位的玩家的距离，10/8/6/4/2）
""",
      "en_US": """
## The game is divided into 3 phases: Operation Phase, Conference Phase, and Endgame Phase.

1. Operation Phase: Players take turns to perform operations. After each operation, players advance a certain number of steps based on the type of operation performed, and the turn order rotates to the next player.

2. When a conference marker is encountered, the game enters the Conference Phase. All players prepare to publish theories. After preparation, all players hold a conference to announce the number of theories published by each player, and then execute the theory publication operations in order of their positions.

When the conference ends, all players' published theories will advance the progress by one step. The third advancement will reveal the location of Planet X. Players who publish incorrect theories will have their tokens removed and will be penalized by advancing one step. Correctly published theories will reveal all theories related to that sector, and incorrect ones will also advance one step.

3. When a player successfully locates Planet X, the game enters the Endgame Phase. Players who took turns before the successful locator can perform one last operation, either locating X or anonymously publishing a theory. Players who are farthest from the locator can publish at most two theories.

## Others:

A maximum of two locating operations can be performed in a game. No player can perform two consecutive research operations.

The visible sectors will rotate with the progress, always maintaining a half-circle range from the last player. The operations of Survey and Target must be performed within the visible sectors.

When encountering the X marker, a clue about Planet X will be revealed.

## Scoring:

First to correctly publish a sector: +1
Correctly publish a comet: +3
Correctly publish an asteroid: +2
Correctly publish a dwarf planet: +2 (4 in standard mode)
Correctly publish a nebula: +4
Correctly locate Planet X first: +10
Correctly locate Planet X later: +(2 * distance from the first locator, 10/8/6/4/2)

""",
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
    "room_button_show_rules": {
      "en_US": "Show Rules",
      "zh_CN": "查看规则",
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
    "starmap_button_switch": {
      "en_US": "Switch",
      "zh_CN": "切换",
    },
    "starmap_button_undo": {
      "en_US": "Undo",
      "zh_CN": "撤销",
    },
    "starmap_button_redo": {
      "en_US": "Redo",
      "zh_CN": "重做",
    },
    "starmap_button_history_desc": {
      "en_US": "History",
      "zh_CN": "操作历史",
    },
    "starmap_button_flip": {
      "en_US": "Flip",
      "zh_CN": "翻转",
    },
    "starmap_point_conference_hint": {
      "en_US": "Conference",
      "zh_CN": "会议",
    },
    "starmap_point_x_hint": {
      "en_US": "X Clue",
      "zh_CN": "X线索",
    },
    "starmap_point_center_hint": {
      "en_US": "Rotate",
      "zh_CN": "旋转",
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
    // print(keys);
    return keys;
  }
}
