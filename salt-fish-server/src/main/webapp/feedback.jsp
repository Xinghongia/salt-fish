<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>意见反馈 - 校园盐鱼</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="container" style="max-width:600px;margin:var(--space-2xl) auto">
        <div style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);padding:var(--space-2xl);border:1px solid var(--border-color)">
            <div style="text-align:center;margin-bottom:var(--space-2xl)">
                <h1 style="font-size:1.6rem;margin-bottom:var(--space-sm);display:flex;align-items:center;justify-content:center;gap:10px"><i data-lucide="message-square" class="icon-lg"></i> 意见反馈</h1>
                <p style="color:var(--text-secondary)">你的反馈是我们改进的动力</p>
            </div>

            <c:if test="${success}">
                <div class="alert alert-success">
                    <i data-lucide="check-circle" class="icon"></i>
                    <div>感谢你的反馈！我们会认真对待每一条建议。</div>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i data-lucide="alert-circle" class="icon"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <c:if test="${!success}">
                <form action="${pageContext.request.contextPath}/feedback" method="post">
                    <div class="form-group">
                        <label class="form-label">反馈类型</label>
                        <select name="type" class="form-control">
                            <option value="suggestion"><i data-lucide="lightbulb" class="icon-sm"></i> 建议</option>
                            <option value="bug">Bug反馈</option>
                            <option value="complaint">投诉</option>
                            <option value="other">其他</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">反馈内容</label>
                        <textarea class="form-control" name="content" rows="6" placeholder="请详细描述你的问题或建议..." required></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">联系方式（可选）</label>
                        <input type="text" class="form-control" name="contact" placeholder="邮箱或手机号，方便我们联系你">
                    </div>
                    <button type="submit" class="btn btn-primary btn-block btn-lg"><i data-lucide="send" class="icon"></i> 提交反馈</button>
                </form>
            </c:if>

            <div style="text-align:center;margin-top:var(--space-lg)">
                <a href="${pageContext.request.contextPath}/index" class="btn btn-ghost"><i data-lucide="arrow-left" class="icon-sm"></i> 返回首页</a>
            </div>
        </div>
    </div>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
