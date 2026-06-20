"""
Salt-Fish 启动脚本

用法:
    python start.py              # 交互菜单，选择启动模式
    python start.py --build      # 编译 + 启动（兼容旧参数）
    python start.py --restart    # 杀掉旧进程 + 启动
"""

import subprocess
import sys
import os
import time
import webbrowser
import atexit

# ============ 配置 ============
PORT = 8080
URL = f"http://localhost:{PORT}/salt-fish/"

# ============ Java 检测 ============
def detect_java():
    """检测 JDK 8 路径：先看 JAVA_HOME 是否为 8，否则扫描常见目录"""
    # 1. 检查 JAVA_HOME 是否已经是 JDK 8
    jh = os.environ.get("JAVA_HOME", "")
    if jh and os.path.isfile(os.path.join(jh, "bin", "java.exe")):
        try:
            out = subprocess.check_output(
                [os.path.join(jh, "bin", "java.exe"), "-version"],
                stderr=subprocess.STDOUT, text=True
            )
            if "1.8" in out:
                return jh
        except Exception:
            pass
    # 2. 扫描常见 JDK 8 安装目录
    candidates = [
        r"F:\Java\jdk8",
        r"C:\Java\jdk8",
        r"C:\Program Files\Java\jdk1.8.0_202",
        r"C:\Program Files\Java\jdk1.8.0_361",
        r"C:\Program Files\Java\jdk-8",
        r"C:\Program Files (x86)\Java\jdk1.8.0_202",
    ]
    for c in candidates:
        if os.path.isfile(os.path.join(c, "bin", "java.exe")):
            return c
    return None

JAVA_HOME = detect_java()

# ============ 路径 ============
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
SERVER_DIR = os.path.join(PROJECT_DIR, "salt-fish-server")
if JAVA_HOME:
    os.environ["JAVA_HOME"] = JAVA_HOME
java = os.path.join(JAVA_HOME or "", "bin", "java.exe")


def run(cmd, cwd=PROJECT_DIR):
    """执行命令，失败则退出"""
    print(f">>> {cmd}")
    r = subprocess.run(cmd, shell=True, cwd=cwd)
    if r.returncode != 0:
        print(f"失败: {cmd}")
        sys.exit(1)


def build():
    """Maven 编译打包 + 复制依赖"""
    print("\n[1/2] 编译打包...")
    run("mvn clean package -q")
    print("[2/2] 复制依赖...")
    run("mvn dependency:copy-dependencies -q", cwd=SERVER_DIR)


def kill():
    """杀掉占用 PORT 端口的进程"""
    r = subprocess.run("netstat -ano", shell=True, capture_output=True, text=True)
    for line in r.stdout.splitlines():
        if f":{PORT} " in line and "LISTENING" in line:
            pid = line.strip().split()[-1]
            print(f"杀掉进程 {pid}")
            os.system(f"taskkill /F /PID {pid}")


def start():
    """启动内嵌 Tomcat"""
    print(f"\n启动中... {URL}")
    print("Ctrl+C 停止\n")

    # 用绝对路径拼 classpath，避免工作目录问题
    cp = (
        os.path.join(SERVER_DIR, "target", "classes")
        + ";"
        + os.path.join(SERVER_DIR, "target", "dependency", "*")
    )
    webapp = os.path.join(SERVER_DIR, "src", "main", "webapp")

    # 后台启动 Java 进程，通过系统属性传入 webapp 绝对路径，抑制无用日志
    logging_props = os.path.join(SERVER_DIR, "target", "classes", "logging.properties")
    proc = subprocess.Popen([
        java,
        f"-Dwebapp.dir={webapp}",
        f"-Djava.util.logging.config.file={logging_props}",
        "-cp", cp,
        "com.luna.saltfish.SaltFish",
    ])

    # 脚本退出时自动杀掉 Java 进程（关终端、Ctrl+C 都会触发）
    atexit.register(lambda: proc.terminate())

    # 等几秒让 Tomcat 起来，然后打开浏览器
    time.sleep(2)
    webbrowser.open(URL)

    # 阻塞等待进程结束
    proc.wait()


def show_menu():
    """显示交互菜单"""
    print("=" * 40)
    print("   Salt-Fish 启动器")
    print("=" * 40)
    print("  1. 直接启动")
    print("  2. 编译 + 启动")
    print("  3. 杀旧进程 + 启动")
    print("  4. 杀旧进程 + 编译 + 启动")
    print("  0. 退出")
    print("=" * 40)


def check_env():
    """检查运行环境"""
    if not JAVA_HOME:
        print("错误: 未找到 JDK 8")
        print("  请将 JDK 8 安装到 F:\\Java\\jdk8 或 C:\\Program Files\\Java\\jdk1.8.0_xxx")
        print("  下载: https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html")
        sys.exit(1)
    if not os.path.isfile(os.path.join(SERVER_DIR, "pom.xml")):
        print("错误: 未找到 salt-fish-server/pom.xml，请在 salt-fish 项目根目录下运行此脚本")
        sys.exit(1)


if __name__ == "__main__":
    check_env()
    # 支持命令行参数（兼容旧用法）
    if len(sys.argv) > 1:
        need_build = "--build" in sys.argv or not os.path.exists(
            os.path.join(SERVER_DIR, "target", "classes")
        )
        if "--restart" in sys.argv or "--build" in sys.argv:
            kill()
        if need_build:
            build()
        if "--restart" in sys.argv or "--build" in sys.argv:
            time.sleep(1)
        start()
        sys.exit(0)

    # 交互菜单
    show_menu()
    choice = input("请选择: ").strip()

    if choice == "0":
        sys.exit(0)

    if choice not in ("1", "2", "3", "4"):
        print("无效选择")
        sys.exit(1)

    if choice in ("3", "4"):
        kill()
        time.sleep(1)

    if choice in ("2", "4"):
        build()
    elif choice == "1" and not os.path.exists(
        os.path.join(SERVER_DIR, "target", "classes")
    ):
        print("未找到编译产物，自动编译...")
        build()

    start()
