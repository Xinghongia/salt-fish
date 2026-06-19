-- 系统公告表
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '公告标题',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '公告内容',
  `admin_id` int(11) NOT NULL COMMENT '发布管理员ID',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否显示',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- 插入默认公告
INSERT INTO `announcement` (title, content, admin_id, is_active, create_time) 
VALUES ('欢迎使用校园盐鱼', '这是一个校园二手交易平台，祝你交易愉快！', 10, 1, NOW());
-- 用户反馈表
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `type` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT 'other' COMMENT '反馈类型',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '反馈内容',
  `contact` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '联系方式',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
