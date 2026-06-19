-- MySQL dump 10.13  Distrib 5.7.40, for Linux (x86_64)
--
-- Host: localhost    Database: salt-fish
-- ------------------------------------------------------
-- Server version	5.7.40-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_log`
--

DROP TABLE IF EXISTS `admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) NOT NULL COMMENT '操作管理员ID',
  `admin_name` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '管理员名称',
  `action` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '操作类型',
  `target` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '操作对象',
  `detail` text COLLATE utf8_bin COMMENT '操作详情',
  `create_time` datetime NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_log`
--

LOCK TABLES `admin_log` WRITE;
/*!40000 ALTER TABLE `admin_log` DISABLE KEYS */;
INSERT INTO `admin_log` VALUES (2,999,'管理员','确认交易完成','商品#29','卖家确认交易完成 11','2026-06-19 11:22:55'),(3,999,'管理员','取消交易','商品#30','卖家取消交易 角色卡','2026-06-19 11:31:01'),(4,999,'管理员','删除商品','商品#31','管理员删除了商品#31','2026-06-19 16:23:09'),(5,999,'管理员','删除商品','商品#30','管理员删除了商品#30','2026-06-19 16:23:12'),(6,999,'管理员','管理员取消交易','商品#15','管理员取消交易 沃曼威斯韩版夜光双肩包大容量个性背包','2026-06-19 16:23:30'),(7,999,'管理员','管理员取消交易','商品#7','管理员取消交易 考研书','2026-06-19 16:23:33'),(8,999,'管理员','管理员取消交易','商品#16','管理员取消交易 华为荣耀4x手机','2026-06-19 16:23:38'),(9,999,'管理员','管理员取消交易','商品#13','管理员取消交易 诺基亚830手机','2026-06-19 16:23:41'),(10,999,'管理员','删除商品','商品#28','管理员删除了商品#28','2026-06-19 16:24:05'),(11,999,'管理员','删除商品','商品#27','管理员删除了商品#27','2026-06-19 16:24:13'),(12,999,'管理员','删除订单','订单#27','管理员删除了订单#27','2026-06-19 16:24:38'),(13,999,'管理员','删除订单','订单#26','管理员删除了订单#26','2026-06-19 16:24:41'),(14,999,'管理员','删除订单','订单#21','管理员删除了订单#21','2026-06-19 16:24:44'),(15,999,'管理员','删除订单','订单#18','管理员删除了订单#18','2026-06-19 16:24:48'),(16,999,'管理员','管理员取消交易','商品#12','管理员取消交易 《c primer plus(第五版)中文版》C语言经典入门书籍','2026-06-19 16:24:54'),(17,999,'管理员','修改角色','用户#1030','管理员将用户#1030的角色设为管理员','2026-06-19 18:06:59'),(18,999,'管理员','管理员取消交易','商品#14','管理员取消交易 室内物品收纳架，多功能免钉可伸缩衣柜分层隔板','2026-06-19 18:08:14'),(19,999,'管理员','批量修改角色','共2人','管理员批量将2人设为管理员','2026-06-19 18:10:03'),(20,999,'管理员','修改角色','用户#1029','管理员将用户#1029的角色设为管理员','2026-06-19 18:10:23'),(21,999,'管理员','批量审核商品','共2件','管理员批量拒绝了2件商品','2026-06-19 18:11:12'),(22,999,'管理员','批量审核商品','共1件','管理员批量拒绝了1件商品','2026-06-19 18:33:47'),(23,999,'管理员','批量禁用分类','共2个','管理员批量禁用了2个分类','2026-06-19 18:34:11'),(24,999,'管理员','批量启用分类','共2个','管理员批量启用了2个分类','2026-06-19 18:34:19'),(25,999,'管理员','批量修改角色','共1人','管理员批量将1人设为管理员','2026-06-19 18:34:31'),(26,999,'管理员','批量修改角色','共1人','管理员批量将1人设为管理员','2026-06-19 18:37:28'),(27,999,'管理员','批量修改角色','共2人','管理员批量将2人设为管理员','2026-06-19 18:38:14'),(28,999,'管理员','批量修改角色','共5人','管理员批量将5人设为普通用户','2026-06-19 18:38:24'),(29,999,'管理员','批量显示公告','共1条','管理员批量显示了1条公告','2026-06-19 18:45:08'),(30,999,'管理员','批量禁用分类','共6个','管理员批量禁用了6个分类','2026-06-19 18:45:15'),(31,999,'管理员','批量启用分类','共6个','管理员批量启用了6个分类','2026-06-19 18:45:19');
/*!40000 ALTER TABLE `admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcement`
--

DROP TABLE IF EXISTS `announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `announcement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '公告标题',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '公告内容',
  `admin_id` int(11) NOT NULL COMMENT '发布管理员ID',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement`
