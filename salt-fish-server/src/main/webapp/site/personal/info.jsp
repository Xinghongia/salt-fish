<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>个人中心 - 校园盐鱼</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="info"/>
    </jsp:include>

    <div class="profile-card" style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);overflow:hidden;border:1px solid var(--border-color)">
        <div style="background:linear-gradient(135deg,var(--primary) 0%,#8b5cf6 100%);padding:var(--space-2xl) var(--space-xl);display:flex;align-items:center;gap:var(--space-xl);color:var(--text-white)">
            <img src="${pageContext.request.contextPath}/${viewUser.img}" class="avatar avatar-xl" style="border:3px solid rgba(255,255,255,0.3)" alt="">
            <div>
                <div style="font-size:1.4rem;font-weight:700">
                    <c:choose>
                        <c:when test="${not empty viewUser.name}"><c:out value="${viewUser.name}" /></c:when>
                        <c:otherwise>未设置昵称</c:otherwise>
                    </c:choose>
                </div>
                <div style="opacity:0.8;font-size:0.88rem;margin-top:4px"><c:out value="${viewUser.email}" /></div>
            </div>
        </div>
        <div style="padding:var(--space-2xl)">
            <c:if test="${not empty param.info}">
                <div class="alert alert-danger"><i data-lucide="alert-circle" class="icon"></i> <c:out value="${param.info}" /></div>
            </c:if>

            <h3 style="font-size:1.15rem;font-weight:600;margin-bottom:var(--space-lg);padding-bottom:var(--space-sm);border-bottom:2px solid var(--border-color);display:flex;align-items:center;gap:8px"><i data-lucide="file-text" class="icon"></i> 个人资料</h3>
            <form action="${pageContext.request.contextPath}/UpdateUserInfoServlet" method="post">
                <div class="grid grid-2" style="margin-bottom:var(--space-lg)">
                    <div class="form-group">
                        <label class="form-label">昵称</label>
                        <input type="text" class="form-control" name="name" value="<c:out value='${viewUser.name}' />" <c:if test="${not isMe}">readonly</c:if>>
                    </div>
                    <div class="form-group">
                        <label class="form-label">邮箱</label>
                        <input type="text" class="form-control" value="<c:out value='${viewUser.email}' />" readonly style="background:var(--bg-hover)">
                    </div>
                    <div class="form-group">
                        <label class="form-label">手机号</label>
                        <input type="text" class="form-control" name="phone" value="<c:out value='${viewUser.phone}' default='' />" <c:if test="${not isMe}">readonly</c:if>>
                    </div>
                    <div class="form-group">
                        <label class="form-label">学号</label>
                        <input type="text" class="form-control" name="stuNum" value="<c:out value='${viewUser.stuNum}' default=' ' />" <c:if test="${not isMe}">readonly</c:if>>
                    </div>
                    <div class="form-group">
                        <label class="form-label">QQ</label>
                        <input type="text" class="form-control" name="qq" value="<c:out value='${viewUser.qq}' default=' ' />" <c:if test="${not isMe}">readonly</c:if>>
                    </div>
                </div>
                <c:if test="${isMe}">
                    <div style="margin-top:var(--space-lg);display:flex;gap:var(--space-md)">
                        <button type="submit" class="btn btn-primary"><i data-lucide="save" class="icon-sm"></i> 保存修改</button>
                        <a href="${pageContext.request.contextPath}/exit" class="btn btn-ghost" style="color:var(--danger)"><i data-lucide="log-out" class="icon-sm"></i> 退出登录</a>
                    </div>
                </c:if>
                <c:if test="${not isMe}">
                    <a href="${pageContext.request.contextPath}/personal/mess?handle=write&toemail=${fn:escapeXml(viewUser.email)}&toname=${fn:escapeXml(viewUser.name)}" class="btn btn-primary"><i data-lucide="send" class="icon-sm"></i> 发送消息</a>
                </c:if>
            </form>
        </div>
    </div>

    </main></div>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>