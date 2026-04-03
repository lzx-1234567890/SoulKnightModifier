.pragma library

const AllSeason = [
    {"id": "Aram2", "name": "迷迭岛游记2"},
    {"id": "Artifacts2", "name": "古大陆的神器2"},
    {"id": "Troop2", "name": "大大指挥官"},
    {"id": "ComboGun", "name": "枪斗三国"},
    {"id": "Aram", "name": "迷迭岛游记"},
    {"id": "IronTide", "name": "机械狂潮"},
]


const ExtraSeason = [
    {"id": "Artifacts", "name": "古大陆的神器"},
    {"id": "Troop", "name": "小小指挥官"},
]

//迷迭岛游记2
const Aram2 = {
    "name": "迷迭岛游记2",
    "NormalTasks": {
        1027: {"description": "累计携带4种开局挑战因子通关难度6", "target": 4},
        1022: {"description": "全程只用手刀通关妖气模式的难度6", "target": 1},
        1023: {"description": "在蚀月魔狼存活的前提下通关妖气模式难度6", "target": 1},
        1024: {"description": "使用火属性伤害累计击败5次蚀月魔狼", "target": 5},
        1025: {"description": "妖气等级达到30级", "target": 30},
        1026: {"description": "累计摧毁100株植物", "target": 100},
        1001: {"description": "迷迭岛旅程(通关难度1)", "target": 1},
        1002: {"description": "迷迭岛旅程(通关难度2)", "target": 2},
        1003: {"description": "迷迭岛旅程(通关难度3)", "target": 3},
        1004: {"description": "迷迭岛旅程(通关难度4)", "target": 4},
        1005: {"description": "迷迭岛旅程(通关难度5)", "target": 5},
        1006: {"description": "迷迭岛旅程(通关难度6)", "target": 6},
        1007: {"description": "累计使用6个角色通关", "target": 6},
        1008: {"description": "累计使用12个角色通关", "target": 12},
        1009: {"description": "累计使用18个角色通关", "target": 18},
        1010: {"description": "累计使用21个角色通关", "target": 21},
        1011: {"description": "一局游戏中获得12种天赋", "target": 12},
        1012: {"description": "一局游戏中获得4种传说天赋", "target": 4},
        1013: {"description": "一局游戏中获得15种饮料或料理", "target": 15},
        1014: {"description": "迷迭岛旅程(通关一次联机模式)", "target": 1},
        1015: {"description": "迷迭岛旅程(通关一次妖气模式)", "target": 1},
        1016: {"description": "累计击败1000个敌人", "target": 1000},
        1017: {"description": "累计击败2000个敌人", "target": 2000},
        1018: {"description": "累计击败3000个敌人", "target": 3000},
        1019: {"description": "累计击败6000个敌人", "target": 6000},
        1020: {"description": "累计击败12000个敌人", "target": 12000},
        1021: {"description": "累计击败18000个敌人", "target": 18000}
    },
    "WeeklyTasks": {
        1: {"description": "迷迭岛旅程(通关一次任意难度)", "target": 1},
        3: {"description": "单局游戏中近战伤害加成达到10", "target": 10},
        4: {"description": "单局游戏中远程伤害加成达到10", "target": 10},
        5: {"description": "单局游戏中召唤物伤害加成达到15", "target": 15},
        6: {"description": "单局游戏中技能等级加成达到18", "target": 18}
    },
}

const Artifacts2 = {
    "name": "古大陆的神器2",
    "NormalTasks": {
        101: {"description": "普通难度通关", "target": 1},
        102: {"description": "炸天难度通关", "target": 1},
        103: {"description": "25分钟之内通关任意难度", "target": 25},
        104: {"description": "30分钟之内通关任意难度", "target": 30},
        105: {"description": "35分钟之内通关任意难度", "target": 35},
        106: {"description": "30分钟之内通关炸天难度", "target": 30},
        107: {"description": "35分钟之内通关炸天难度", "target": 35},
        108: {"description": "40分钟之内通关炸天难度", "target": 40},
        109: {"description": "将一种铭文升级到4级", "target": 4},
        110: {"description": "将一种铭文升级到8级", "target": 8},
        111: {"description": "将一种铭文升级到10级", "target": 10},
        112: {"description": "武器等级达到4级", "target": 4},
        113: {"description": "武器等级达到8级", "target": 8},
        114: {"description": "武器等级达到12级", "target": 12},
        115: {"description": "武器等级达到16级", "target": 16},
        116: {"description": "武器等级达到20级", "target": 20},
        117: {"description": "累计承受50点伤害", "target": 50},
        118: {"description": "累计承受100点伤害", "target": 100},
        119: {"description": "累计承受200点伤害", "target": 200},
        120: {"description": "累计承受300点伤害", "target": 300},
        121: {"description": "累计承受500点伤害", "target": 500},
        122: {"description": "累计承受1000点伤害", "target": 1000},
        123: {"description": "随从或宠物累计造成20000点伤害", "target": 20000},
        124: {"description": "能量上限达到500点", "target": 500},
        125: {"description": "累计造成50000点元素伤害", "target": 50000},
        126: {"description": "一局游戏中移动速度加成达到100%", "target": 100},
        127: {"description": "在一局游戏中集齐任意一个系列的武器部件", "target": 1},
    },
    "WeeklyTasks": {
        1: {"description": "击败1000个敌人", "target": 1000},
        2: {"description": "收集2000神器余烬", "target": 2000},
        3: {"description": "收集40种铭文", "target": 40},
        4: {"description": "将一种铭文升级到8级", "target": 8},
        5: {"description": "普通难度通关", "target": 1},
    }
}

