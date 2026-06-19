<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/lucide@0.344.0/dist/umd/lucide.min.js"></script>
    <script src="${pageContext.request.contextPath}/src/js/common.js" charset="UTF-8"></script>
    <title>登录 - 校园盐鱼</title>
</head>
<body class="auth-page">
    <div class="auth-card">
        <div class="auth-header">
            <div class="logo"><i data-lucide="fish" style="width:40px;height:40px;color:var(--primary)"></i></div>
            <h2>欢迎回来</h2>
            <p>登录你的校园盐鱼账号</p>
        </div>

        <c:if test="${isLoginOk == 'false'}">
            <div class="alert alert-danger">
                <i data-lucide="alert-circle" class="icon"></i>
                <div>邮箱或密码错误，请重试</div>
            </div>
        </c:if>

        <c:if test="${isRegister == true}">
            <div class="alert alert-success">
                <i data-lucide="check-circle" class="icon"></i>
                <div>注册成功！请登录</div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label class="form-label"><i data-lucide="at-sign" class="icon-sm"></i> 邮箱地址</label>
                <input type="email" name="inputEmail" class="form-control" placeholder="请输入邮箱" required autofocus>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="lock" class="icon-sm"></i> 密码</label>
                <input type="password" name="inputPassword" class="form-control" placeholder="请输入密码" required>
            </div>
            <div class="flex justify-between items-center mb-3">
                <label style="display:flex;align-items:center;gap:var(--space-sm);cursor:pointer;font-size:0.88rem;color:var(--text-secondary)">
                    <input type="checkbox" name="auto_login" value="on" style="width:16px;height:16px;accent-color:var(--primary)">
                    7天内自动登录
                </label>
                <a href="#" style="font-size:0.88rem">忘记密码？</a>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">登 录</button>
        </form>

        <div class="auth-footer">
            还没有账号？<a href="${pageContext.request.contextPath}/user/register.jsp">立即注册</a>
        </div>
    </div>
</body>
</html>
