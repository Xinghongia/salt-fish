<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>购买历史 - 校园盐鱼</title>

    <style>
        .sort-wrap{display:inline-flex;align-items:center;gap:6px;margin-left:auto}
        .sort-wrap label{font-size:0.82rem;color:var(--text-secondary);white-space:nowrap}
        .sort-wrap select{appearance:none!important;-webkit-appearance:none!important;-moz-appearance:none!important;padding:6px 30px 6px 12px;border:1px solid var(--border-color);border-radius:20px;background:var(--bg-card) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E") no-repeat right 10px center;font-size:0.82rem;color:var(--text-primary);cursor:pointer;transition:all 0.2s;outline:none}
        .sort-wrap select:hover{border-color:var(--primary)}
        .sort-wrap select:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-bg)}
    </style>

    <style>
        .history-item{display:flex;gap:var(--space-lg);background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-lg);margin-bottom:var(--space-md);box-shadow:var(--shadow-sm);border:1px solid var(--border-color)}
        .history-item .item-img{width:100px;height:100px;border-radius:var(--border-radius);object-fit:cover;flex-shrink:0}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="history"/>
    </jsp:include>

    <div style="display:flex;align-items:center;margin-bottom:var(--space-xl)">
        <div>
            <h1 style="font-size:1.4rem;display:flex;align-items:center;gap:8px"><i data-lucide="file-text" class="icon-lg"></i> 购买历史</h1>
            <p style="color:var(--text-secondary);font-size:0.85rem;margin-top:2px">共 ${total} 条记录</p>
        </div>
                <div class="sort-wrap">
            <label>排序</label>
            <select onchange="location.href=this.value">
                <option value="${pageContext.request.contextPath}/order?pn=${pn}&sort=date_desc" ${sort == 'date_desc' ? 'selected' : ''}>时间最新</option>
                <option value="${pageContext.request.contextPath}/order?pn=${pn}&sort=date_asc" ${sort == 'date_asc' ? 'selected' : ''}>时间最早</option>
                <option value="${pageContext.request.contextPath}/order?pn=${pn}&sort=price_asc" ${sort == 'price_asc' ? 'selected' : ''}>价格低→高</option>
                <option value="${pageContext.request.contextPath}/order?pn=${pn}&sort=price_desc" ${sort == 'price_desc' ? 'selected' : ''}>价格高→低</option>
            </select>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty goodsList}">
            <c:forEach var="goods" items="${goodsList}">
                <div class="history-item">
                    <img class="item-img" src="${pageContext.request.contextPath}/${goods.image}" alt="${goods.name}">
                    <div style="flex:1">
                        <div style="font-size:1rem;font-weight:600;margin-bottom:var(--space-xs)">
                            <a href="${pageContext.request.contextPath}/goods/info?goodsId=${goods.id}" style="color:var(--text-primary);text-decoration:none"><c:out value="${goods.name}" /></a>
                        </div>
                        <div style="font-size:0.85rem;color:var(--text-secondary)">
                            <span style="color:var(--danger);font-weight:600">&yen;${goods.price}</span>
                            &middot; 卖家：<c:choose><c:when test="${not empty userMap[goods.producterId].name}"><c:out value="${userMap[goods.producterId].name}" /></c:when><c:otherwise><c:out value="${userMap[goods.producterId].email}" /></c:otherwise></c:choose>
                            &middot; <fmt:formatDate value="${goods.orderDate}" pattern="yyyy-MM-dd HH:mm" />
                        </div>
                    </div>
                    <div style="display:flex;align-items:center">
                        <c:choose>
                            <c:when test="${goods.status == 4}"><span class="badge badge-info"><i data-lucide="clock" class="icon-sm"></i> 交易中</span></c:when>
                            <c:when test="${goods.status == 5}"><span class="badge badge-success"><i data-lucide="check-circle" class="icon-sm"></i> 已完成</span></c:when>
                            <c:otherwise><span class="badge badge-secondary">已购买</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-state"><div class="empty-icon"><i data-lucide="file-text" style="width:56px;height:56px;color:var(--text-light)"></i></div><h3>还没有购买过商品</h3><a href="${pageContext.request.contextPath}/index" class="btn btn-primary">去逛逛</a></div>
        </c:otherwise>
    </c:choose>

    <div class="pagination" style="margin-top:var(--space-xl)">
        <a href="${pageContext.request.contextPath}/order?pn=${pn > 1 ? pn-1 : 1}&sort=${sort}" class="page-btn ${pn <= 1 ? 'disabled' : ''}">&#8249;</a>
        <c:forEach begin="1" end="${maxPage}" var="i">
            <a href="${pageContext.request.contextPath}/order?pn=${i}&sort=${sort}" class="page-btn ${i == pn ? 'active' : ''}">${i}</a>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/order?pn=${pn < maxPage ? pn+1 : maxPage}&sort=${sort}" class="page-btn ${pn >= maxPage ? 'disabled' : ''}">&#8250;</a>
    </div>

    </main></div>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>