const Troop2 = {
    "name": "大大指挥官",
    "NormalTasks": {
        101: {"description": "通关赛季模式难度1", "target": 1},
        102: {"description": "通关赛季模式难度2", "target": 2},
        103: {"description": "通关赛季模式难度3", "target": 3},
        104: {"description": "通关赛季模式难度4", "target": 4},
        105: {"description": "通关赛季模式难度5", "target": 5},
        106: {"description": "累计获取15次史诗(紫色)品质以上的演员", "target": 15},
        107: {"description": "累计获取10次传说(橙色)品质以上的演员", "target": 10},
        108: {"description": "累计达成1次群雄逐鹿-5羁绊", "target": 1},
        109: {"description": "累计达成1次远古神话-4羁绊", "target": 1},
        110: {"description": "累计达成1次璀璨文明-4羁绊", "target": 1},
        111: {"description": "累计达成1次神仙妖怪-5羁绊", "target": 1},
        112: {"description": "累计雇佣10种不同的演员", "target": 10},
        113: {"description": "累计雇佣18种不同的演员", "target": 18},
        114: {"description": "累计获取10次2星演员", "target": 10},
        115: {"description": "累计获取10次.星演员", "target": 10},
        116: {"description": "累计击败500个敌人", "target": 500},
        117: {"description": "累计击败1000个敌人", "target": 1000},
        118: {"description": "累计造成200000点伤害", "target": 200000},
        119: {"description": "累计造成1000000点伤害", "target": 1000000},
        120: {"description": "不损失人气值通关难度1", "target": 1},
        121: {"description": "不损失人气值通关难度2", "target": 2},
        122: {"description": "不损失人气值通关难度3", "target": 3},
    },
    "WeeklyTasks": {
        1: {"description": "累计对敌人造成100000点伤害", "target": 100000},
        2: {"description": "累计击败1000个敌人", "target": 1000},
        3: {"description": "累计击败3个首领", "target": 3},
        4: {"description": "累计获取2个2星橙色传说品质演员", "target": 2},
        5: {"description": "累计购买10个天赋", "target": 10},
        6: {"description": "累计购买10把武器", "target": 10},
        7: {"description": "累计获取300金币", "target": 300},
    }
}

