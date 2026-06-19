-- Admin Log Table
CREATE TABLE IF NOT EXISTS `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL COMMENT '操作管理员ID',
  `admin_name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '管理员名称',
  `action` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '操作类型',
  `target` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '操作对象',
  `detail` text COLLATE utf8_bin COMMENT '操作详情',
  `create_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Feedback Table (if not exists)
CREATE TABLE IF NOT EXISTS `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '反馈用户ID',
  `type` varchar(20) COLLATE utf8_bin DEFAULT 'other' COMMENT '反馈类型',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '反馈内容',
  `contact` varchar(100) COLLATE utf8_bin DEFAULT '' COMMENT '联系方式',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
