<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>我的消息 - 校园盐鱼</title>
    <style>
        .mess-card{background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-sm);overflow:hidden;margin-bottom:var(--space-md);border:1px solid var(--border-color)}
        .mess-item{display:flex;gap:var(--space-md);padding:var(--space-lg);border-bottom:1px solid var(--border-color);transition:background var(--transition-fast)}
        .mess-item:last-child{border-bottom:none}.mess-item:hover{background:var(--bg-hover)}
        .mess-item.unread{background:var(--primary-bg);border-left:3px solid var(--primary)}
        .mess-item.unread .mess-sender{font-weight:700}
        .unread-dot{display:inline-block;width:8px;height:8px;border-radius:50%;background:var(--primary);margin-right:6px;flex-shrink:0}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="mess"/>
    </jsp:include>

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:var(--space-xl)">
        <h1 style="font-size:1.4rem;display:flex;align-items:center;gap:8px"><i data-lucide="message-circle" class="icon-lg"></i> 我的消息 <span class="badge badge-secondary" style="font-size:0.75rem;font-weight:normal">${total}</span></h1>
        <div style="display:flex;align-items:center;gap:var(--space-md)">
            <select onchange="location.href=this.value" style="padding:6px 30px 6px 12px;border:1px solid var(--border-color);border-radius:20px;background:var(--bg-card);font-size:0.82rem;color:var(--text-primary);cursor:pointer;outline:none">
                <option value="${pageContext.request.contextPath}/personal/mess?sort=date_desc" ${sort == 'date_desc' ? 'selected' : ''}>时间最新</option>
                <option value="${pageContext.request.contextPath}/personal/mess?sort=date_asc" ${sort == 'date_asc' ? 'selected' : ''}>时间最早</option>
                <option value="${pageContext.request.contextPath}/personal/mess?sort=unread" ${sort == 'unread' ? 'selected' : ''}>仅未读</option>
            </select>
            <button class="btn btn-outline btn-sm" onclick="markAllRead()"><i data-lucide="check-check" class="icon-sm"></i> 全部标记已读</button>
        </div>
    </div>

    <c:choose>
        <c:when test="${handle == 'write'}">
            <div style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);padding:var(--space-xl);border:1px solid var(--border-color)">
                <h3 style="margin-bottom:var(--space-lg);display:flex;align-items:center;gap:8px"><i data-lucide="send" class="icon"></i> 发送消息</h3>
                <form action="${pageContext.request.contextPath}/MessCheckServlet" method="post">
                    <input type="hidden" name="handle" value="send">
                    <input type="hidden" name="InputEmailToSend" value="${toemail}">
                    <div class="form-group"><label class="form-label">收件人</label><input type="text" class="form-control" value="${not empty toname ? toname : toemail}" readonly></div>
                    <div class="form-group"><label class="form-label">消息内容</label><textarea class="form-control" name="InputMess" rows="5" placeholder="输入消息内容..." required></textarea></div>
                    <button type="submit" class="btn btn-primary"><i data-lucide="send" class="icon-sm"></i> 发送消息</button>
                    <a href="${pageContext.request.contextPath}/personal/mess" class="btn btn-ghost">返回</a>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <c:choose>
                <c:when test="${not empty messList}">
                    <div class="mess-card">
                        <c:forEach var="mess" items="${messList}">
                            <div class="mess-item ${mess.isRead == 0 ? 'unread' : ''}" style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/personal/mess?handle=detail&messId=${mess.messId}'">
                                <div style="flex-shrink:0;display:flex;align-items:center">
                                    <c:if test="${mess.isRead == 0}"><span class="unread-dot"></span></c:if>
                                    <img src="${pageContext.request.contextPath}/${senderMap[mess.messFromId].img}" class="avatar" alt="">
                                </div>
                                <div style="flex:1">
                                    <div class="mess-sender" style="font-weight:600;margin-bottom:var(--space-xs)">
                                        <c:choose><c:when test="${not empty senderMap[mess.messFromId].name}"><c:out value="${senderMap[mess.messFromId].name}" /></c:when><c:otherwise>系统消息</c:otherwise></c:choose>
                                    </div>
                                    <div style="font-size:0.92rem;line-height:1.6;max-height:3em;overflow:hidden;text-overflow:ellipsis"><c:out value="${mess.messText}" /></div>
                                    <div style="font-size:0.78rem;color:var(--text-light);margin-top:var(--space-sm);display:flex;align-items:center;gap:4px"><i data-lucide="clock" class="icon-sm"></i> <fmt:formatDate value="${mess.sendTime}" pattern="yyyy-MM-dd HH:mm" /></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                        <div class="pagination">
                            <a href="${pageContext.request.contextPath}/personal/mess?pn=${pn > 1 ? pn-1 : 1}&sort=${sort}" class="page-btn ${pn <= 1 ? 'disabled' : ''}">&#8249;</a>
                            <c:forEach begin="1" end="${maxPage}" var="i">
                                <a href="${pageContext.request.contextPath}/personal/mess?pn=${i}&sort=${sort}" class="page-btn ${i == pn ? 'active' : ''}">${i}</a>
                            </c:forEach>
                            <a href="${pageContext.request.contextPath}/personal/mess?pn=${pn < maxPage ? pn+1 : maxPage}&sort=${sort}" class="page-btn ${pn >= maxPage ? 'disabled' : ''}">&#8250;</a>
                        </div>
                    
                </c:when>
                <c:otherwise>
                    <div class="empty-state"><div class="empty-icon"><i data-lucide="message-circle" style="width:56px;height:56px;color:var(--text-light)"></i></div><h3>暂无消息</h3></div>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>

    </main></div>
    <script>
        function markAllRead() {
            SaltFish.ajax('api/messnum?action=markAllRead', {
                method: 'POST',
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u5df2\u5168\u90e8\u6807\u8bb0\u4e3a\u5df2\u8bfb');
                        document.querySelectorAll('.mess-item.unread').forEach(function(el) {
                            el.classList.remove('unread');
                            var dot = el.querySelector('.unread-dot');
                            if (dot) dot.remove();
                        });
                        if (typeof SaltFish.updateMessBadge === 'function') SaltFish.updateMessBadge();
                    }
                }
            });
        }
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
