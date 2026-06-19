<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>消息详情 - 校园盐鱼</title>
    <style>
        .detail-card{background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);overflow:hidden;border:1px solid var(--border-color);margin-bottom:var(--space-xl)}
        .detail-header{display:flex;align-items:center;gap:var(--space-lg);padding:var(--space-xl);border-bottom:1px solid var(--border-color);background:var(--bg-hover)}
        .detail-body{padding:var(--space-2xl);line-height:2;font-size:1rem;min-height:120px;white-space:pre-wrap;word-break:break-word}
        .detail-footer{padding:var(--space-lg) var(--space-xl);border-top:1px solid var(--border-color);display:flex;align-items:center;justify-content:space-between;font-size:0.82rem;color:var(--text-secondary)}
        .reply-card{background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-sm);padding:var(--space-xl);border:1px solid var(--border-color)}
        .reply-card h3{font-size:1.1rem;margin-bottom:var(--space-lg);display:flex;align-items:center;gap:8px}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="mess"/>
    </jsp:include>

    <div style="margin-bottom:var(--space-xl)">
        <a href="${pageContext.request.contextPath}/personal/mess" style="font-size:0.88rem;color:var(--text-secondary);display:inline-flex;align-items:center;gap:4px;text-decoration:none">
            <i data-lucide="arrow-left" class="icon-sm"></i> 返回消息列表
        </a>
    </div>

    <div class="detail-card">
        <div class="detail-header">
            <img src="${pageContext.request.contextPath}/${sender.img}" class="avatar avatar-lg" alt="">
            <div style="flex:1">
                <div style="font-size:1.1rem;font-weight:700">
                    <c:choose>
                        <c:when test="${not empty sender.name}"><c:out value="${sender.name}" /></c:when>
                        <c:otherwise>系统消息</c:otherwise>
                    </c:choose>
                </div>
                <div style="font-size:0.82rem;color:var(--text-secondary);margin-top:2px">
                    <i data-lucide="clock" class="icon-sm"></i>
                    <fmt:formatDate value="${mess.sendTime}" pattern="yyyy年MM月dd日 HH:mm:ss" />
                </div>
            </div>
            <span class="badge badge-success" style="font-size:0.75rem"><i data-lucide="check" class="icon-sm"></i> 已读</span>
        </div>
        <div class="detail-body"><c:out value="${mess.messText}" /></div>
    </div>

    <div class="reply-card">
        <h3><i data-lucide="reply" class="icon"></i> 回复消息</h3>
        <form action="${pageContext.request.contextPath}/MessCheckServlet" method="post">
            <input type="hidden" name="handle" value="send">
            <input type="hidden" name="InputEmailToSend" value="${sender.email}">
            <div class="form-group">
                <label class="form-label">回复给</label>
                <input type="text" class="form-control" value="<c:choose><c:when test='${not empty sender.name}'><c:out value='${sender.name}' /></c:when><c:otherwise><c:out value='${sender.email}' /></c:otherwise></c:choose>" readonly style="background:var(--bg-hover)">
            </div>
            <div class="form-group">
                <label class="form-label">回复内容</label>
                <textarea class="form-control" name="InputMess" rows="5" placeholder="输入回复内容..." required></textarea>
            </div>
            <div style="display:flex;gap:var(--space-md)">
                <button type="submit" class="btn btn-primary"><i data-lucide="send" class="icon-sm"></i> 发送回复</button>
                <a href="${pageContext.request.contextPath}/personal/mess" class="btn btn-ghost">返回列表</a>
            </div>
        </form>
    </div>

    </main></div>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>