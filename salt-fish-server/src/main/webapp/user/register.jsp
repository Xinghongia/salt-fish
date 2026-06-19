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
    <title>注册 - 校园盐鱼</title>
</head>
<body class="auth-page">
    <div class="auth-card">
        <div class="auth-header">
            <div class="logo"><i data-lucide="fish" style="width:40px;height:40px;color:var(--primary)"></i></div>
            <h2>加入校园盐鱼</h2>
            <p>创建账号，开始交易之旅</p>
        </div>

        <c:if test="${not empty isEmail}">
            <div class="alert alert-danger"><i data-lucide="alert-circle" class="icon"></i><div>${isEmail}</div></div>
        </c:if>
        <c:if test="${not empty isPwd}">
            <div class="alert alert-danger"><i data-lucide="alert-circle" class="icon"></i><div>${isPwd}</div></div>
        </c:if>
        <c:if test="${not empty isPwdSame}">
            <div class="alert alert-danger"><i data-lucide="alert-circle" class="icon"></i><div>${isPwdSame}</div></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label class="form-label"><i data-lucide="at-sign" class="icon-sm"></i> 邮箱地址</label>
                <input type="email" name="input_email" class="form-control" placeholder="请输入邮箱" required>
                <div class="form-hint">用于登录和找回密码</div>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="user" class="icon-sm"></i> 昵称</label>
                <input type="text" name="name" class="form-control" placeholder="给自己起个名字吧">
                <div class="form-hint">留空将显示为"某用户"</div>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="lock" class="icon-sm"></i> 密码</label>
                <input type="password" name="input_password1" class="form-control" placeholder="至少6位字母或数字" required>
                <div class="form-hint">密码至少6位，仅限字母、数字和下划线</div>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="lock" class="icon-sm"></i> 确认密码</label>
                <input type="password" name="input_password2" class="form-control" placeholder="再次输入密码" required>
            </div>
            <div class="mb-3">
                <label style="display:flex;align-items:flex-start;gap:var(--space-sm);cursor:pointer;font-size:0.85rem;color:var(--text-secondary)">
                    <input type="checkbox" required style="width:16px;height:16px;accent-color:var(--primary);margin-top:2px">
                    我已阅读并同意 <a href="${pageContext.request.contextPath}/user/agreement.jsp">用户协议</a> 和 <a href="#">隐私政策</a>
                </label>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">注 册</button>
        </form>

        <div class="auth-footer">
            已有账号？<a href="${pageContext.request.contextPath}/user/login.jsp">立即登录</a>
        </div>
    </div>
</body>
</html>
