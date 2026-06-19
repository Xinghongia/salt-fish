package com.luna.saltfish;

import org.apache.catalina.startup.Tomcat;

import java.io.File;

/**
 * @className SaltFish.java
 * @author luna@mac
 * @description TODO
 * @createTime 2020年12月04日 09:20:00
 */
public class SaltFish {

    private static final int    DEFAULT_PORT = 80;

    private static String detectDocBase() {
        // 优先用系统属性传入的绝对路径（start.py 使用）
        String prop = System.getProperty("webapp.dir");
        if (prop != null && new File(prop).exists()) return prop;

        // IDEA 运行时 working dir 可能在项目根目录或 salt-fish-server 目录
        File root = new File("salt-fish-server/src/main/webapp");
        if (root.exists()) return root.getAbsolutePath();
        File server = new File("src/main/webapp");
        if (server.exists()) return server.getAbsolutePath();
        // fallback
        return new File("src/main/webapp").getAbsolutePath();
    }

    private static final String CONTEXT_PATH = "/salt-fish";

    /**
     * tomcat加入web工程
     *
     * host:缺省默认为localhost
     * contextPath:在浏览器中访问项目的根路径
     * 例：localhost:port/{contextPath}/xx
     * docBase：项目中webapp所在路径
     *
     */
    public static void start() {
        Tomcat tomcat = new Tomcat();
        tomcat.setSilent(false);
        try {
            // 固定 baseDir 到项目内部，避免在项目外创建 tomcat.8080
            // detectDocBase() = .../salt-fish/salt-fish-server/src/main/webapp
            // 上溯 4 级到 .../salt-fish/
            File webappDir = new File(detectDocBase());
            File projectRoot = webappDir.getParentFile().getParentFile().getParentFile().getParentFile();
            tomcat.setBaseDir(projectRoot.getAbsolutePath());

            // 设置连接器编码为UTF-8，防止静态文件中文乱码
            tomcat.getConnector().setURIEncoding("UTF-8");
            tomcat.addWebapp(CONTEXT_PATH, detectDocBase());
            tomcat.start();
            tomcat.getServer().await();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SaltFish.start();
    }

}
