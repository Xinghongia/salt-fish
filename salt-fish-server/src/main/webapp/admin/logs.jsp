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
    <title>操作日志 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="logs"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="scroll-text" class="icon-lg"></i> 操作日志</h1>
                <p>共 ${total} 条日志记录</p>
            </div>

            <!-- Toolbar -->
            <div class="admin-toolbar">
                <div class="admin-toolbar-left">
                    <div class="filter-pills">
                        <a class="filter-pill active" href="${pageContext.request.contextPath}/admin/logs">全部日志</a>
                    </div>
                </div>
                <div class="admin-toolbar-right">
                    <button class="btn btn-danger btn-sm" onclick="Admin.clearLogs()">
                        <i data-lucide="trash-2" class="icon-sm"></i> 清空日志
                    </button>
                </div>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="logsBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteLogs()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <!-- Table -->
            <div class="table-container admin-table-container">
                <table class="table" id="logsTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th>ID</th>
                            <th>管理员</th>
                            <th>操作</th>
                            <th>对象</th>
                            <th>详情</th>
                            <th>时间</th>
                            <th style="width:60px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${logList}">
                            <tr>
                                <td><input type="checkbox" class="batch-select" value="${log.id}"></td>
                                <td style="color:#94a3b8;font-size:0.82rem">#${log.id}</td>
                                <td style="font-weight:500"><c:out value="${log.adminName}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${log.action.contains('删除')}"><span class="log-action delete"><c:out value="${log.action}" /></span></c:when>
                                        <c:when test="${log.action.contains('添加') || log.action.contains('创建')}"><span class="log-action create"><c:out value="${log.action}" /></span></c:when>
                                        <c:when test="${log.action.contains('编辑') || log.action.contains('修改')}"><span class="log-action update"><c:out value="${log.action}" /></span></c:when>
                                        <c:otherwise><span class="log-action other"><c:out value="${log.action}" /></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:0.85rem"><c:out value="${log.target}" /></td>
                                <td style="font-size:0.85rem;max-width:300px" class="truncate"><c:out value="${log.detail}" /></td>
                                <td style="font-size:0.85rem"><fmt:formatDate value="${log.createTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                <td>
                                    <button class="btn btn-ghost btn-sm btn-icon" title="删除" onclick="Admin.deleteLog(${log.id})" style="color:#ef4444">
                                        <i data-lucide="trash-2" class="icon-sm"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty logList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="scroll-text" style="width:48px;height:48px"></i></div>
                    <h3>暂无操作日志</h3>
                    <p>管理员的操作记录会在这里显示</p>
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

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=6" charset="UTF-8"></script>
    <script>Admin.initBatch("logsTable","logsBatchBar")</script>
</body>
</html>
