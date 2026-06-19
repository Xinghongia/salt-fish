<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<footer class="site-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col-brand">
                <div class="footer-brand"><i data-lucide="fish" class="icon-lg"></i> 校园盐鱼</div>
                <p class="footer-desc">校园二手交易平台，让闲置物品焕发新生。<br>安全交易，诚信为本。</p>
                <div class="footer-stats">
                    <span><i data-lucide="users" class="icon-sm"></i> 活跃用户</span>
                    <span><i data-lucide="package" class="icon-sm"></i> 在售商品</span>
                    <span><i data-lucide="check-circle" class="icon-sm"></i> 成功交易</span>
                </div>
            </div>
            <div>
                <div class="footer-title">快速导航</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/index"><i data-lucide="home" class="icon-sm"></i> 首页</a></li>
                    <c:forEach var="cat" items="${categoryList}" begin="0" end="3">
                        <li><a href="${pageContext.request.contextPath}/index?ceta=${cat.id}"><i data-lucide="${cat.icon}" class="icon-sm"></i> ${cat.name}</a></li>
                    </c:forEach>
                </ul>
            </div>
            <div>
                <div class="footer-title">用户服务</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/push"><i data-lucide="plus-circle" class="icon-sm"></i> 发布商品</a></li>
                    <li><a href="${pageContext.request.contextPath}/shopcart"><i data-lucide="shopping-cart" class="icon-sm"></i> 我的购物车</a></li>
                    <li><a href="${pageContext.request.contextPath}/order"><i data-lucide="file-text" class="icon-sm"></i> 我的订单</a></li>
                    <li><a href="${pageContext.request.contextPath}/personal/info"><i data-lucide="user" class="icon-sm"></i> 个人中心</a></li>
                </ul>
            </div>
            <div>
                <div class="footer-title">帮助与支持</div>
                <ul class="footer-links">
                    <li><a href="#"><i data-lucide="help-circle" class="icon-sm"></i> 帮助中心</a></li>
                    <li><a href="${pageContext.request.contextPath}/feedback"><i data-lucide="message-square" class="icon-sm"></i> 意见反馈</a></li>
                    <li><a href="#"><i data-lucide="shield" class="icon-sm"></i> 隐私政策</a></li>
                    <li><a href="#"><i data-lucide="file-text" class="icon-sm"></i> 使用协议</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 校园盐鱼 &middot; 校园二手交易平台 &middot; 让闲置焕发新生</p>
        </div>
    </div>
</footer>