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
    <title>用户反馈 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="feedback"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="message-square" class="icon-lg"></i> 用户反馈</h1>
                <p>共 ${total} 条反馈</p>
            </div>

            <!-- Toolbar -->
            <div class="admin-toolbar">
                <div class="admin-toolbar-left">
                    <div class="filter-pills">
                        <a class="filter-pill ${empty filter ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/feedback">全部</a>
                        <a class="filter-pill ${filter == 'bug' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/feedback?filter=bug">Bug</a>
                        <a class="filter-pill ${filter == 'feature' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/feedback?filter=feature">功能建议</a>
                        <a class="filter-pill ${filter == 'improve' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/feedback?filter=improve">改进建议</a>
                    </div>
                </div>
                <div class="admin-toolbar-right">
                    <div class="admin-search">
                        <input type="text" id="feedbackSearchInput" placeholder="搜索反馈内容..." oninput="Admin.filterTable(this, 'feedbackTable')">
                        <button><i data-lucide="search" class="icon-sm"></i></button>
                    </div>
                </div>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="fbBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteFeedback()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <!-- Table -->
            <div class="table-container admin-table-container">
                <table class="table" id="feedbackTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th>ID</th>
                            <th>用户</th>
                            <th>类型</th>
                            <th>内容</th>
                            <th>联系方式</th>
                            <th>提交时间</th>
                            <th style="width:60px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="fb" items="${feedbackList}">
                            <c:set var="user" value="${userMap[fb.userId]}" />
                            <tr>
                                <td><input type="checkbox" class="batch-select" value="${fb.id}"></td>
                                <td style="color:#94a3b8;font-size:0.82rem">#${fb.id}</td>
                                <td>
                                    <div class="cell-user">
                                        <c:choose>
                                            <c:when test="${not empty user}">
                                                <img src="${user.img}" alt="${user.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/static/user_img/0.jpg'">
                                                <span style="font-weight:500"><c:out value="${user.name}" /></span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#94a3b8">用户#${fb.userId}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fb.type == 'bug'}"><span class="badge badge-danger">Bug</span></c:when>
                                        <c:when test="${fb.type == 'feature'}"><span class="badge badge-primary">功能建议</span></c:when>
                                        <c:when test="${fb.type == 'improve'}"><span class="badge badge-info">改进建议</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary">其他</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="max-width:400px;font-size:0.88rem"><c:out value="${fb.content}" /></td>
                                <td style="font-size:0.85rem"><c:out value="${fb.contact}" /></td>
                                <td style="font-size:0.85rem"><fmt:formatDate value="${fb.createTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                                <td>
                                    <button class="btn btn-ghost btn-sm btn-icon" title="删除" onclick="Admin.deleteFeedback(${fb.id})" style="color:#ef4444">
                                        <i data-lucide="trash-2" class="icon-sm"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty feedbackList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="message-square" style="width:48px;height:48px"></i></div>
                    <h3>暂无反馈</h3>
                    <p>用户提交的反馈会在这里显示</p>
                </div>
            </c:if>

            <!-- Pagination -->
            <c:if test="${maxPage > 1}">
                <div class="pagination">
                    <c:if test="${pn > 1}">
                        <a class="page-btn" href="?pn=${pn - 1}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${maxPage}" var="i">
                        <a class="page-btn ${i == pn ? 'active' : ''}" href="?pn=${i}">${i}</a>
                    </c:forEach>
                    <c:if test="${pn < maxPage}">
                        <a class="page-btn" href="?pn=${pn + 1}">下一页</a>
                    </c:if>
                </div>
            </c:if>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=5" charset="UTF-8"></script>
    <script>Admin.initBatch("feedbackTable","fbBatchBar")</script>
</body>
</html>
