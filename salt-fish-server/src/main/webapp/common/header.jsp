<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .badge-count{display:inline-flex;align-items:center;justify-content:center;min-width:18px;height:18px;padding:0 5px;border-radius:9px;font-size:0.68rem;font-weight:700;background:#ef4444;color:#fff;line-height:1}
    .badge-dot{position:absolute;top:-2px;right:-2px;width:10px;height:10px;border-radius:50%;background:#ef4444;border:2px solid var(--bg-card,#fff);animation:badge-pulse 2s ease-in-out infinite}
    @keyframes badge-pulse{0%,100%{box-shadow:0 0 0 0 rgba(239,68,68,0.5)}50%{box-shadow:0 0 0 6px rgba(239,68,68,0)}}
    .nav-link{position:relative}
    .nav-link .badge-count,.nav-link .badge-dot{transition:transform 0.2s ease}
    .nav-link:hover .badge-count{transform:scale(1.15)}
</style>
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index">
            <i data-lucide="fish" style="width:28px;height:28px;color:var(--primary)"></i>
            <span>校园盐鱼</span>
        </a>
        <div class="navbar-search">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <div class="input-group">
                    <input type="text" name="key" class="form-control" placeholder="搜索你想要的宝贝..." value="${key}">
                    <button type="submit" class="btn"><i data-lucide="search" class="icon"></i></button>
                </div>
            </form>
        </div>
        <div class="navbar-user">
            <ul class="navbar-nav">
                <li><a class="nav-link" href="${pageContext.request.contextPath}/index"><i data-lucide="home" class="icon-sm"></i> 首页</a></li>
                <c:if test="${isLogin}">
                    <li><a class="nav-link" href="${pageContext.request.contextPath}/shopcart"><i data-lucide="shopping-cart" class="icon-sm"></i> 购物车 <span class="badge-count cart-badge" ${cartNum > 0 ? '' : 'style="display:none"'}>${cartNum}</span></a></li>
                    <li><a class="nav-link" href="${pageContext.request.contextPath}/personal/mess" id="messLink"><i data-lucide="message-circle" class="icon-sm"></i> 消息 <span class="badge-count mess-badge" ${messNum > 0 ? '' : 'style="display:none"'}>${messNum}</span></a></li>
                </c:if>
            </ul>
            <c:choose>
                <c:when test="${isLogin}">
                    <div class="user-dropdown">
                        <button class="user-toggle">
                            <img src="${pageContext.request.contextPath}/${loginUser.img}" class="avatar avatar-sm" alt="">
                            <span class="user-name">${loginUser.name}</span>
                            <i data-lucide="chevron-down" class="icon-sm"></i>
                        </button>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/personal/info"><i data-lucide="user" class="icon-sm"></i> 个人中心</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/push"><i data-lucide="plus-circle" class="icon-sm"></i> 发布商品</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/pushed?userId=${loginUser.id}"><i data-lucide="clipboard-list" class="icon-sm"></i> 我的发布</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/shopcart"><i data-lucide="shopping-cart" class="icon-sm"></i> 购物车</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/order"><i data-lucide="file-text" class="icon-sm"></i> 我的订单</a>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/collect/check?userId=${loginUser.id}"><i data-lucide="star" class="icon-sm"></i> 我的收藏</a>
                            <c:if test="${isAdmin}">
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard" style="color:var(--primary)"><i data-lucide="shield" class="icon-sm"></i> 管理控制台</a>
                            </c:if>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/exit" style="color:var(--danger)"><i data-lucide="log-out" class="icon-sm"></i> 退出登录</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/user/login.jsp" class="btn btn-outline btn-sm">登录</a>
                    <a href="${pageContext.request.contextPath}/user/register.jsp" class="btn btn-primary btn-sm">注册</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
<c:if test="${isLogin}">
<script>
(function() {
    var ctx = document.querySelector('meta[name="ctx"]');
    var basePath = ctx ? ctx.getAttribute('content') : '';
    var lastMessCount = parseInt('${messNum}') || 0;

    function updateBadge(selector, count) {
        var badges = document.querySelectorAll(selector);
        badges.forEach(function(b) {
            if (count > 0) {
                b.textContent = count;
                b.style.display = 'inline-flex';
            } else {
                b.style.display = 'none';
            }
        });
    }

    function checkNotifications() {
        // \u6d88\u606f
        var xhr1 = new XMLHttpRequest();
        xhr1.open('GET', basePath + 'api/messnum', true);
        xhr1.onreadystatechange = function() {
            if (xhr1.readyState === 4 && xhr1.status === 200) {
                var count = parseInt(xhr1.responseText) || 0;
                updateBadge('.mess-badge', count);
                if (count > lastMessCount) {
                    SaltFish.showToast('info', '\u4f60\u6709 ' + count + ' \u6761\u672a\u8bfb\u6d88\u606f');
                }
                lastMessCount = count;
            }
        };
        xhr1.send();

        // \u8d2d\u7269\u8f66
        var xhr2 = new XMLHttpRequest();
        xhr2.open('GET', basePath + 'api/cartnum', true);
        xhr2.onreadystatechange = function() {
            if (xhr2.readyState === 4 && xhr2.status === 200) {
                var count = parseInt(xhr2.responseText) || 0;
                updateBadge('.cart-badge', count);
            }
        };
        xhr2.send();
    }

    // DOM\u52a0\u8f7d\u5b8c\u6210\u540e\u7acb\u5373\u6267\u884c\u4e00\u6b21\uff\ufeff\u7136\u540e\u6bcf10\u79d2\u8f6e\u8be2
    function startPolling() {
        checkNotifications();
        setInterval(checkNotifications, 10000);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', startPolling);
    } else {
        startPolling();
    }
})();
</script>
</c:if>
