-- 给user表添加role字段 (0=普通用户, 1=管理员)
ALTER TABLE `user` ADD COLUMN `role` int(11) NOT NULL DEFAULT 0 COMMENT '角色: 0=普通用户, 1=管理员';

-- 设置ID<1000的用户为管理员（兼容现有数据）
UPDATE `user` SET `role`=1 WHERE `id` < 1000;

-- 创建管理员账号
-- 邮箱: admin@saltfish.com  密码: admin123
INSERT INTO `user` (`id`, `email`, `img`, `pwd`, `name`, `role`) 
VALUES (999, 'admin@saltfish.com', 'static/user_img/0.jpg', '0c909a141f1f2c0a1cb602b0b2d7d050', '管理员', 1);