<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty goodsList}">
    <c:redirect url="/index" />
</c:if>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <base href="${basePath}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>校园盐鱼 - 首页</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />

    <!-- Hero Section -->
    <div class="page-hero">
        <div class="container" style="position:relative;z-index:1">
            <h1 style="display:flex;align-items:center;justify-content:center;gap:12px"><i data-lucide="fish" style="width:40px;height:40px"></i> 发现校园好物</h1>
            <p>在这里，每一件闲置都能找到新主人</p>
        </div>
    </div>

    <div class="container">

    <!-- Announcements -->
    <c:if test="${not empty announcements}">
        <div style="margin-bottom:var(--space-xl)">
            <c:forEach var="ann" items="${announcements}">
                <div class="alert alert-info" style="display:flex;align-items:center;gap:var(--space-md)">
                    <i data-lucide="megaphone" class="icon" style="flex-shrink:0"></i>
                    <div>
                        <strong><c:out value="${ann.title}" /></strong>
                        <div style="font-size:0.88rem;margin-top:2px"><c:out value="${ann.content}" /></div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- Category Navigation -->
        <div class="category-nav">
            <a href="${basePath}index?ceta=0" class="category-item ${ceta == 0 ? 'active' : ''}"><i data-lucide="tag" class="icon-sm"></i> 全部</a>
            <c:forEach var="cat" items="${categoryList}">
                <a href="${basePath}index?ceta=${cat.id}" class="category-item ${ceta == cat.id ? 'active' : ''}"><i data-lucide="${cat.icon}" class="icon-sm"></i> ${cat.name}</a>
            </c:forEach>
        </div>

        <!-- Results Info -->
        <div class="flex justify-between items-center mb-3" style="padding:var(--space-md) 0">
            <div style="color:var(--text-secondary);font-size:0.88rem">
                共找到 <strong style="color:var(--primary)">${total}</strong> 件商品
            </div>
        </div>

        <!-- Product Grid -->
        <c:choose>
            <c:when test="${not empty goodsList}">
                <div class="grid grid-4">
                    <c:forEach var="goods" items="${goodsList}">
                        <c:if test="${not empty goods.producterId}">
                            <c:set var="user" value="${userMap[goods.producterId]}" />
                            <div class="product-card">
                                <a href="${basePath}goods/info?goodsId=${goods.id}" style="text-decoration:none;color:inherit">
                                    <div class="product-image">
                                        <img src="${goods.image}" alt="${goods.name}" loading="lazy">
                                    </div>
                                    <div class="product-info">
                                        <div class="product-name"><c:out value="${goods.name}" /></div>
                                        <div class="product-price">
                                            <span class="price-symbol">¥</span>${goods.price}
                                        </div>
                                        <div class="product-meta">
                                            <div class="product-seller">
                                                <img src="${pageContext.request.contextPath}/${user.img}" alt="">
                                                <span>
                                                    <c:choose>
                                                        <c:when test="${not empty user.name}"><c:out value="${user.name}" /></c:when>
                                                        <c:otherwise>匿名用户</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <span><fmt:formatDate value="${goods.createDate}" pattern="MM-dd" /></span>
                                        </div>
                                    </div>
                                </a>
                                <div class="product-actions">
                                    <button class="btn-icon btn-sm btn-ghost" onclick="handleAddCart('${goods.id}', this)" title="加入购物车"><i data-lucide="shopping-bag" class="icon-sm"></i></button>
                                    <button class="btn-icon btn-sm btn-ghost" onclick="handleToggleCollect('${goods.id}', this)" title="收藏"><i data-lucide="heart" class="icon-sm"></i></button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${maxPage > 1}">
                    <div class="pagination">
                        <a href="${basePath}index?ceta=${ceta}&pn=${pn > 1 ? pn-1 : 1}"
                           class="page-btn ${pn <= 1 ? 'disabled' : ''}">‹</a>
                        <c:forEach begin="1" end="${maxPage}" var="i">
                            <a href="${basePath}index?ceta=${ceta}&pn=${i}"
                               class="page-btn ${i == pn ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="${basePath}index?ceta=${ceta}&pn=${pn < maxPage ? pn+1 : maxPage}"
                           class="page-btn ${pn >= maxPage ? 'disabled' : ''}">›</a>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="search" style="width:56px;height:56px;color:var(--text-light)"></i></div>
                    <h3>暂无商品</h3>
                    <p>该分类下暂时没有商品，换个分类看看吧</p>
                    <a href="${basePath}index?ceta=0" class="btn btn-primary">浏览全部商品</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        var _isLogin = ${isLogin ? 'true' : 'false'};
        function handleAddCart(goodsId, btn) {
            if (!_isLogin) { SaltFish.showToast('warning', '\u8bf7\u5148\u767b\u5f55'); setTimeout(function(){ location.href = '${pageContext.request.contextPath}/user/login.jsp'; }, 800); return; }
            SaltFish.addToCart(goodsId, btn);
        }
        function handleToggleCollect(goodsId, btn) {
            if (!_isLogin) { SaltFish.showToast('warning', '\u8bf7\u5148\u767b\u5f55'); setTimeout(function(){ location.href = '${pageContext.request.contextPath}/user/login.jsp'; }, 800); return; }
            SaltFish.toggleCollect(goodsId, btn);
        }
        // 初始化收藏状态
        if (_isLogin) {
            document.querySelectorAll('.product-actions button[title="\u6536\u85cf"]').forEach(function(btn) {
                var card = btn.closest('.product-card');
                if (!card) return;
                var link = card.querySelector('a[href*="goods/info"]');
                if (!link) return;
                var match = link.href.match(/goodsId=(\d+)/);
                if (!match) return;
                SaltFish.ajax('CheckCollectServlet?goodsId=' + match[1], {
                    callback: function(resp) {
                        if (resp && resp.indexOf('success') >= 0) {
                            btn.classList.add('collected');
                        }
                    }
                });
            });
        }
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
