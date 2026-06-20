<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/admin.css?v=5">
    <title>分类管理 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="categories"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="grid-3x3" class="icon-lg"></i> 分类管理</h1>
                <p>管理商品分类，支持增删改查、排序和启用禁用</p>
            </div>

            <div class="ann-form-card">
                <h3><i data-lucide="plus-circle" class="icon"></i> 添加新分类</h3>
                <form id="catCreateForm" onsubmit="event.preventDefault(); Admin.createCategory(this)">
                    <div style="display:grid;grid-template-columns:1fr 1fr 120px auto;gap:var(--space-md);align-items:end">
                        <div class="form-group" style="margin-bottom:0">
                            <label class="form-label">分类名称</label>
                            <input type="text" class="form-control" name="name" placeholder="如：数码配件" required>
                        </div>
                        <div class="form-group" style="margin-bottom:0">
                            <label class="form-label">图标名（lucide）</label>
                            <input type="text" class="form-control" name="icon" placeholder="如：cpu" value="tag">
                        </div>
                        <div class="form-group" style="margin-bottom:0">
                            <label class="form-label">排序</label>
                            <input type="number" class="form-control" name="sortOrder" placeholder="自动" min="0">
                        </div>
                        <button type="submit" class="btn btn-primary" style="height:38px"><i data-lucide="plus" class="icon-sm"></i> 添加</button>
                    </div>
                </form>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="catBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch" onclick="Admin.batchToggleCategories(true)"><i data-lucide="eye" class="icon-sm"></i> 批量启用</button>
                    <button class="btn-batch" onclick="Admin.batchToggleCategories(false)"><i data-lucide="eye-off" class="icon-sm"></i> 批量禁用</button>
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteCategories()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <div class="table-container admin-table-container">
                <table class="table" id="catTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th style="width:60px">ID</th>
                            <th>图标</th>
                            <th>分类名称</th>
                            <th style="width:80px">排序</th>
                            <th style="width:100px">状态</th>
                            <th style="width:150px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categoryList}">
                            <tr data-cat-id="${cat.id}" data-name="<c:out value='${cat.name}'/>" data-icon="${cat.icon}" data-sort="${cat.sortOrder}">
                                <td><input type="checkbox" class="batch-select" value="${cat.id}"></td>
                                <td style="font-weight:600;color:var(--text-secondary)">#${cat.id}</td>
                                <td><i data-lucide="${cat.icon}" class="icon-sm" style="color:var(--primary)"></i> <code style="font-size:0.78rem;color:var(--text-light)">${cat.icon}</code></td>
                                <td style="font-weight:600"><c:out value="${cat.name}" /></td>
                                <td style="font-size:0.85rem">${cat.sortOrder}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cat.isActive}"><span class="badge badge-success"><i data-lucide="eye" style="width:12px;height:12px"></i> 启用</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary"><i data-lucide="eye-off" style="width:12px;height:12px"></i> 禁用</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="actions">
                                        <button class="btn btn-ghost btn-sm btn-icon" title="编辑" onclick="Admin.editCategory(${cat.id})">
                                            <i data-lucide="pencil" class="icon-sm"></i>
                                        </button>
                                        <c:choose>
                                            <c:when test="${cat.isActive}">
                                                <button class="btn btn-ghost btn-sm btn-icon" title="禁用" onclick="Admin.toggleCategory(${cat.id}, false)" style="color:#f59e0b">
                                                    <i data-lucide="eye-off" class="icon-sm"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-ghost btn-sm btn-icon" title="启用" onclick="Admin.toggleCategory(${cat.id}, true)" style="color:#10b981">
                                                    <i data-lucide="eye" class="icon-sm"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        <button class="btn btn-ghost btn-sm btn-icon" title="删除" onclick="Admin.deleteCategory(${cat.id})" style="color:#ef4444">
                                            <i data-lucide="trash-2" class="icon-sm"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty categoryList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="grid-3x3" style="width:48px;height:48px"></i></div>
                    <h3>暂无分类</h3>
                    <p>添加第一个商品分类吧</p>
                </div>
            </c:if>
        </main>
    </div>

    <!-- Edit Category Modal -->
    <div class="modal-backdrop" id="editCatModal">
        <div class="modal" style="max-width:480px">
            <div class="modal-header">
                <h3>编辑分类</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editCatId">
                <div class="form-group">
                    <label class="form-label">分类名称</label>
                    <input type="text" class="form-control" id="editCatName" required>
                </div>
                <div class="form-group">
                    <label class="form-label">图标名（lucide）</label>
                    <input type="text" class="form-control" id="editCatIcon" placeholder="tag">
                </div>
                <div class="form-group">
                    <label class="form-label">排序（数字越小越靠前）</label>
                    <input type="number" class="form-control" id="editCatSort" min="0">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-ghost" data-dismiss="modal">取消</button>
                <button class="btn btn-primary" onclick="Admin.saveEditCategory()"><i data-lucide="check" class="icon-sm"></i> 保存</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=6" charset="UTF-8"></script>
    <script>Admin.initBatch("catTable","catBatchBar")</script>
</body>
</html>