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
    <title>商品管理 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp">
            <jsp:param name="active" value="${filter == 'pending' ? 'pending' : 'goods'}"/>
        </jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="package" class="icon-lg"></i> ${filter == 'pending' ? '待审核商品' : '商品管理'}</h1>
                <p>共 ${total} 件商品</p>
            </div>

            <!-- Toolbar -->
            <div class="admin-toolbar">
                <div class="admin-toolbar-left">
                    <div class="filter-pills">
                        <a class="filter-pill ${empty filter ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods">全部</a>
                        <a class="filter-pill ${filter == 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods?filter=pending">待审核 <span class="pill-count">${pendingCount}</span></a>
                        <a class="filter-pill ${filter == 'active' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods?filter=active">在售</a>
                        <a class="filter-pill ${filter == 'rejected' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods?filter=rejected">已拒绝</a>
                        <a class="filter-pill ${filter == 'trading' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods?filter=trading">交易中</a>
                        <a class="filter-pill ${filter == 'sold' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/goods?filter=sold">已售出</a>
                    </div>
                    <select onchange="Admin.filterByCategory(this.value)" style="margin-left:8px;padding:6px 10px;border:1px solid var(--border-color);border-radius:var(--border-radius);font-size:0.85rem;background:var(--bg-card)">
                        <option value="">全部分类</option>
                        <c:forEach var="cat" items="${categoryList}">
                            <option value="${cat.id}" ${category == cat.id ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="admin-toolbar-right">
                    <button class="btn btn-outline btn-sm" onclick="Admin.exportGoods()" title="导出CSV"><i data-lucide="download" class="icon-sm"></i> 导出</button>
                    <div class="admin-search">
                        <input type="text" id="goodsSearchInput" placeholder="搜索商品名称..." oninput="Admin.filterTable(this, 'goodsTable')">
                        <button><i data-lucide="search" class="icon-sm"></i></button>
                    </div>
                </div>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="goodsBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch" onclick="Admin.batchAuditGoods(2)"><i data-lucide="check-circle" class="icon-sm"></i> 批量通过</button>
                    <button class="btn-batch" onclick="Admin.batchAuditGoods(3)"><i data-lucide="x-circle" class="icon-sm"></i> 批量拒绝</button>
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteGoods()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <!-- Table -->
            <div class="table-container admin-table-container">
                <table class="table" id="goodsTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th>商品</th>
                            <th>价格</th>
                            <th>卖家</th>
                            <th>状态</th>
                            <th>发布时间</th>
                            <th style="width:160px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="goods" items="${goodsList}">
                            <c:set var="seller" value="${userMap[goods.producterId]}" />
                            <tr>
                                <td><input type="checkbox" class="batch-select" value="${goods.id}"></td>
                                <td>
                                    <div class="cell-goods">
                                        <img src="${goods.image}" alt="${goods.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/static/user_img/0.jpg'">
                                        <span class="goods-name"><c:out value="${goods.name}" /></span>
                                    </div>
                                </td>
                                <td style="font-weight:700;color:#ef4444;font-size:0.92rem">
                                    <fmt:formatNumber value="${goods.price}" type="number" minFractionDigits="2" maxFractionDigits="2" var="priceVal"/>
                                    ¥${priceVal}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty seller}"><span style="color:#94a3b8">已删除</span></c:when>
                                        <c:otherwise><c:out value="${seller.name}" /></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${goods.status == 1}"><span class="badge badge-warning"><i data-lucide="clock" style="width:12px;height:12px"></i> 待审核</span></c:when>
                                        <c:when test="${goods.status == 2}"><span class="badge badge-success"><i data-lucide="check-circle" style="width:12px;height:12px"></i> 在售</span></c:when>
                                        <c:when test="${goods.status == 3}"><span class="badge badge-danger"><i data-lucide="x-circle" style="width:12px;height:12px"></i> 已拒绝</span></c:when>
                                        <c:when test="${goods.status == 4}"><span class="badge badge-info"><i data-lucide="refresh-cw" style="width:12px;height:12px"></i> 交易中</span></c:when>
                                        <c:when test="${goods.status == 5}"><span class="badge badge-secondary"><i data-lucide="check" style="width:12px;height:12px"></i> 已售出</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary">未知</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:0.85rem"><fmt:formatDate value="${goods.createDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                <td>
                                    <div class="actions">
                                        <button class="btn btn-ghost btn-sm btn-icon" title="查看详情"
                                            onclick="Admin.showGoodsDetail(${goods.id}, '${goods.name}', ${goods.price}, '${empty seller ? '已删除' : seller.name}', '${goods.status}', '<fmt:formatDate value="${goods.createDate}" pattern="yyyy-MM-dd HH:mm"/>', '${goods.content}', '${goods.image}')">
                                            <i data-lucide="eye" class="icon-sm"></i>
                                        </button>
                                        <c:if test="${goods.status == 1}">
                                            <button class="btn btn-ghost btn-sm btn-icon" title="通过" onclick="Admin.auditing(${goods.id}, 2)" style="color:#10b981">
                                                <i data-lucide="check" class="icon-sm"></i>
                                            </button>
                                            <button class="btn btn-ghost btn-sm btn-icon" title="拒绝" onclick="Admin.auditing(${goods.id}, 3)" style="color:#f59e0b">
                                                <i data-lucide="x" class="icon-sm"></i>
                                            </button>
                                        </c:if>
                                        <button class="btn btn-ghost btn-sm btn-icon" title="删除" onclick="Admin.deleteGoods(${goods.id})" style="color:#ef4444">
                                            <i data-lucide="trash-2" class="icon-sm"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty goodsList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="package" style="width:48px;height:48px"></i></div>
                    <h3>${filter == 'pending' ? '没有待审核的商品' : '暂无商品'}</h3>
                    <p>${filter == 'pending' ? '所有商品都已审核完毕' : '还没有任何商品发布'}</p>
                </div>
            </c:if>

            <!-- Pagination -->
            <c:if test="${maxPage > 1}">
                <div class="pagination">
                    <c:if test="${pn > 1}">
                        <a class="page-btn" href="?pn=${pn - 1}${filter == 'pending' ? '&filter=pending' : ''}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${maxPage}" var="i">
                        <a class="page-btn ${i == pn ? 'active' : ''}" href="?pn=${i}${filter == 'pending' ? '&filter=pending' : ''}">${i}</a>
                    </c:forEach>
                    <c:if test="${pn < maxPage}">
                        <a class="page-btn" href="?pn=${pn + 1}${filter == 'pending' ? '&filter=pending' : ''}">下一页</a>
                    </c:if>
                </div>
            </c:if>
        </main>
    </div>

    <!-- Goods Detail Modal -->
    <div class="modal-backdrop" id="goodsModal">
        <div class="modal" style="max-width:540px">
            <div class="modal-header">
                <h3>商品详情</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <img id="gdImage" class="detail-image" src="" alt="">
                <div class="detail-row"><span class="detail-label">名称</span><span class="detail-value" id="gdName"></span></div>
                <div class="detail-row"><span class="detail-label">价格</span><span class="detail-value" id="gdPrice" style="color:#ef4444;font-weight:700"></span></div>
                <div class="detail-row"><span class="detail-label">卖家</span><span class="detail-value" id="gdSeller"></span></div>
                <div class="detail-row"><span class="detail-label">状态</span><span class="detail-value" id="gdStatus"></span></div>
                <div class="detail-row"><span class="detail-label">发布时间</span><span class="detail-value" id="gdTime"></span></div>
                <div class="detail-row"><span class="detail-label">描述</span><span class="detail-value" id="gdDesc" style="white-space:pre-wrap"></span></div>
            </div>
            <div class="modal-footer" id="gdActions"></div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=5" charset="UTF-8"></script>
    <script>Admin.initBatch("goodsTable","goodsBatchBar")</script>
</body>
</html>
