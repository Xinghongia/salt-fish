<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/admin.css?v=5">
    <title>系统设置 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="settings"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="settings" class="icon-lg"></i> 系统设置</h1>
                <p>配置平台基本参数</p>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-success" style="margin-bottom:var(--space-lg)">
                    <i data-lucide="check-circle" class="icon"></i> ${msg}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/admin/settings">
                <div style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);padding:var(--space-2xl);border:1px solid var(--border-color);margin-bottom:var(--space-xl)">
                    <h3 style="margin-bottom:var(--space-xl);display:flex;align-items:center;gap:8px"><i data-lucide="globe" class="icon"></i> 站点信息</h3>
                    <div class="form-group">
                        <label class="form-label">站点名称</label>
                        <input type="text" class="form-control" name="site_name" value="${siteName != null ? siteName : '校园盐鱼'}" placeholder="校园盐鱼">
                    </div>
                    <div class="form-group">
                        <label class="form-label">站点描述</label>
                        <textarea class="form-control" name="site_description" rows="3" placeholder="校园二手交易平台">${siteDesc != null ? siteDesc : ''}</textarea>
                    </div>
                </div>

                <div style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);padding:var(--space-2xl);border:1px solid var(--border-color);margin-bottom:var(--space-xl)">
                    <h3 style="margin-bottom:var(--space-xl);display:flex;align-items:center;gap:8px"><i data-lucide="sliders" class="icon"></i> 显示设置</h3>
                    <div class="form-group">
                        <label class="form-label">商品每页显示数量</label>
                        <input type="number" class="form-control" name="perpage_goods" value="${perPageGoods != null ? perPageGoods : '12'}" min="1" max="100" style="max-width:200px">
                    </div>
                    <div class="form-group">
                        <label class="form-label">维护模式</label>
                        <select class="form-control" name="maintenance_mode" style="max-width:200px">
                            <option value="0" ${maintenanceMode == '0' || empty maintenanceMode ? 'selected' : ''}>关闭</option>
                            <option value="1" ${maintenanceMode == '1' ? 'selected' : ''}>开启</option>
                        </select>
                        <small style="color:var(--text-light);font-size:0.82rem;margin-top:4px;display:block">开启后普通用户将无法访问前台页面</small>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg"><i data-lucide="save" class="icon"></i> 保存设置</button>
            </form>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=6" charset="UTF-8"></script>
</body>
</html>