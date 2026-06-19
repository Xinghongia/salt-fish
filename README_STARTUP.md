# 校园咸鱼 - 启动教程

## 环境要求

| 依赖 | 版本 | 说明 |
|------|------|------|
| JDK | **8**（1.8） | 必须是 JDK 8，高版本不兼容 |
| Maven | 3.x | 用于编译和管理依赖 |
| MySQL | 5.7+ | 存储数据 |
| Python | 3.6+ | 运行启动脚本（仅启动用，项目本身是 Java） |

## 1. 安装 JDK 8

1. 下载 JDK 8：https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html
   - Windows 选 `Windows x64` 的 `.exe` 安装包
2. 安装时记住安装路径，例如 `C:\Program Files\Java\jdk1.8.0_202`
3. 配置环境变量：
   - 右键此电脑 → 属性 → 高级系统设置 → 环境变量
   - **系统变量**中新建：
     - 变量名：`JAVA_HOME`
     - 变量值：`C:\Program Files\Java\jdk1.8.0_202`（你的实际安装路径）
   - 编辑 `Path`，添加：`%JAVA_HOME%\bin`
4. 验证：打开终端输入 `java -version`，显示 `1.8.x_xxx` 即成功

## 2. 安装 Maven

1. 下载：https://maven.apache.org/download.cgi （选 `Binary zip archive`）
2. 解压到任意目录，例如 `C:\apache-maven-3.9.6`
3. 配置环境变量：
   - 系统变量新建 `MAVEN_HOME`，值为解压路径
   - `Path` 中添加 `%MAVEN_HOME%\bin`
4. 验证：终端输入 `mvn -version`

## 3. 初始化数据库

1. 确保 MySQL 服务已启动
2. 创建数据库：
   ```sql
   CREATE DATABASE `salt-fish` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
   ```
3. 导入初始化数据：
   ```bash
   mysql -u root -p salt-fish < sql/init.sql
   ```
4. （可选）修改数据库连接信息，编辑 `salt-fish-server/src/main/resources/` 下的配置文件

## 4. 启动项目

```bash
cd salt-fish
python start.py
```

启动脚本会显示菜单：

```
========================================
   Salt-Fish 启动器
========================================
  1. 直接启动
  2. 编译 + 启动
  3. 杀旧进程 + 启动
  4. 杀旧进程 + 编译 + 启动
  0. 退出
========================================
```

- **首次运行**选 `2`（编译 + 启动），之后选 `1` 即可
- 如果修改了 Java 代码，需要重新编译（选 `2` 或 `4`）
- 修改 JSP/CSS/JS 不需要重新编译，刷新浏览器即可

启动成功后浏览器会自动打开 `http://localhost:8080/salt-fish/`

## 5. 测试账号

| 账号 | 密码 | 角色 |
|------|------|------|
| admin@saltfish.com | admin888 | 管理员 |
| 123456@qq.com | 123456 | 普通用户 |
| 2236188843@qq.com | 123456 | 普通用户 |

## 常见问题

**Q: 提示"未找到 JDK 8"**
确认 `JAVA_HOME` 环境变量已设置，且指向 JDK 8 的安装目录（不是 bin 目录）。

**Q: Maven 编译失败**
检查 `mvn -version` 是否正常。如果网络慢，可以配置阿里云镜像，在 `~/.m2/settings.xml` 中添加：
```xml
<mirrors>
  <mirror>
    <id>aliyun</id>
    <mirrorOf>central</mirrorOf>
    <url>https://maven.aliyun.com/repository/public</url>
  </mirror>
</mirrors>
```

**Q: 端口 8080 被占用**
启动脚本会自动检测并提示杀掉占用进程。也可以手动修改 `start.py` 中的 `PORT` 值。

**Q: 数据库连接失败**
检查 MySQL 是否启动，以及数据库配置文件中的用户名、密码、数据库名是否正确。
