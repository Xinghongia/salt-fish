-- ============================================================
--  校园咸鱼 - 数据库初始化脚本
--  数据库: salt-fish  |  字符集: utf8 / utf8mb4
--  用法: mysql -u root -p salt-fish < init.sql
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------
--  管理员操作日志
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `admin_log`;
CREATE TABLE `admin_log` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT,
  `admin_id`   int(11)      NOT NULL              COMMENT '操作管理员ID',
  `admin_name` varchar(50)  DEFAULT NULL           COMMENT '管理员名称',
  `action`     varchar(50)  NOT NULL               COMMENT '操作类型',
  `target`     varchar(100) DEFAULT NULL           COMMENT '操作对象',
  `detail`     text                                COMMENT '操作详情',
  `create_time` datetime    NOT NULL               COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `admin_log` VALUES
(1, 999, '管理员', '修改角色', '用户#1030', '管理员将用户#1030的角色设为管理员', '2026-06-19 18:06:59'),
(2, 999, '管理员', '批量修改角色', '共2人', '管理员批量将2人设为管理员', '2026-06-19 18:10:03'),
(3, 999, '管理员', '批量审核商品', '共2件', '管理员批量拒绝了2件商品', '2026-06-19 18:11:12');

-- -----------------------------------------------------------
--  系统公告
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `id`         int(11)      NOT NULL AUTO_INCREMENT,
  `title`      varchar(255) NOT NULL               COMMENT '公告标题',
  `content`    text         NOT NULL               COMMENT '公告内容',
  `admin_id`   int(11)      NOT NULL               COMMENT '发布管理员ID',
  `is_active`  tinyint(1)   NOT NULL DEFAULT '1'   COMMENT '是否显示: 1=显示 0=隐藏',
  `create_time` datetime    NOT NULL               COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `announcement` VALUES
(1, '欢迎使用校园咸鱼', '这是一个校园二手交易平台，祝你交易愉快！', 999, 1, '2026-06-18 13:06:29');

