<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/admin.css?v=5">
    <title>订单管理 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="orders"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="receipt" class="icon-lg"></i> 订单管理</h1>
                <p>共 ${total} 笔订单</p>
            </div>

            <div class="admin-toolbar">
                <div class="admin-toolbar-left">
                    <div class="filter-pills">
                        <a class="filter-pill ${empty filter ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders">全部</a>
                        <a class="filter-pill ${filter == 'trading' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders?filter=trading">交易中 <span class="pill-count">${tradingCount}</span></a>
                        <a class="filter-pill ${filter == 'completed' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/orders?filter=completed">已完成 <span class="pill-count">${completedCount}</span></a>
                    </div>
                </div>
                <div class="admin-toolbar-right">
                    <button class="btn btn-outline btn-sm" onclick="Admin.exportOrders()"><i data-lucide="download" class="icon-sm"></i> 导出</button>
                </div>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="ordersBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch" onclick="Admin.batchCancelOrders()"><i data-lucide="x-circle" class="icon-sm"></i> 批量取消交易</button>
                    <button class="btn-batch" onclick="Admin.batchCompleteOrders()"><i data-lucide="check-circle" class="icon-sm"></i> 批量确认完成</button>
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteOrders()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <div class="table-container admin-table-container">
                <table class="table" id="ordersTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th>订单ID</th>
                            <th>商品</th>
                            <th>价格</th>
                            <th>买家</th>
                            <th>卖家</th>
                            <th>状态</th>
                            <th>下单时间</th>
                            <th style="width:120px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orderList}">
                            <c:set var="goods" value="${goodsMap[order.goodsId]}" />
                            <c:set var="buyer" value="${buyerMap[order.userId]}" />
                            <c:set var="seller" value="${sellerMap[goods.producterId]}" />
                            <tr>
                                <td><input type="checkbox" class="batch-select" value="${order.id}"></td>
                                <td style="color:#94a3b8;font-size:0.82rem">#${order.id}</td>
                                <td>
                                    <div class="cell-goods">
                                        <c:choose>
                                            <c:when test="${not empty goods}">
                                                <img src="${pageContext.request.contextPath}/${goods.image}" alt="${goods.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/static/user_img/0.jpg'">
                                                <span class="goods-name"><c:out value="${goods.name}" /></span>
                                            </c:when>
                                            <c:otherwise><span style="color:#94a3b8">已删除商品</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td style="font-weight:700;color:#ef4444;font-size:0.92rem">
                                    <c:if test="${not empty goods}">&yen;<fmt:formatNumber value="${goods.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></c:if>
                                </td>
                                <td><c:choose><c:when test="${not empty buyer}"><c:out value="${buyer.name}" /></c:when><c:otherwise>用户#${order.userId}</c:otherwise></c:choose></td>
                                <td><c:choose><c:when test="${not empty seller}"><c:out value="${seller.name}" /></c:when><c:otherwise>-</c:otherwise></c:choose></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty goods && goods.status == 4}"><span class="badge badge-info"><i data-lucide="refresh-cw" style="width:12px;height:12px"></i> 交易中</span></c:when>
                                        <c:when test="${not empty goods && goods.status == 5}"><span class="badge badge-success"><i data-lucide="check-circle" style="width:12px;height:12px"></i> 已完成</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:0.85rem"><fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd HH:mm" /></td>
                                <td>
                                    <div class="actions">
                                        <button class="btn btn-ghost btn-sm btn-icon" title="详情"
                                            onclick="Admin.showOrderDetail(${order.id}, '${not empty goods ? goods.name : "已删除"}', '${not empty goods ? goods.price : 0}', '${not empty buyer ? buyer.name : ""}', '${not empty seller ? seller.name : ""}', '${not empty goods ? goods.status : 0}', '<fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd HH:mm"/>', '${order.message}')">
                                            <i data-lucide="eye" class="icon-sm"></i>
                                        </button>
                                        <c:if test="${not empty goods && goods.status == 4}">
                                            <button class="btn btn-ghost btn-sm btn-icon" title="取消交易" onclick="Admin.cancelOrderAdmin(${order.goodsId})" style="color:#f59e0b">
                                                <i data-lucide="x-circle" class="icon-sm"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn btn-ghost btn-sm btn-icon" title="删除" onclick="Admin.deleteOrder(${order.id})" style="color:#ef4444">
                                            <i data-lucide="trash-2" class="icon-sm"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty orderList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="receipt" style="width:48px;height:48px"></i></div>
                    <h3>暂无订单</h3>
                    <p>还没有任何交易记录</p>
                </div>
            </c:if>

            <c:if test="${maxPage > 1}">
                <div class="pagination">
                    <c:if test="${pn > 1}"><a class="page-btn" href="?pn=${pn - 1}${not empty filter ? '&filter='.concat(filter) : ''}">&lsaquo;</a></c:if>
                    <c:forEach begin="1" end="${maxPage}" var="i">
                        <a class="page-btn ${i == pn ? 'active' : ''}" href="?pn=${i}${not empty filter ? '&filter='.concat(filter) : ''}">${i}</a>
                    </c:forEach>
                    <c:if test="${pn < maxPage}"><a class="page-btn" href="?pn=${pn + 1}${not empty filter ? '&filter='.concat(filter) : ''}">&rsaquo;</a></c:if>
                </div>
            </c:if>
        </main>
    </div>

    <div class="modal-backdrop" id="orderModal">
        <div class="modal" style="max-width:520px">
            <div class="modal-header">
                <h3>订单详情</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <div class="detail-row"><span class="detail-label">订单ID</span><span class="detail-value" id="odId"></span></div>
                <div class="detail-row"><span class="detail-label">商品</span><span class="detail-value" id="odGoods"></span></div>
                <div class="detail-row"><span class="detail-label">价格</span><span class="detail-value" id="odPrice" style="color:#ef4444;font-weight:700"></span></div>
                <div class="detail-row"><span class="detail-label">买家</span><span class="detail-value" id="odBuyer"></span></div>
                <div class="detail-row"><span class="detail-label">卖家</span><span class="detail-value" id="odSeller"></span></div>
                <div class="detail-row"><span class="detail-label">状态</span><span class="detail-value" id="odStatus"></span></div>
                <div class="detail-row"><span class="detail-label">下单时间</span><span class="detail-value" id="odTime"></span></div>
                <div class="detail-row"><span class="detail-label">留言</span><span class="detail-value" id="odMsg" style="white-space:pre-wrap"></span></div>
            </div>
            <div class="modal-footer"><button class="btn btn-ghost" data-dismiss="modal">关闭</button></div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=6" charset="UTF-8"></script>
    <script>Admin.initBatch("ordersTable","ordersBatchBar")</script>
</body>
</html>