-- 给 message 表添加已读状态字段
ALTER TABLE `message` ADD COLUMN `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0=未读 1=已读' AFTER `send_time`;

-- 给现有消息默认标记为已读（历史消息不算未读）
UPDATE `message` SET `is_read` = 1 WHERE `is_read` = 0;