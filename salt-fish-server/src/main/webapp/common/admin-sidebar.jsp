<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i data-lucide="shield-check" style="width:20px;height:20px"></i></div>
        <div class="brand-text">管理控制台</div>
    </div>

    <div class="sidebar-title">概览</div>
    <a class="sidebar-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
        <i data-lucide="bar-chart-3" class="icon-sm"></i> 数据统计
    </a>

    <div class="sidebar-title">内容管理</div>
    <a class="sidebar-link ${param.active == 'goods' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods">
        <i data-lucide="package" class="icon-sm"></i> 商品管理
    </a>
    <a class="sidebar-link ${param.active == 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods?filter=pending">
        <i data-lucide="clock" class="icon-sm"></i> 待审核商品
        <c:if test="${pendingGoods > 0}">
            <span class="link-badge">${pendingGoods}</span>
        </c:if>
    </a>
    <a class="sidebar-link ${param.active == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders">
        <i data-lucide="receipt" class="icon-sm"></i> 订单管理
    </a>
    <a class="sidebar-link ${param.active == 'announcements' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/announcements">
        <i data-lucide="megaphone" class="icon-sm"></i> 系统公告
    </a>
    <a class="sidebar-link ${param.active == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/categories">
        <i data-lucide="grid-3x3" class="icon-sm"></i> 分类管理
    </a>

    <div class="sidebar-title">用户管理</div>
    <a class="sidebar-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
        <i data-lucide="users" class="icon-sm"></i> 用户列表
    </a>
    <a class="sidebar-link ${param.active == 'feedback' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/feedback">
        <i data-lucide="message-square" class="icon-sm"></i> 用户反馈
    </a>

    <div class="sidebar-title">系统</div>
    <a class="sidebar-link ${param.active == 'logs' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/logs">
        <i data-lucide="scroll-text" class="icon-sm"></i> 操作日志
    </a>
    <a class="sidebar-link ${param.active == 'settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/settings">
        <i data-lucide="settings" class="icon-sm"></i> 系统设置
    </a>
    <a class="sidebar-link" href="${pageContext.request.contextPath}/index">
        <i data-lucide="home" class="icon-sm"></i> 返回前台
    </a>
</aside>