-- -----------------------------------------------------------
--  商品分类
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id`        int(11)     NOT NULL AUTO_INCREMENT,
  `name`      varchar(50) NOT NULL                 COMMENT '分类名称',
  `icon`      varchar(50) NOT NULL DEFAULT 'tag'   COMMENT 'lucide 图标名',
  `sort_order` int(11)    NOT NULL DEFAULT '0'     COMMENT '排序值，越小越靠前',
  `is_active` tinyint(1)  NOT NULL DEFAULT '1'     COMMENT '是否启用: 1=启用 0=禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `category` VALUES
(1, '书籍', 'book-open',  1, 1),
(2, '生活', 'home',       2, 1),
(3, '衣物', 'shirt',      3, 1),
(4, '电子', 'smartphone', 4, 1),
(5, '运动', 'dribbble',   5, 1),
(6, '其他', 'package',    6, 1);

-- -----------------------------------------------------------
--  用户收藏
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect` (
  `collect_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id`    int(11) NOT NULL                   COMMENT '用户ID',
  `goods_id`   int(11) NOT NULL                   COMMENT '商品ID',
  PRIMARY KEY (`collect_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `collect` VALUES
(1, 1022, 9),
(2, 1022, 10),
(3, 999,  10),
(4, 999,  11),
(5, 999,  9);

-- -----------------------------------------------------------
--  用户反馈
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id`          int(11)      NOT NULL AUTO_INCREMENT,
  `user_id`     int(11)      NOT NULL              COMMENT '用户ID',
  `type`        varchar(50)  NOT NULL DEFAULT 'other' COMMENT '反馈类型',
  `content`     text         NOT NULL              COMMENT '反馈内容',
  `contact`     varchar(255) DEFAULT NULL          COMMENT '联系方式',
  `create_time` datetime     NOT NULL              COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- -----------------------------------------------------------
--  商品
--  status: 1=待审核 2=在售 3=已拒绝 4=交易中 5=已售出
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id`           int(11)      NOT NULL AUTO_INCREMENT,
  `image`        char(255)    NOT NULL              COMMENT '商品图片路径',
  `type_id`      int(11)      NOT NULL              COMMENT '分类ID，关联 category 表',
  `name`         char(255)    NOT NULL              COMMENT '商品名称',
  `num`          int(11)      DEFAULT NULL          COMMENT '数量',
  `price`        float        NOT NULL              COMMENT '价格（元）',
  `status`       int(11)      NOT NULL              COMMENT '1=待审核 2=在售 3=已拒绝 4=交易中 5=已售出',
  `content`      varchar(255) NOT NULL              COMMENT '商品描述',
  `producter_id` int(11)      NOT NULL              COMMENT '卖家用户ID',
  `create_date`  datetime     NOT NULL              COMMENT '发布时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `goods` VALUES
(1,  'static/goods_img/1.jpg',  4, '笔记本',          1, 4000, 2, '二手笔记本，8成新，I7处理器',                    999,  '2020-11-25 15:57:39'),
(7,  'static/goods_img/7.jpg',  1, '考研书',          1, 30,   2, '聚星文登考研',                                  123,  '2020-11-25 15:57:39'),
(9,  'static/goods_img/9.jpg',  2, '凉席',            1, 60,   2, '寝室牛皮凉席',                                  123,  '2020-11-25 15:57:39'),
(10, 'static/goods_img/10.jpg', 2, '纯棉枕头',        1, 50,   2, '纯棉枕头',                                      123,  '2020-11-25 15:57:39'),
(11, 'static/goods_img/11.jpg', 2, 'LED台灯',         1, 100,  2, '学习卧室床头书桌大学生寝室插电节能USB调光夹子台灯', 123, '2020-11-25 15:57:39'),
(13, 'static/goods_img/13.jpg', 4, '诺基亚830手机',   1, 1200, 2, '屏幕无划痕，待机超过2天',                        999,  '2020-11-25 15:57:39'),
(14, 'static/goods_img/14.jpg', 2, '收纳架',          1, 11,   2, '多功能免钉可伸缩衣柜分层隔板',                   123,  '2020-11-25 15:57:39'),
(15, 'static/goods_img/15.jpg', 3, '双肩包',          1, 50,   2, '韩版夜光双肩包大容量个性背包，8成新',             123,  '2020-11-25 15:57:39'),
(22, 'static/goods_img/22.jpg', 6, '保温杯',          1, 30,   2, '304真空不锈钢，480ml，保温6小时',                1025, '2020-12-05 23:22:05'),
(26, 'static/goods_img/26.jpg', 4, '平板电脑',        1, 2000, 2, '平板电脑',                                      123,  '2020-12-08 00:08:42');

-- -----------------------------------------------------------
--  站内消息
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `mess_id`     int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `mess_from_id` int(11)     NOT NULL               COMMENT '发送者ID',
  `mess_to_id`  int(11)      NOT NULL               COMMENT '接收者ID',
  `mess_text`   varchar(255) NOT NULL               COMMENT '消息内容',
  `send_time`   datetime     NOT NULL               COMMENT '发送时间',
  `is_read`     tinyint(1)   NOT NULL DEFAULT '0'   COMMENT '0=未读 1=已读',
  `mess_type`   int(11)      DEFAULT NULL           COMMENT '消息类型',
  PRIMARY KEY (`mess_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `message` VALUES
(1, 999, 1032, '你好，欢迎使用校园咸鱼！',                '2026-06-19 14:42:18', 1, NULL),
(2, 1032, 999, '你好，请问有考研资料吗？',                 '2026-06-19 15:00:40', 1, NULL),
(3, 999, 1032, '【购买通知】用户 管理员 购买了你的商品「笔记本」，请及时确认交易。', '2026-06-19 15:57:53', 0, NULL);

-- -----------------------------------------------------------
--  订单
--  status: 0=进行中 1=已完成 2=已取消
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id`      int(11)      NOT NULL AUTO_INCREMENT,
  `goods_id` int(11)     NOT NULL                   COMMENT '商品ID',
  `user_id` int(11)      NOT NULL                   COMMENT '买家用户ID',
  `date`    datetime     NOT NULL                   COMMENT '下单时间',
  `message` varchar(255) DEFAULT NULL               COMMENT '买家留言',
  `status`  int(11)      DEFAULT '0'                COMMENT '0=进行中 1=已完成 2=已取消',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `order` VALUES
(1, 9,  999,  '2026-06-19 15:42:19', '',                    0),
(2, 10, 999,  '2026-06-19 15:42:27', '通过购物车批量购买',  0),
(3, 11, 999,  '2026-06-19 15:42:27', '通过购物车批量购买',  0);

-- -----------------------------------------------------------
--  登录会话
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `sessionkey`;
CREATE TABLE `sessionkey` (
  `id`          int(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_key` varchar(127) NOT NULL               COMMENT '会话密钥',
  `user_id`     int(20) unsigned NOT NULL            COMMENT '用户ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sessionkey` VALUES
(1, '3f6599934e57fe9cb443faf134bc5af4', 999);

-- -----------------------------------------------------------
--  购物车
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `shoppingcart`;
CREATE TABLE `shoppingcart` (
  `shop_id`  int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL                       COMMENT '商品ID',
  `user_id`  int(11) NOT NULL                       COMMENT '用户ID',
  PRIMARY KEY (`shop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `shoppingcart` VALUES
(1, 13, 999),
(2, 15, 999);

-- -----------------------------------------------------------
--  系统设置
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `system_setting`;
CREATE TABLE `system_setting` (
  `id`            int(11)      NOT NULL AUTO_INCREMENT,
  `setting_key`   varchar(100) NOT NULL             COMMENT '设置键名',
  `setting_value` text                             COMMENT '设置值',
  `description`   varchar(255) DEFAULT NULL         COMMENT '设置说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统设置表';

INSERT INTO `system_setting` VALUES
(1, 'site_name',        '校园咸鱼',                              '站点名称'),
(2, 'site_description', '校园二手交易平台，让闲置物品找到新主人', '站点描述'),
(3, 'perpage_goods',    '12',                                    '商品每页显示数量'),
(4, 'maintenance_mode', '0',                                     '维护模式：0关闭 1开启');

-- -----------------------------------------------------------
--  用户
--  role: 0=普通用户 1=管理员
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id`          int(11)      NOT NULL AUTO_INCREMENT,
  `email`       char(255)    NOT NULL               COMMENT '邮箱（登录账号）',
  `img`         char(255)    DEFAULT NULL            COMMENT '头像路径',
  `pwd`         char(255)    NOT NULL               COMMENT '密码（MD5）',
  `name`        char(255)    DEFAULT NULL            COMMENT '昵称',
  `stu_num`     char(255)    DEFAULT NULL            COMMENT '学号',
  `qq`          char(255)    DEFAULT NULL            COMMENT 'QQ号',
  `phone`       char(255)    DEFAULT NULL            COMMENT '手机号',
  `mess_num`    int(11)      NOT NULL DEFAULT '0'   COMMENT '未读消息数',
  `role`        int(11)      NOT NULL DEFAULT '0'   COMMENT '0=普通用户 1=管理员',
  `create_date` datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 默认密码均为 123456 (MD5: e10adc3949ba59abbe56e057f20f883e)
-- 管理员账号: admin@saltfish.com / admin888
INSERT INTO `user` VALUES
(999,  'admin@saltfish.com',   'static/user_img/0.jpg', '0c909a141f1f2c0a1cb602b0b2d7d050', '管理员',  '',      '', '15',     0, 1, '2026-06-19 11:07:10'),
(10,   '1159891180@qq.com',    'static/user_img/1.jpg', '385895e41f65a63bdfb93b9d2048e69d', '韩志强',  NULL,    NULL, '15256925578', 7, 1, '2026-06-19 11:07:10'),
(123,  '2236188843@qq.com',    'static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d','王华强',  NULL,    NULL, NULL,   0, 1, '2026-06-19 11:07:10'),
(1017, '865616284@qq.com',     'static/user_img/1017.jpg','385895e41f65a63bdfb93b9d2048e69d','赵文军',  NULL,    NULL, '13245634567', 0, 0, '2026-06-19 11:07:10'),
(1019, '864636142@qq.com',     'static/user_img/1019.jpg','385895e41f65a63bdfb93b9d2048e69d','罗杰',    NULL,    NULL, NULL,   0, 0, '2026-06-19 11:07:10'),
(1022, 'luna_nov@163.com',     'static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d','luna',    NULL,    NULL, '15696756582', 0, 0, '2026-06-19 11:07:10'),
(1025, '123456@qq.com',        NULL,                     '14e1b600b1fd579f47433b88e8d85291','陈章月',  NULL,    NULL, NULL,   2, 0, '2026-06-19 11:07:10'),
(1026, '223618@qq.com',        'static/user_img/0.jpg',  'e10adc3949ba59abbe56e057f20f883e','陆全有',  NULL,    NULL, '123456',0, 0, '2026-06-19 11:07:10'),
(1031, '865616281@qq.com',     'static/user_img/0.jpg',  '385895e41f65a63bdfb93b9d2048e69d','小华',    NULL,    NULL, NULL,   0, 0, '2026-06-19 11:07:10'),
(1032, '3376219386@qq.com',    'static/user_img/1032.jpg','e70f9c34540f7e6c03550193b9fe5e13','xinghong','81818', '4858','2151',0, 0, '2026-06-19 11:07:10');

SET FOREIGN_KEY_CHECKS = 1;
