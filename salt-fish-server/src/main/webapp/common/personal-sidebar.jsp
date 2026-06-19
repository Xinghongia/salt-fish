<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="personal-layout">
    <aside class="personal-sidebar">
        <div class="sidebar-profile">
            <img src="${pageContext.request.contextPath}/${viewUser.img}" class="avatar avatar-lg" style="border:3px solid rgba(255,255,255,0.3)" alt="">
            <div class="profile-name">
                <c:choose>
                    <c:when test="${not empty viewUser.name}"><c:out value="${viewUser.name}" /></c:when>
                    <c:otherwise>未设置昵称</c:otherwise>
                </c:choose>
            </div>
            <div class="profile-email"><c:out value="${viewUser.email}" /></div>
        </div>
        <nav class="sidebar-nav">
            <c:choose>
                <c:when test="${isMe}">
                    <a href="${pageContext.request.contextPath}/personal/info" class="${param.activeTab == 'info' ? 'active' : ''}"><i data-lucide="user" class="icon-sm"></i> 个人信息</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/personal/info?userId=${viewUser.id}" class="${param.activeTab == 'info' ? 'active' : ''}"><i data-lucide="user" class="icon-sm"></i> 个人信息</a>
                </c:otherwise>
            </c:choose>
            <c:if test="${isMe}">
                <div class="nav-divider"></div>
                <a href="${pageContext.request.contextPath}/push" class="${param.activeTab == 'push' ? 'active' : ''}"><i data-lucide="plus-circle" class="icon-sm"></i> 发布商品</a>
                <a href="${pageContext.request.contextPath}/pushed?userId=${viewUser.id}" class="${param.activeTab == 'pushed' ? 'active' : ''}"><i data-lucide="clipboard-list" class="icon-sm"></i> 我的发布</a>
                <a href="${pageContext.request.contextPath}/shopcart" class="${param.activeTab == 'shopcart' ? 'active' : ''}"><i data-lucide="shopping-cart" class="icon-sm"></i> 购物车</a>
                <a href="${pageContext.request.contextPath}/order" class="${param.activeTab == 'history' ? 'active' : ''}"><i data-lucide="file-text" class="icon-sm"></i> 购买历史</a>
                <a href="${pageContext.request.contextPath}/collect/check?userId=${viewUser.id}" class="${param.activeTab == 'like' ? 'active' : ''}"><i data-lucide="star" class="icon-sm"></i> 收藏夹</a>
                <a href="${pageContext.request.contextPath}/personal/mess" class="${param.activeTab == 'mess' ? 'active' : ''}"><i data-lucide="message-circle" class="icon-sm"></i> 站内消息</a>
                <c:if test="${isAdmin}">
                    <div class="nav-divider"></div>
                    <a href="${pageContext.request.contextPath}/auditing" class="${param.activeTab == 'auditing' ? 'active' : ''}" style="color:var(--primary)"><i data-lucide="check-circle" class="icon-sm"></i> 物品审核</a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" style="color:var(--primary)"><i data-lucide="shield" class="icon-sm"></i> 管理控制台</a>
                </c:if>
            </c:if>
            <c:if test="${not isMe}">
                <a href="${pageContext.request.contextPath}/pushed?userId=${viewUser.id}" class="${param.activeTab == 'pushed' ? 'active' : ''}"><i data-lucide="package" class="icon-sm"></i> TA的商品</a>
            </c:if>
        </nav>
    </aside>
    <main class="personal-content">
