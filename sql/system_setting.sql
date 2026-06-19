-- 系统设置表
CREATE TABLE IF NOT EXISTS `system_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL COMMENT '设置键名',
  `setting_value` text COMMENT '设置值',
  `description` varchar(255) DEFAULT NULL COMMENT '设置说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统设置表';

-- 默认设置
INSERT INTO `system_setting` (`setting_key`, `setting_value`, `description`) VALUES
('site_name', '校园盐鱼', '站点名称'),
('site_description', '校园二手交易平台，让闲置物品找到新主人', '站点描述'),
('perpage_goods', '12', '商品每页显示数量'),
('maintenance_mode', '0', '维护模式：0关闭 1开启')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);