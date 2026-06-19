<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>${isMe ? '我的发布' : 'TA的商品'} - 校园盐鱼</title>
    <style>
        .goods-grid{display:grid;grid-template-columns:repeat(auto-fill, minmax(220px, 1fr));gap:var(--space-lg)}
        .product-card .card-actions{padding:0 var(--space-md) var(--space-md);display:flex;gap:6px}
        .product-card .card-actions .btn{flex:1;font-size:0.78rem;padding:6px 0}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="pushed"/>
    </jsp:include>

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:var(--space-xl)">
        <div>
            <h1 style="font-size:1.4rem;margin-bottom:var(--space-xs);display:flex;align-items:center;gap:8px"><i data-lucide="${isMe ? 'clipboard-list' : 'package'}" class="icon-lg"></i> ${isMe ? '我的发布' : 'TA的商品'}</h1>
            <p style="color:var(--text-secondary);font-size:0.88rem">共 ${goodsList.size()} 件商品</p>
        </div>
        <c:if test="${isMe}"><a href="${pageContext.request.contextPath}/push" class="btn btn-primary btn-sm"><i data-lucide="plus" class="icon-sm"></i> 发布新商品</a></c:if>
    </div>

    <c:choose>
        <c:when test="${not empty goodsList}">
            <div class="goods-grid">
                <c:forEach var="goods" items="${goodsList}">
                    <div class="product-card">
                        <a href="${pageContext.request.contextPath}/goods/info?goodsId=${goods.id}" style="text-decoration:none;color:inherit">
                            <div class="product-image">
                                <img src="${goods.image}" alt="${goods.name}" loading="lazy">
                                <c:choose>
                                    <c:when test="${goods.status == 1}"><span class="product-badge" style="background:var(--warning)">审核中</span></c:when>
                                    <c:when test="${goods.status == 3}"><span class="product-badge" style="background:var(--danger)">未通过</span></c:when>
                                    <c:when test="${goods.status == 4}"><span class="product-badge" style="background:var(--info)">交易中</span></c:when>
                                    <c:when test="${goods.status == 5}"><span class="product-badge">已售</span></c:when>
                                </c:choose>
                            </div>
                            <div class="product-info">
                                <div class="product-name"><c:out value="${goods.name}" /></div>
                                <div class="product-price"><span class="price-symbol">&yen;</span>${goods.price}</div>
                                <div class="product-meta">
                                    <span><c:choose>
                                        <c:when test="${goods.status == 1}"><span class="badge badge-warning" style="font-size:0.7rem">审核中</span></c:when>
                                        <c:when test="${goods.status == 2}"><span class="badge badge-success" style="font-size:0.7rem">在售</span></c:when>
                                        <c:when test="${goods.status == 3}"><span class="badge badge-danger" style="font-size:0.7rem">未通过</span></c:when>
                                        <c:when test="${goods.status == 4}"><span class="badge badge-info" style="font-size:0.7rem">交易中</span></c:when>
                                        <c:when test="${goods.status == 5}"><span class="badge badge-secondary" style="font-size:0.7rem">已售出</span></c:when>
                                    </c:choose></span>
                                    <span><fmt:formatDate value="${goods.createDate}" pattern="MM-dd" /></span>
                                </div>
                            </div>
                        </a>
                        <!-- Seller action buttons for trading goods -->
                        <c:if test="${isMe && goods.status == 4}">
                            <div class="card-actions">
                                <button class="btn btn-success btn-sm" onclick="handleComplete(${goods.id})">确认完成</button>
                                <button class="btn btn-danger btn-sm" onclick="handleCancel(${goods.id})">取消交易</button>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state"><div class="empty-icon"><i data-lucide="package" style="width:56px;height:56px;color:var(--text-light)"></i></div><h3>${isMe ? '还没有发布过商品' : '暂无商品'}</h3>
                <c:if test="${isMe}"><a href="${pageContext.request.contextPath}/push" class="btn btn-primary">去发布</a></c:if>
            </div>
        </c:otherwise>
    </c:choose>

    <script>
        function handleComplete(goodsId) {
            if (!confirm('\u786e\u8ba4\u4ea4\u6613\u5df2\u5b8c\u6210\uff1f')) return;
            SaltFish.ajax('api/admin/action?action=completeOrder&goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u4ea4\u6613\u5df2\u5b8c\u6210\uff0c\u5546\u54c1\u5df2\u6807\u8bb0\u4e3a\u5df2\u552e\u51fa');
                        setTimeout(function() { location.reload(); }, 800);
                    } else {
                        SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                    }
                }
            });
        }
        function handleCancel(goodsId) {
            if (!confirm('\u786e\u5b9a\u53d6\u6d88\u4ea4\u6613\uff1f\u5546\u54c1\u5c06\u6062\u590d\u4e3a\u5728\u552e\u72b6\u6001\u3002')) return;
            SaltFish.ajax('api/admin/action?action=cancelOrder&goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u4ea4\u6613\u5df2\u53d6\u6d88');
                        setTimeout(function() { location.reload(); }, 800);
                    } else {
                        SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                    }
                }
            });
        }
    </script>

    </main></div>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>