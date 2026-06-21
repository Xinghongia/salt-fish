package com.luna.saltfish;

import org.apache.catalina.startup.Tomcat;

import java.io.File;

public class SaltFish {

    private static String detectDocBase() {
        // 1. 系统属性（start.py 或宝塔 JVM 参数传入）
        String prop = System.getProperty("webapp.dir");
        if (prop != null && new File(prop).exists()) return prop;

        // 2. JAR 同级目录下的 webapp 文件夹（宝塔部署用）
        String jarDir = new File(SaltFish.class.getProtectionDomain()
                .getCodeSource().getLocation().getPath()).getParent();
        File jarWebapp = new File(jarDir, "webapp");
        if (jarWebapp.exists()) return jarWebapp.getAbsolutePath();

        // 3. IDEA 开发环境
        File root = new File("salt-fish-server/src/main/webapp");
        if (root.exists()) return root.getAbsolutePath();
        File server = new File("src/main/webapp");
        if (server.exists()) return server.getAbsolutePath();

        return new File("webapp").getAbsolutePath();
    }

    private static final String CONTEXT_PATH = "/salt-fish";

    public static void start() {
        Tomcat tomcat = new Tomcat();
        tomcat.setSilent(false);
        try {
            // 端口：系统属性 > 默认 8080
            int port = 8080;
            String portProp = System.getProperty("server.port");
            if (portProp != null) {
                try { port = Integer.parseInt(portProp); } catch (Exception ignored) {}
            }
            tomcat.setPort(port);

            // baseDir 使用 webapp 所在目录的上一级
            File webappDir = new File(detectDocBase());
            File baseDir = webappDir.getParentFile();
            if (baseDir == null) baseDir = new File(".");
            tomcat.setBaseDir(baseDir.getAbsolutePath());

            tomcat.getConnector().setURIEncoding("UTF-8");
            tomcat.addWebapp(CONTEXT_PATH, webappDir.getAbsolutePath());
            tomcat.start();
            System.out.println("启动成功: http://localhost:" + port + CONTEXT_PATH + "/");
            tomcat.getServer().await();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SaltFish.start();
    }
}