--

LOCK TABLES `announcement` WRITE;
/*!40000 ALTER TABLE `announcement` DISABLE KEYS */;
INSERT INTO `announcement` VALUES (1,'欢迎使用校园咸鱼','这是一个校园二手交易平台，祝你交易愉快！',10,1,'2026-06-18 13:06:29');
/*!40000 ALTER TABLE `announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `icon` varchar(50) NOT NULL DEFAULT 'tag' COMMENT 'lucide图标名',
  `sort_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'书籍','book-open',1,1),(2,'生活','home',2,1),(3,'衣物','shirt',3,1),(4,'电子','smartphone',4,1),(5,'运动','dribbble',5,1),(6,'其他','package',6,1);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collect`
--

DROP TABLE IF EXISTS `collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collect` (
  `collect_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户编号',
  `goods_id` int(11) NOT NULL COMMENT '收集物品编号',
  PRIMARY KEY (`collect_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collect`
--

LOCK TABLES `collect` WRITE;
/*!40000 ALTER TABLE `collect` DISABLE KEYS */;
INSERT INTO `collect` VALUES (2,1022,15),(3,0,7),(4,0,1),(5,1022,2),(6,1022,3),(7,123,2),(8,1025,1),(9,1025,9),(10,1025,13),(11,1025,16),(12,1022,1),(13,123,22),(14,123,22),(15,123,22),(18,1026,22),(19,1031,26),(47,1032,9),(48,1032,10),(51,999,10),(52,999,11),(53,999,9),(55,999,14),(56,999,13),(57,999,15);
/*!40000 ALTER TABLE `collect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `type` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT 'other' COMMENT '反馈类型',
  `content` text COLLATE utf8_bin NOT NULL COMMENT '反馈内容',
  `contact` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '联系方式',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods`
--

DROP TABLE IF EXISTS `goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image` char(255) COLLATE utf8_bin NOT NULL,
  `type_id` int(11) NOT NULL COMMENT '类型id',
  `name` char(255) COLLATE utf8_bin NOT NULL COMMENT '商品名',
  `num` int(11) DEFAULT NULL COMMENT '数量',
  `price` float NOT NULL,
  `status` int(11) NOT NULL,
  `content` varchar(255) COLLATE utf8_bin NOT NULL,
  `producter_id` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods`
--

LOCK TABLES `goods` WRITE;
/*!40000 ALTER TABLE `goods` DISABLE KEYS */;
INSERT INTO `goods` VALUES (1,'static/goods_img/1.jpg',4,'笔记本',1,4000,4,'二手笔记本，8成新，I7处理器',10,'2020-11-25 15:57:39'),(2,'static/goods_img/2.jpg',2,'被套',1,30,4,'二手被套',1017,'2020-11-25 15:57:39'),(3,'static/goods_img/3.jpg',2,'自行车',1,50,4,'二手自行车',1017,'2020-11-25 15:57:39'),(4,'static/goods_img/4.jpg',5,'网球拍',1,50,4,'二手网球拍，用过几天，九成新',123,'2020-11-25 15:57:39'),(5,'static/goods_img/5.jpg',5,'篮球',1,80,4,'全牛皮篮球，',9,'2020-11-25 15:57:39'),(6,'static/goods_img/6.jpg',2,'懒人桌',1,15,4,'加固型懒人桌，九成新',123,'2020-11-25 15:57:39'),(7,'static/goods_img/7.jpg',1,'考研书',1,30,2,'聚星文登考研',123,'2020-11-25 15:57:39'),(8,'static/goods_img/8.jpg',1,'公务员书',1,30,4,'公务员考试书籍，9成新',123,'2020-11-25 15:57:39'),(9,'static/goods_img/9.jpg',2,'凉席',1,60,4,'寝室牛皮凉席',123,'2020-11-25 15:57:39'),(10,'static/goods_img/10.jpg',2,'纯棉枕头',1,50,4,'纯棉枕头',123,'2020-11-25 15:57:39'),(11,'static/goods_img/11.jpg',2,'LED台灯，学习卧室床头书桌大学生寝室插电节能USB调光夹子台灯',1,100,4,'灯光颜色默认自然光，轻微偏黄的灯光颜色，台灯默认USB接口，台灯供电方式：1，可用一切手机充电器直接插220V家用插座。 2，可接电脑USB。 3，可接手机充电宝供电。（注：这款不是充电台灯，不带蓄电池，必须连着电源使用）',123,'2020-11-25 15:57:39'),(12,'static/goods_img/12.jpg',1,'《c primer plus(第五版)中文版》C语言经典入门书籍',1,23,2,'只翻过几次，几乎全新。',10,'2020-11-25 15:57:39'),(13,'static/goods_img/13.jpg',4,'诺基亚830手机',1,1200,2,'购买时间在一年内，无保修，屏幕无划痕或坏点，机身有破裂损伤，完全正常，曾无拆无修，待机时长超过2天。相关配件有原装电池。',10,'2020-11-25 15:57:39'),(14,'static/goods_img/14.jpg',2,'室内物品收纳架，多功能免钉可伸缩衣柜分层隔板',1,11,2,'多功能免钉无痕衣柜分层架，',123,'2020-11-25 15:57:39'),(15,'static/goods_img/15.jpg',3,'沃曼威斯韩版夜光双肩包大容量个性背包',1,50,2,'书包，8成新\r\n',123,'2020-11-25 15:57:39'),(16,'static/goods_img/16.jpg',4,'华为荣耀4x手机',1,450,2,'移动4g标配版在保九新，京东抢购的，配件发票箱盒齐全，已经贴好钢化膜，送一软壳，便框有些许磕碰，不明显，屏幕右上方有出厂黄斑，4x通病，买回来就这样，无拆无修，特价处理。不议价，顺丰到付。',10,'2020-11-25 15:57:39'),(17,'static/goods_img/17.jpg',4,'畅学STM32开发学习板，配套stm32f103c8t6最小系统核心板',1,67,2,'畅学STM32开发学习板，所有模块均可用',10,'2020-11-25 15:57:39'),(18,'static/goods_img/18.jpg',1,'地球往事系列小说 ，三体1+三体2黑暗森林+三体3死神永生',1,72,2,'重庆出版集团出版\r\n全部是正版\r\nISBN编号: 9787536693968',10,'2020-11-25 15:57:39'),(19,'static/goods_img/19.jpg',1,'《1984》(精装珍藏本) 奥威尔著  世界名著小说',1,23,2,'全新\r\n中国画报出版社出版\r\n译者: 林东泰\r\nISBN编号: 9787514601312\r\n2011年08月',10,'2020-11-25 15:57:39'),(20,'static/goods_img/20.jpg',4,'二手小新2018air15',1,3000,3,'i5 8代处理器 预装win10 与macos11',123,'2020-12-05 23:11:55'),(21,'static/goods_img/21.jpg',4,'二手小新2018air15',1,3000,3,'二手小新2018air15',123,'2020-12-05 23:13:24'),(22,'static/goods_img/22.jpg',6,'保温杯',1,30,4,'是原来SM-KB48的升级版。瓶身体积小，便于携带，可单手饮水。采用304真空不锈钢材质内胆，68摄氏度以上保温6小时，9摄氏度以下保冷6小时。内胆防沾涂层、可拆卸中栓，便于清洗。One-Touch一键开合方便饮用，并且带LOCK锁定按钮，防止意外开启。结露抑制技术能在温差大的情况下，减少瓶身外盖结露。规格480ml容量。',1025,'2020-12-05 23:22:05'),(23,'static/goods_img/23.jpg',1,'二手小新2018air15',1,3000,4,'预装win10 与macos 11.1 系统 完美黑苹果',123,'2020-12-05 23:22:59'),(24,'static/goods_img/24.jpg',3,'夹克衫',1,100,4,'帅气的冬季夹克，保温不失风度',1030,'2020-12-07 16:19:01'),(25,'static/goods_img/25.jpg',3,'夹克衫',1,1000,4,'test',1030,'2020-12-07 16:19:47'),(26,'static/goods_img/26.jpg',4,'平板电脑',1,2000,4,'平板电脑',123,'2020-12-08 00:08:42'),(29,'static/goods_img/29.jpg',1,'11',1,999,5,'好看的魅魔',999,'2026-06-19 11:19:38');
/*!40000 ALTER TABLE `goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message`
--

DROP TABLE IF EXISTS `message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `message` (
  `mess_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '消息id',
  `mess_from_id` int(11) NOT NULL COMMENT '消息接收者',
  `mess_to_id` int(11) NOT NULL COMMENT '消息发布者',
  `mess_text` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '消息内容',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=未读 1=已读',
  `mess_type` int(11) DEFAULT NULL COMMENT '消息类型',
  PRIMARY KEY (`mess_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message`
--

LOCK TABLES `message` WRITE;
/*!40000 ALTER TABLE `message` DISABLE KEYS */;
INSERT INTO `message` VALUES (49,1,10,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=17\'>畅学STM32开发学习板，配套stm32f103c8t6最小系统核心板</a>已经审核通过','2020-12-05 23:01:31',1,NULL),(50,1,10,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=18\'>地球往事系列小说 ，三体1+三体2黑暗森林+三体3死神永生</a>已经审核通过','2020-12-05 23:01:31',1,NULL),(51,1,10,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=19\'>《1984》(精装珍藏本) 奥威尔著  世界名著小说</a>已经审核通过','2020-12-05 23:01:32',1,NULL),(52,123,1017,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=2\'>被套</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=2236188843@qq.com ==> 王华强&userId=123\'>王华强</a>，以下为买家的附加信息（可能为空）\n==============\n你好 价格比较合适 期望与您联系','2020-12-05 23:02:22',1,NULL),(53,1017,123,'好的  欢迎与您取得联系 我的电话156xxxxx','2020-12-05 23:06:25',1,NULL),(55,1,123,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=20\'>二手小新2018air15</a>审核未通过','2020-12-05 23:21:53',1,NULL),(56,1,123,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=21\'>二手小新2018air15</a>审核未通过','2020-12-05 23:21:58',1,NULL),(57,1,1025,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=22\'>保温杯</a>已经审核通过','2020-12-05 23:23:30',1,NULL),(58,1,123,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=23\'>二手小新2018air15</a>已经审核通过','2020-12-05 23:23:33',1,NULL),(59,1025,123,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=23\'>二手小新2018air15</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=123456@qq.com%20==>%20陈章月&userId=1025\'>陈章月</a>，以下为买家的附加信息（可能为空）\n==============\n2500 不能再多了\r\n','2020-12-05 23:36:44',1,NULL),(60,123,1025,'两个系统噢  macos','2020-12-05 23:37:50',1,NULL),(61,1025,123,'不行 顶多再加50','2020-12-05 23:38:26',1,NULL),(62,123,1025,' 不行不行   原件5000快','2020-12-05 23:38:51',1,NULL),(63,1025,123,'不要了','2020-12-05 23:40:45',1,NULL),(64,1022,123,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=4\'>网球拍</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=luna_nov@163.com%20==>%20luna&userId=1022\'>luna</a>，以下为买家的附加信息（可能为空）\n==============\n你好，  很喜欢你的商品 请与我联系','2020-12-07 09:22:05',1,NULL),(65,1026,1025,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=22\'>保温杯</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=223618@qq.com%20==>%20陆全有&userId=1026\'>陆全有</a>，以下为买家的附加信息（可能为空）\n==============\n此物品通过购物车批量购买','2020-12-07 15:20:04',1,NULL),(66,1026,10,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=1\'>笔记本</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=223618@qq.com%20==>%20陆全有&userId=1026\'>陆全有</a>，以下为买家的附加信息（可能为空）\n==============\n此物品通过购物车批量购买','2020-12-07 15:20:04',1,NULL),(67,1017,123,'感谢您光顾我的商品','2020-12-07 23:54:11',1,NULL),(68,1,123,'你的商品 <a target=\'_blank\' href=\'goods/info.jsp?goodsid=26\'>平板电脑</a>已经审核通过','2020-12-08 08:48:19',1,NULL),(69,1030,123,'你好','2020-12-08 08:52:40',1,NULL),(70,1031,123,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=26\'>平板电脑</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=865616281@qq.com%20==>%20小华&userId=1031\'>小华</a>，以下为买家的附加信息（可能为空）\n==============\n你好 很喜欢','2020-12-08 09:42:12',1,NULL),(71,123,1025,'你的商品<a target=\'_blank\' href=\'goods/info.jsp?goodsid=22\'>保温杯</a>被购买，请尽快联系买家<a target=\'_blank\' href=\'user/personal.jsp?tab=mess&handle=write&toemail=2236188843@qq.com%20==>%20王华强&userId=123\'>王华强</a>，以下为买家的附加信息（可能为空）\n==============\n此物品通过购物车批量购买','2020-12-08 09:42:46',1,NULL),(72,1032,999,'【购买通知】用户 xinghong 购买了你的商品「11」，请及时确认交易。','2026-06-19 11:21:25',1,NULL),(73,1032,999,'【购买通知】用户 xinghong 购买了你的商品「角色卡」，请及时确认交易。','2026-06-19 11:29:07',1,NULL),(74,1032,999,'【购买通知】用户 xinghong 购买了你的商品「角色卡」，请及时确认交易。','2026-06-19 11:31:38',1,NULL),(75,999,1032,'【购买通知】用户 管理员 购买了你的商品「2222」，请及时确认交易。','2026-06-19 14:04:34',1,NULL),(76,1032,999,'你好','2026-06-19 14:42:18',1,NULL),(77,999,1032,'1515','2026-06-19 15:00:40',1,NULL),(78,1032,123,'【购买通知】用户 xinghong 购买了你的商品「懒人桌」，请及时确认交易。','2026-06-19 15:01:12',0,NULL),(79,999,123,'【购买通知】用户 管理员 购买了你的商品「凉席」，请及时确认交易。','2026-06-19 15:42:19',0,NULL),(80,999,123,'【购买通知】用户 管理员 购买了你的商品「室内物品收纳架，多功能免钉可伸缩衣柜分层隔板」，请及时确认交易。','2026-06-19 15:49:20',0,NULL),(81,999,10,'【购买通知】用户 管理员 购买了你的商品「《c primer plus(第五版)中文版》C语言经典入门书籍」，请及时确认交易。','2026-06-19 15:57:53',0,NULL),(82,999,10,'【购买通知】用户 管理员 购买了你的商品「华为荣耀4x手机」，请及时确认交易。','2026-06-19 15:58:39',0,NULL),(83,1032,123,'【购买通知】用户 xinghong 购买了你的商品「考研书」，请及时确认交易。','2026-06-19 16:12:41',0,NULL),(84,999,123,'【购买通知】用户 管理员 购买了你的商品「沃曼威斯韩版夜光双肩包大容量个性背包」，请及时确认交易。','2026-06-19 16:22:46',0,NULL);
/*!40000 ALTER TABLE `message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL COMMENT '订单物品编号',
  `user_id` int(11) NOT NULL COMMENT '购买用户',
  `date` datetime NOT NULL COMMENT '订单日期',
  `message` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '订单留言',
  `status` int(11) DEFAULT '0' COMMENT '0=进行中, 1=已完成, 2=已取消',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (8,4,1017,'2020-12-05 22:56:47','你好 真的很喜欢',0),(9,2,123,'2020-12-05 23:02:22','你好 价格比较合适 期望与您联系',0),(10,23,1025,'2020-12-05 23:36:44','2500 不能再多了\r\n',0),(11,4,1022,'2020-12-07 09:22:05','你好，  很喜欢你的商品 请与我联系',0),(12,22,1026,'2020-12-07 15:20:04','此物品通过购物车批量购买',0),(13,1,1026,'2020-12-07 15:20:04','此物品通过购物车批量购买',0),(14,26,1031,'2020-12-08 09:42:12','你好 很喜欢',0),(15,22,123,'2020-12-08 09:42:46','此物品通过购物车批量购买',0),(16,3,1032,'2026-06-15 13:01:40','hello',0),(17,3,999,'2026-06-18 14:01:33','',0),(19,25,999,'2026-06-18 14:51:35','',0),(20,24,999,'2026-06-18 14:51:48','',0),(22,3,999,'2026-06-19 10:19:35','',0),(23,5,999,'2026-06-19 10:21:16','',0),(24,29,1032,'2026-06-19 11:21:25','',0),(28,6,1032,'2026-06-19 15:01:12','',0),(29,8,999,'2026-06-19 15:08:32','通过购物车批量购买',0),(30,9,999,'2026-06-19 15:42:19',NULL,0),(31,10,999,'2026-06-19 15:42:27','通过购物车批量购买',0),(32,11,999,'2026-06-19 15:42:27','通过购物车批量购买',0);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessionkey`
--

DROP TABLE IF EXISTS `sessionkey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessionkey` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_key` varchar(127) CHARACTER SET utf8 NOT NULL,
  `user_id` int(20) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessionkey`
--

LOCK TABLES `sessionkey` WRITE;
/*!40000 ALTER TABLE `sessionkey` DISABLE KEYS */;
INSERT INTO `sessionkey` VALUES (3,'c64102dbe0be79b76d9113086591d5f5',0),(4,'7bec8fc80405741cb40f017fad543ddc',1022),(5,'531e178ba446ac20ad61783af55cdf28',1017),(6,'6b568b6071c605f3315d0291ef20ca19',1024),(7,'35de170fc7836ea645e1a7d7b307ff6e',1025),(8,'211af61ce87c84a71bca7c42a14b56b4',123),(9,'f34cdd5431da266bd0d5b6f73fc6ff7d',1026),(10,'7c21af47584655ea95ec6b377b86a399',0),(11,'7c21af47584655ea95ec6b377b86a399',0),(12,'7c21af47584655ea95ec6b377b86a399',0),(13,'7c21af47584655ea95ec6b377b86a399',0),(14,'7c21af47584655ea95ec6b377b86a399',0),(15,'7c21af47584655ea95ec6b377b86a399',0),(16,'3f6599934e57fe9cb443faf134bc5af4',0),(17,'3f6599934e57fe9cb443faf134bc5af4',0),(18,'3f6599934e57fe9cb443faf134bc5af4',0),(19,'3f6599934e57fe9cb443faf134bc5af4',0),(20,'3f6599934e57fe9cb443faf134bc5af4',0),(21,'3f6599934e57fe9cb443faf134bc5af4',0),(22,'3f6599934e57fe9cb443faf134bc5af4',0),(23,'3f6599934e57fe9cb443faf134bc5af4',0),(31,'3f6599934e57fe9cb443faf134bc5af4',999);
/*!40000 ALTER TABLE `sessionkey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart`
--

DROP TABLE IF EXISTS `shoppingcart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoppingcart` (
  `shop_id` int(11) NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`shop_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart`
--

LOCK TABLES `shoppingcart` WRITE;
/*!40000 ALTER TABLE `shoppingcart` DISABLE KEYS */;
INSERT INTO `shoppingcart` VALUES (38,3,1025),(39,4,1025),(40,9,1025),(42,1,1022),(46,26,1031),(62,9,1032),(63,10,1032),(64,11,1032),(73,13,999),(74,15,999);
/*!40000 ALTER TABLE `shoppingcart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_setting`
--

DROP TABLE IF EXISTS `system_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL COMMENT '设置键名',
  `setting_value` text COMMENT '设置值',
  `description` varchar(255) DEFAULT NULL COMMENT '设置说明',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='系统设置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_setting`
--

LOCK TABLES `system_setting` WRITE;
/*!40000 ALTER TABLE `system_setting` DISABLE KEYS */;
INSERT INTO `system_setting` VALUES (1,'site_name','校园咸鱼','站点名称'),(2,'site_description','校园二手交易平台，让闲置物品找到新主人','站点描述'),(3,'perpage_goods','12','商品每页显示数量'),(4,'maintenance_mode','0','维护模式：0关闭 1开启');
/*!40000 ALTER TABLE `system_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` char(255) COLLATE utf8_bin NOT NULL COMMENT '邮箱',
  `img` char(255) COLLATE utf8_bin DEFAULT NULL COMMENT '头像',
  `pwd` char(255) COLLATE utf8_bin NOT NULL COMMENT '密码',
  `name` char(255) COLLATE utf8_bin DEFAULT NULL COMMENT '昵称',
  `stu_num` char(255) COLLATE utf8_bin DEFAULT NULL COMMENT '学号',
  `qq` char(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'qq号',
  `phone` char(255) COLLATE utf8_bin DEFAULT NULL COMMENT '手机号',
  `mess_num` int(11) NOT NULL DEFAULT '0' COMMENT '消息数',
  `role` int(11) NOT NULL DEFAULT '0' COMMENT '角色: 0=普通用户, 1=管理员',
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1033 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'luna@saltfish.com','static/user_img/0.jpg','385895e41f65a63bdfb93b9d2048e69d','luna',NULL,NULL,NULL,0,1,'2026-06-19 11:07:10'),(2,'luna@saltfish.com','static/user_img/0.jpg','385895e41f65a63bdfb93b9d2048e69d','luna',NULL,NULL,NULL,0,1,'2026-06-19 11:07:10'),(9,'1173282254@qq.com','static/user_img/9.jpg','385895e41f65a63bdfb93b9d2048e69d','陈章月',NULL,NULL,'',0,1,'2026-06-19 11:07:10'),(10,'1159891180@qq.com','static/user_img/1.jpg','385895e41f65a63bdfb93b9d2048e69d','韩志强',NULL,NULL,'15256925578',7,1,'2026-06-19 11:07:10'),(123,'2236188843@qq.com','static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d','王华强',NULL,NULL,NULL,0,1,'2026-06-19 11:07:10'),(999,'admin@saltfish.com','static/user_img/0.jpg','0c909a141f1f2c0a1cb602b0b2d7d050','管理员','',' 15','',0,1,'2026-06-19 11:07:10'),(1017,'865616284@qq.com','static/user_img/1017.jpg','385895e41f65a63bdfb93b9d2048e69d','赵文军',NULL,NULL,'13245634567',0,0,'2026-06-19 11:07:10'),(1019,'864636142@qq.com','static/user_img/1019.jpg','385895e41f65a63bdfb93b9d2048e69d','罗杰',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1020,'121@qq.com','static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d',NULL,NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1021,'leilei@qq.com','static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d',NULL,NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1022,'luna_nov@163.com','static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d','luna',NULL,NULL,'15696756582',0,0,'2026-06-19 11:07:10'),(1023,'xiaoming@saltfish.com','static/user_img/1022.jpg','385895e41f65a63bdfb93b9d2048e69d','小明',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1024,'865616285@qq.com',NULL,'385895e41f65a63bdfb93b9d2048e69d','小红',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1025,'123456@qq.com',NULL,'14e1b600b1fd579f47433b88e8d85291','陈章月',NULL,NULL,NULL,2,0,'2026-06-19 11:07:10'),(1026,'223618@qq.com','static/user_img/0.jpg','e10adc3949ba59abbe56e057f20f883e','陆全有',NULL,NULL,'123456',0,0,'2026-06-19 11:07:10'),(1027,'89546@123.com',NULL,'14e1b600b1fd579f47433b88e8d85291','12',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1028,'8956@123.com',NULL,'14e1b600b1fd579f47433b88e8d85291','！@#￥',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1029,'822956@123.com','static/user_img/0.jpg','14e1b600b1fd579f47433b88e8d85291','陆全有',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1030,'2236188@qq.com',NULL,'14e1b600b1fd579f47433b88e8d85291','赵文',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1031,'865616281@qq.com','static/user_img/0.jpg','385895e41f65a63bdfb93b9d2048e69d','小华',NULL,NULL,NULL,0,0,'2026-06-19 11:07:10'),(1032,'3376219386@qq.com','static/user_img/1032.jpg','e70f9c34540f7e6c03550193b9fe5e13','xinghong','81818',' 4858','2151',0,0,'2026-06-19 11:07:10');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'salt-fish'
--

--
-- Dumping routines for database 'salt-fish'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-19 18:50:15
