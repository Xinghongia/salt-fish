<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>审核商品 - 校园盐鱼</title>
    <style>
        .goods-card{display:flex;gap:var(--space-lg);background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-lg);margin-bottom:var(--space-md);box-shadow:var(--shadow-sm);transition:all var(--transition-normal);border:1px solid var(--border-color)}
        .goods-card:hover{box-shadow:var(--shadow-md);border-color:transparent}
        .goods-card .card-img{width:100px;height:100px;border-radius:var(--border-radius);object-fit:cover;flex-shrink:0}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="auditing"/>
    </jsp:include>

    <h1 style="font-size:1.4rem;margin-bottom:var(--space-xl);display:flex;align-items:center;gap:8px"><i data-lucide="check-circle" class="icon-lg"></i> 审核商品</h1>

    <c:choose>
        <c:when test="${empty goodsList}">
            <div class="empty-state"><div class="empty-icon"><i data-lucide="check-circle" style="width:56px;height:56px;color:var(--text-light)"></i></div><h3>没有待审核的商品</h3></div>
        </c:when>
        <c:otherwise>
            <c:forEach var="goods" items="${goodsList}">
                <div class="goods-card" id="goods-card-${goods.id}">
                    <img class="card-img" src="${goods.image}" alt="${goods.name}">
                    <div style="flex:1">
                        <div style="font-size:1.05rem;font-weight:600;margin-bottom:var(--space-xs)">
                            <a href="${pageContext.request.contextPath}/goods/info?goodsId=${goods.id}" target="_blank" style="color:var(--text-primary);text-decoration:none"><c:out value="${goods.name}" /></a>
                        </div>
                        <div style="font-size:0.82rem;color:var(--text-secondary);margin-bottom:var(--space-sm)">
                            <span style="color:var(--danger);font-weight:600">¥${goods.price}</span>
                            · 卖家：<c:choose><c:when test="${not empty userMap[goods.producterId].name}"><c:out value="${userMap[goods.producterId].name}" /></c:when><c:otherwise><c:out value="${userMap[goods.producterId].email}" /></c:otherwise></c:choose>
                            · <fmt:formatDate value="${goods.createDate}" pattern="yyyy-MM-dd HH:mm" />
                        </div>
                        <div style="font-size:0.88rem;color:var(--text-secondary);margin-bottom:var(--space-md)"><c:out value="${goods.content}" /></div>
                        <div id="actions-${goods.id}" style="display:flex;gap:var(--space-sm)">
                            <button class="btn btn-success btn-sm" onclick="auditing(${goods.id}, 2)"><i data-lucide="check" class="icon-sm"></i> 通过</button>
                            <button class="btn btn-danger btn-sm" onclick="auditing(${goods.id}, 3)"><i data-lucide="x" class="icon-sm"></i> 拒绝</button>
                            <a href="${pageContext.request.contextPath}/goods/info?goodsId=${goods.id}" target="_blank" class="btn btn-ghost btn-sm"><i data-lucide="external-link" class="icon-sm"></i> 详情</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    </main></div>
    <script>
        function auditing(goodsId, pass) {
            SaltFish.ajax('api/auditing?goodsId=' + goodsId + '&pass=' + pass, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        var el = document.getElementById('actions-' + goodsId);
                        el.innerHTML = pass === 2 ? '<span class="badge badge-success" style="font-size:0.88rem;padding:8px 16px"><i data-lucide="check" class="icon-sm"></i> 已通过</span>' : '<span class="badge badge-danger" style="font-size:0.88rem;padding:8px 16px"><i data-lucide="x" class="icon-sm"></i> 已拒绝</span>';
                        if (typeof lucide !== 'undefined') lucide.createIcons();
                        SaltFish.showToast('success', '操作成功');
                    } else { SaltFish.showToast('error', '操作失败'); }
                }
            });
        }
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
