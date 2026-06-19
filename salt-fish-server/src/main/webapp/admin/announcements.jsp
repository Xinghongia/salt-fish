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
    <title>公告管理 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="announcements"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="megaphone" class="icon-lg"></i> 系统公告</h1>
                <p>管理平台公告信息</p>
            </div>

            <!-- Create form -->
            <div class="ann-form-card">
                <h3><i data-lucide="plus-circle" class="icon"></i> 发布新公告</h3>
                <form id="annCreateForm" onsubmit="event.preventDefault(); Admin.createAnnouncement(this)">
                    <div class="form-group">
                        <label class="form-label">公告标题</label>
                        <input type="text" class="form-control" name="title" placeholder="输入公告标题" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">公告内容</label>
                        <textarea class="form-control" name="content" rows="3" placeholder="输入公告内容..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary"><i data-lucide="send" class="icon-sm"></i> 发布公告</button>
                </form>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="annBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch" onclick="Admin.batchToggleAnnouncements(true)"><i data-lucide="eye" class="icon-sm"></i> 批量显示</button>
                    <button class="btn-batch" onclick="Admin.batchToggleAnnouncements(false)"><i data-lucide="eye-off" class="icon-sm"></i> 批量隐藏</button>
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteAnnouncements()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <!-- Table -->
            <div class="table-container admin-table-container">
                <table class="table" id="annTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th>标题</th>
                            <th>内容</th>
                            <th>状态</th>
                            <th>发布时间</th>
                            <th style="width:150px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ann" items="${announcementList}">
                            <tr data-ann-id="${ann.id}" data-title="<c:out value='${ann.title}'/>" data-content="<c:out value='${ann.content}'/>">
                                <td><input type="checkbox" class="batch-select" value="${ann.id}"></td>
                                <td style="font-weight:600"><c:out value="${ann.title}" /></td>
                                <td style="max-width:300px" class="truncate"><c:out value="${ann.content}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ann.isActive}"><span class="badge badge-success"><i data-lucide="eye" style="width:12px;height:12px"></i> 显示中</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary"><i data-lucide="eye-off" style="width:12px;height:12px"></i> 已隐藏</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:0.85rem"><fmt:formatDate value="${ann.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                                <td>
                                    <div class="actions">
                                        <button class="btn btn-ghost btn-sm btn-icon" title="编辑" onclick="Admin.editAnnouncement(${ann.id})">
                                            <i data-lucide="pencil" class="icon-sm"></i>
                                        </button>
                                        <c:choose>
                                            <c:when test="${ann.isActive}">
                                                <button class="btn btn-ghost btn-sm btn-icon" title="隐藏" onclick="Admin.toggleAnnouncement(${ann.id}, false)" style="color:#f59e0b">
                                                    <i data-lucide="eye-off" class="icon-sm"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-ghost btn-sm btn-icon" title="显示" onclick="Admin.toggleAnnouncement(${ann.id}, true)" style="color:#10b981">
                                                    <i data-lucide="eye" class="icon-sm"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        <button class="btn btn-ghost btn-sm btn-icon" title="删除" onclick="Admin.deleteAnnouncement(${ann.id})" style="color:#ef4444">
                                            <i data-lucide="trash-2" class="icon-sm"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty announcementList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="megaphone" style="width:48px;height:48px"></i></div>
                    <h3>暂无公告</h3>
                    <p>发布第一条公告吧</p>
                </div>
            </c:if>
        </main>
    </div>

    <!-- Edit Announcement Modal -->
    <div class="modal-backdrop" id="editAnnModal">
        <div class="modal" style="max-width:540px">
            <div class="modal-header">
                <h3>编辑公告</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editAnnId">
                <div class="form-group">
                    <label class="form-label">公告标题</label>
                    <input type="text" class="form-control" id="editAnnTitle" required>
                </div>
                <div class="form-group">
                    <label class="form-label">公告内容</label>
                    <textarea class="form-control" id="editAnnContent" rows="4" required></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-ghost" data-dismiss="modal">取消</button>
                <button class="btn btn-primary" onclick="Admin.saveEditAnnouncement()"><i data-lucide="check" class="icon-sm"></i> 保存</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=5" charset="UTF-8"></script>
    <script>Admin.initBatch("annTable","annBatchBar")</script>
</body>
</html>
