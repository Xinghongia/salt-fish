<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>搜索: ${key} - 校园盐鱼</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="container" style="padding-top:var(--space-2xl);padding-bottom:var(--space-2xl)">
        <div style="margin-bottom:var(--space-xl)">
            <h1 style="font-size:1.75rem;margin-bottom:var(--space-xs);display:flex;align-items:center;gap:10px"><i data-lucide="search" class="icon-lg"></i> 搜索结果</h1>
            <p style="color:var(--text-secondary)">
                关键词 "<strong style="color:var(--primary)">${key}</strong>" 共找到 <strong>${total}</strong> 件商品
            </p>
        </div>

        <c:choose>
            <c:when test="${not empty goodsList}">
                <div class="grid grid-4">
                    <c:forEach var="goods" items="${goodsList}">
                        <c:if test="${not empty goods.producterId}">
                            <c:set var="user" value="${userMap[goods.producterId]}" />
                            <div class="product-card">
                                <a href="${pageContext.request.contextPath}/goods/info?goodsId=${goods.id}" style="text-decoration:none;color:inherit">
                                    <div class="product-image">
                                        <img src="${goods.image}" alt="${goods.name}" loading="lazy">
                                    </div>
                                    <div class="product-info">
                                        <div class="product-name"><c:out value="${goods.name}" /></div>
                                        <div class="product-price"><span class="price-symbol">¥</span>${goods.price}</div>
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
                <c:if test="${total > 0}">
                    <div class="pagination">
                        <a href="${pageContext.request.contextPath}/search?key=${fn:escapeXml(key)}&pn=${pn > 1 ? pn-1 : 1}"
                           class="page-btn ${pn <= 1 ? 'disabled' : ''}">‹</a>
                        <c:forEach begin="1" end="${maxPage}" var="i">
                            <a href="${pageContext.request.contextPath}/search?key=${fn:escapeXml(key)}&pn=${i}"
                               class="page-btn ${i == pn ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="${pageContext.request.contextPath}/search?key=${fn:escapeXml(key)}&pn=${pn < maxPage ? pn+1 : maxPage}"
                           class="page-btn ${pn >= maxPage ? 'disabled' : ''}">›</a>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="search-x" style="width:64px;height:64px;color:var(--text-light)"></i></div>
                    <h3>没有找到相关商品</h3>
                    <p>换个关键词试试吧</p>
                    <a href="${pageContext.request.contextPath}/index" class="btn btn-primary">浏览全部商品</a>
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
