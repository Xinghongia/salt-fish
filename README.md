# 🐟 校园盐鱼

校园二手交易平台，基于 JSP + Servlet + MySQL 构建，支持商品发布、购物车、收藏、站内消息、管理员后台等功能。

## 技术栈

- **后端：** JSP + Servlet + Apache Tomcat 8（内嵌）
- **前端：** Bootstrap 3 + 原生 JavaScript
- **数据库：** MySQL 5.7 + C3P0 连接池
- **工具库：** Apache Commons DbUtils、Hutool
- **构建：** Maven 3 + JDK 8

## 功能特性

### 用户端

- 注册 / 登录 / 个人中心
- 商品浏览、搜索、分类筛选
- 购物车、收藏、下单
- 站内消息、交易留言
- 用户反馈

### 管理端

- 仪表盘数据统计
- 商品审核（通过 / 拒绝）
- 用户管理、角色设置
- 订单管理、交易取消
- 分类管理、公告管理
- 操作日志

## 快速启动

### 环境要求

| 依赖   | 版本                    |
| ------ | ----------------------- |
| JDK    | **8**（1.8）            |
| Maven  | 3.x                     |
| MySQL  | 5.7+                    |
| Python | 3.6+（仅用于启动脚本）  |

### 1. 初始化数据库

```sql
CREATE DATABASE `salt-fish` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
```

```bash
mysql -u root -p salt-fish < sql/init.sql
```

### 2. 修改数据库配置

编辑 `salt-fish-server/src/main/resources/c3p0.properties`，修改数据库连接地址、用户名和密码。

### 3. 启动

```bash
cd salt-fish
python start.py
```

首次运行选 `2`（编译 + 启动），之后选 `1` 即可。启动后自动打开 <http://localhost:8080/salt-fish/>

## 测试账号

| 邮箱                 | 密码    | 角色     |
| -------------------- | ------- | -------- |
| admin@saltfish.com   | admin888| 管理员   |
| 123456@qq.com        | 123456  | 普通用户 |

## 项目结构

```text
salt-fish/
├── salt-fish-server/
│   ├── src/main/java/com/luna/saltfish/
│   │   ├── api/            # AJAX 接口（Servlet）
│   │   ├── controller/     # 页面控制器
│   │   ├── dao/            # 数据访问层
│   │   ├── entity/         # 实体类
│   │   ├── filter/         # 过滤器（登录、编码、公共数据）
│   │   ├── service/        # 业务逻辑
│   │   └── util/           # 工具类
│   ├── src/main/webapp/    # Web 资源
│   │   ├── admin/          # 管理后台 JSP
│   │   ├── common/         # 公共片段（header、sidebar）
│   │   ├── src/css/        # 样式
│   │   ├── src/js/         # 脚本
│   │   └── static/         # 图片资源
│   └── pom.xml
├── sql/
│   └── init.sql            # 数据库初始化脚本
└── start.py                # 一键启动脚本
```

## License

MIT
