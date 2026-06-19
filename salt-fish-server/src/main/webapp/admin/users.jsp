<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/admin.css?v=5">
    <title>用户管理 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="users" class="icon-lg"></i> 用户管理</h1>
                <p>共 ${total} 位注册用户</p>
            </div>

            <!-- Toolbar -->
            <div class="admin-toolbar">
                <div class="admin-toolbar-left">
                    <div class="filter-pills">
                        <a class="filter-pill ${empty keyword ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">全部用户</a>
                    </div>
                    <button class="btn btn-primary btn-sm" onclick="Admin.showAddUserModal()">
                        <i data-lucide="user-plus" class="icon-sm"></i> 添加用户
                    </button>
                </div>
                <div class="admin-toolbar-right">
                    <button class="btn btn-outline btn-sm" onclick="Admin.exportUsers()"><i data-lucide="download" class="icon-sm"></i> 导出</button>
                    <form action="${pageContext.request.contextPath}/admin/users" method="get" style="display:flex;gap:8px">
                        <div class="admin-search">
                            <input type="text" name="keyword" value="${keyword}" placeholder="搜索用户昵称/邮箱...">
                            <button type="submit"><i data-lucide="search" class="icon-sm"></i></button>
                        </div>
                        <c:if test="${not empty keyword}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost btn-sm">清除</a>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Batch Bar -->
            <div class="batch-bar" id="usersBatchBar">
                <span class="batch-info">已选 <span class="batch-count">0</span> 项</span>
                <div class="batch-actions">
                    <button class="btn-batch" onclick="Admin.batchSetRole(1)"><i data-lucide="shield" class="icon-sm"></i> 批量设为管理员</button>
                    <button class="btn-batch" onclick="Admin.batchSetRole(0)"><i data-lucide="user" class="icon-sm"></i> 批量设为普通用户</button>
                    <button class="btn-batch-danger" onclick="Admin.batchDeleteUsers()"><i data-lucide="trash-2" class="icon-sm"></i> 批量删除</button>
                </div>
            </div>

            <!-- Table -->
            <div class="table-container admin-table-container">
                <table class="table" id="usersTable">
                    <thead>
                        <tr>
                            <th style="width:40px"><input type="checkbox" class="batch-select-all"></th>
                            <th>ID</th>
                            <th>用户</th>
                            <th>邮箱</th>
                            <th>手机</th>
                            <th>学号</th>
                            <th>角色</th>
                            <th>消息</th>
                            <th style="width:140px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${userList}">
                            <tr>
                                <td><input type="checkbox" class="batch-select" value="${u.id}"></td>
                                <td style="color:var(--text-light);font-size:0.82rem">#${u.id}</td>
                                <td>
                                    <div class="cell-user">
                                        <img src="${u.img}" alt="${u.name}" onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/static/user_img/0.jpg'">
                                        <span style="font-weight:500"><c:out value="${u.name}" /></span>
                                    </div>
                                </td>
                                <td style="font-size:0.85rem"><c:out value="${u.email}" /></td>
                                <td style="font-size:0.85rem"><c:out value="${u.phone}" /></td>
                                <td style="font-size:0.85rem"><c:out value="${u.stuNum}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 1}"><span class="badge badge-primary"><i data-lucide="shield" style="width:12px;height:12px"></i> 管理员</span></c:when>
                                        <c:otherwise><span class="badge badge-secondary">普通用户</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${u.messnum}</td>
                                <td>
                                    <div class="actions">
                                        <button class="btn btn-ghost btn-sm btn-icon" title="查看详情"
                                            onclick="Admin.showUserDetail(${u.id}, '${u.name}', '${u.email}', '${u.phone}', '${u.stuNum}', '${u.img}', ${u.role}, ${u.messnum})">
                                            <i data-lucide="eye" class="icon-sm"></i>
                                        </button>
                                        <button class="btn btn-ghost btn-sm btn-icon" title="编辑"
                                            onclick="Admin.showEditUserModal(${u.id}, '${u.name}', '${u.phone}', '${u.stuNum}')">
                                            <i data-lucide="pencil" class="icon-sm"></i>
                                        </button>
                                        <c:if test="${u.role != 1}">
                                            <button class="btn btn-ghost btn-sm btn-icon" title="设为管理员"
                                                onclick="Admin.setRole(${u.id}, 1)" style="color:var(--primary)">
                                                <i data-lucide="shield" class="icon-sm"></i>
                                            </button>
                                            <button class="btn btn-ghost btn-sm btn-icon" title="删除"
                                                onclick="Admin.deleteUser(${u.id})" style="color:var(--danger)">
                                                <i data-lucide="trash-2" class="icon-sm"></i>
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${empty userList}">
                <div class="empty-state">
                    <div class="empty-icon"><i data-lucide="users" style="width:48px;height:48px"></i></div>
                    <h3>没有找到用户</h3>
                    <p>${not empty keyword ? '没有匹配 "' + keyword + '" 的用户' : '还没有注册用户'}</p>
                </div>
            </c:if>

            <!-- Pagination -->
            <c:if test="${maxPage > 1}">
                <div class="pagination">
                    <c:if test="${pn > 1}">
                        <a class="page-btn" href="?pn=${pn - 1}${not empty keyword ? '&keyword=' + keyword : ''}">上一页</a>
                    </c:if>
                    <c:forEach begin="1" end="${maxPage}" var="i">
                        <a class="page-btn ${i == pn ? 'active' : ''}" href="?pn=${i}${not empty keyword ? '&keyword=' + keyword : ''}">${i}</a>
                    </c:forEach>
                    <c:if test="${pn < maxPage}">
                        <a class="page-btn" href="?pn=${pn + 1}${not empty keyword ? '&keyword=' + keyword : ''}">下一页</a>
                    </c:if>
                </div>
            </c:if>
        </main>
    </div>

    <!-- User Detail Modal -->
    <div class="modal-backdrop" id="userModal">
        <div class="modal" style="max-width:460px">
            <div class="modal-header">
                <h3>用户详情</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body" style="text-align:center">
                <img id="udAvatar" class="avatar-xl" src="" alt="" style="margin-bottom:16px">
                <h3 id="udName" style="margin-bottom:8px"></h3>
                <div id="udRole" style="margin-bottom:20px"></div>
                <div style="text-align:left">
                    <div class="detail-row"><span class="detail-label">邮箱</span><span class="detail-value" id="udEmail"></span></div>
                    <div class="detail-row"><span class="detail-label">手机</span><span class="detail-value" id="udPhone"></span></div>
                    <div class="detail-row"><span class="detail-label">学号</span><span class="detail-value" id="udStuNum"></span></div>
                    <div class="detail-row"><span class="detail-label">消息数</span><span class="detail-value" id="udMsgCount"></span></div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-warning btn-sm" onclick="Admin.promptResetPwd()"><i data-lucide="key" class="icon-sm"></i> 重置密码</button>
                <button class="btn btn-ghost" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>

    <!-- Reset Password Modal -->
    <div class="modal-backdrop" id="resetPwdModal">
        <div class="modal" style="max-width:400px">
            <div class="modal-header">
                <h3>重置密码</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="resetPwdUserId">
                <p style="color:var(--text-secondary);margin-bottom:var(--space-md)">为用户 <strong id="resetPwdUserName"></strong> 设置新密码</p>
                <div class="form-group">
                    <label class="form-label">新密码</label>
                    <input type="password" class="form-control" id="resetPwdInput" placeholder="输入新密码" required>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-ghost" data-dismiss="modal">取消</button>
                <button class="btn btn-primary" onclick="Admin.doResetPwd()"><i data-lucide="check" class="icon-sm"></i> 确认重置</button>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal-backdrop" id="addUserModal">
        <div class="modal" style="max-width:480px">
            <div class="modal-header">
                <h3>添加用户</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <form id="addUserForm" onsubmit="event.preventDefault(); Admin.addUser()">
                    <div class="form-group">
                        <label class="form-label">邮箱 *</label>
                        <input type="email" class="form-control" name="email" placeholder="输入邮箱" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">密码 *</label>
                        <input type="password" class="form-control" name="pwd" placeholder="输入密码" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">昵称</label>
                        <input type="text" class="form-control" name="name" placeholder="输入昵称">
                    </div>
                    <div class="form-group">
                        <label class="form-label">手机号</label>
                        <input type="text" class="form-control" name="phone" placeholder="输入手机号">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-ghost" data-dismiss="modal">取消</button>
                <button class="btn btn-primary" onclick="Admin.addUser()"><i data-lucide="user-plus" class="icon-sm"></i> 添加</button>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal-backdrop" id="editUserModal">
        <div class="modal" style="max-width:480px">
            <div class="modal-header">
                <h3>编辑用户</h3>
                <button class="btn btn-ghost btn-sm btn-icon" data-dismiss="modal"><i data-lucide="x" class="icon-sm"></i></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="editUserId">
                <div class="form-group">
                    <label class="form-label">昵称</label>
                    <input type="text" class="form-control" id="editUserName" placeholder="输入昵称">
                </div>
                <div class="form-group">
                    <label class="form-label">手机号</label>
                    <input type="text" class="form-control" id="editUserPhone" placeholder="输入手机号">
                </div>
                <div class="form-group">
                    <label class="form-label">学号</label>
                    <input type="text" class="form-control" id="editUserStuNum" placeholder="输入学号">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-ghost" data-dismiss="modal">取消</button>
                <button class="btn btn-primary" onclick="Admin.saveEditUser()"><i data-lucide="check" class="icon-sm"></i> 保存</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=5" charset="UTF-8"></script>
    <script>Admin.initBatch("usersTable","usersBatchBar")</script>
</body>
</html>