const ComboGun = {
    "name": "枪斗三国",
    "NormalTasks": {
        101: {"description": "赢得战役:教学战役", "target": 1},
        102: {"description": "赢得难度1战役:讨伐董卓(下)", "target": 1},
        103: {"description": "赢得难度5战役:讨伐董卓(下)", "target": 1},
        104: {"description": "获取10种不同的武器", "target": 10},
        105: {"description": "获取20种不同的配件", "target": 20},
        106: {"description": "获取5次史诗(紫色)品质以上的武器", "target": 5},
        107: {"description": "获取10次史诗(紫色)品质以上的配件", "target": 10},
        108: {"description": "获取5次传说(橙色)品质武器", "target": 5},
        109: {"description": "获取10次传说(橙色)品质配件", "target": 10},
        110: {"description": "携带2把罕见(绿色)及以下品质的武器通关难度5战役", "target": 1},
        111: {"description": "携带2把史诗(紫色)及以上品质的武器通关难度5战役", "target": 1},
        112: {"description": "武器输出评分,达到C级", "target": 1},
        113: {"description": "武器输出评分,达到A级", "target": 1},
        114: {"description": "武器输出评分,达到S级", "target": 1},
        115: {"description": "讨伐董卓战役中,官爵达到1级“队率”", "target": 1},
        116: {"description": "讨伐董卓战役中,官爵达到4级“校尉”", "target": 1},
        117: {"description": "讨伐董卓战役中,官爵达到6级“将军”", "target": 1},
        122: {"description": "击败据点内的敌人,成功占领10个据点", "target": 10},
        123: {"description": "击败据点内的敌人,成功占领20个据点", "target": 20},
        124: {"description": "在武器库获取5次武器", "target": 5},
        125: {"description": "使用5次恢复药水", "target": 5},
        128: {"description": "拥有4位亲卫", "target": 4},
        129: {"description": "拥有2位满级亲卫", "target": 2},
        130: {"description": "拥有4个坐骑", "target": 4},
        131: {"description": "拥有2个满级坐骑", "target": 2},
        132: {"description": "获取15种不同的武器", "target": 15},
        133: {"description": "获取25种不同的配件", "target": 25},
        134: {"description": "击败据点内的敌人,成功占领20个据点", "target": 20},
        135: {"description": "在武器库获取10次武器", "target": 10},
        136: {"description": "使用10次恢复药水", "target": 10},
        137: {"description": "拥有6位亲卫", "target": 6},

    },
    "WeeklyTasks": {
        1: {"description": "对敌人造成100000点伤害", "target": 100000},
        2: {"description": "击败1000个敌人", "target": 1000},
        3: {"description": "击败20个据点首领", "target": 20},
        4: {"description": "击败首领华雄", "target": 1},
        5: {"description": "获取30种不同的配件", "target": 30},
        6: {"description": "获取15种不同的武器", "target": 15},
        7: {"description": "获取2000金币", "target": 2000},
        8: {"description": "赢得3场战役", "target": 3},
        9: {"description": "击败首领李傕", "target": 1},
        10: {"description": "击败首领董卓", "target": 1},
    },
    "Follower": [
        {"name": "皇甫嵩", "id": "HuangFuSong"},
        {"name": "吕玲绮", "id": "LvQiLing"},
        {"name": "马云禄", "id": "MaYunLu"},
        {"name": "水镜先生", "id": "ShuiJing"},
        {"name": "太史慈母", "id": "TaiShiCiMu"},
        {"name": "文远", "id": "WenYuan"},
    ],
    "Mount": [
        {"name": "灰影", "id": "HuiYing"},
        {"name": "孟获", "id": "MengHuo"},
        {"name": "南蛮象", "id": "NanManXiang"},
        {"name": "爪黄飞电", "id": "ZhuaHuangFeiDian"},
    ]
}

const Aram = {
    "name": "迷迭岛游记",
    "Events": [
        {"id": "aram_kill", "description": "累计击败50000个敌人", "target": 50000},
        {"id": "aram_elem_dmg", "description": "元素伤害加成达到15", "target": 15},
        {"id": "aram_range_dmg", "description": "远程伤害加成达到15", "target": 15},
        {"id": "aram_melee_dmg", "description": "近战伤害加成达到15", "target": 15},
        {"id": "aram_max_hp", "description": "最大血量达到40", "target": 40},
        {"id": "aram_skill_level", "description": "技能等级达到15", "target": 15},
        {"id": "aram_talent_count", "description": "一局游戏中获得12种天赋", "target": 12},
        {"id": "aram_legendary_talent_count", "description": "一局游戏中获得4种传说天赋", "target": 4},
        {"id": "aram_drinks_count", "description": "一局游戏中获得15种饮料或料理", "target": 15},
    ]
}

const IronTide = {
    "name": "机械狂潮",
    "Events": [
        {"id": "iron_tide_reward_achievement_0", "description": ""},
        {"id": "iron_tide_reward_achievement_1", "description": ""},
        {"id": "iron_tide_reward_task_1", "description": ""},
        {"id": "iron_tide_reward_task_2", "description": ""},
    ],
    "chip": [
        {"name": "致命", "id": "Fatal"},
        {"name": "掠夺", "id": "Raven"},
        {"name": "爆发", "id": "Burst"},
        {"name": "气盛", "id": "Vigorous"},
        {"name": "屏障", "id": "Barrier"},
        {"name": "荆棘", "id": "Thorns"},
        {"name": "涌动", "id": "Surge"},
        {"name": "灵动", "id": "Flexible"},
        {"name": "坚毅", "id": "Gritty"},
        {"name": "充沛", "id": "Abundant"},
        {"name": "再生", "id": "Regen"},
        {"name": "震荡", "id": "Shock"},
        {"name": "狂热", "id": "Zealot"},
        {"name": "律动", "id": "Rhythm"},
        {"name": "轻盈", "id": "Light"},
        {"name": "协奏", "id": "Concerto"},
        {"name": "英雄之证", "id": "ProofOfHero"},
        {"name": "霸者之证", "id": "ProofOfTyrant"},
    ]
}

const Artifacts = {
    "name": "古大陆的神器",
}

const Troop = {
    "name": "小小指挥官",
}