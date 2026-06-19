<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>发布商品 - 校园盐鱼</title>
    <style>
        .file-upload{border:2px dashed var(--border-color);border-radius:var(--border-radius);padding:var(--space-2xl);text-align:center;cursor:pointer;transition:all var(--transition-fast);background:var(--bg-hover)}
        .file-upload:hover{border-color:var(--primary);background:var(--primary-bg)}
        .file-upload input[type="file"]{display:none}
        .type-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:var(--space-sm)}
        .type-option{display:flex;align-items:center;justify-content:center;gap:var(--space-xs);padding:12px;background:var(--bg-hover);border:2px solid var(--border-color);border-radius:var(--border-radius);cursor:pointer;transition:all var(--transition-fast);font-size:0.88rem}
        .type-option:hover,.type-option.selected{border-color:var(--primary);background:var(--primary-bg);color:var(--primary)}
        .type-option input{display:none}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="push"/>
    </jsp:include>

    <div style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);padding:var(--space-2xl);border:1px solid var(--border-color)">
        <div style="text-align:center;margin-bottom:var(--space-2xl)">
            <h1 style="font-size:1.6rem;margin-bottom:var(--space-sm);display:flex;align-items:center;justify-content:center;gap:10px"><i data-lucide="plus-circle" class="icon-lg"></i> 发布新商品</h1>
            <p style="color:var(--text-secondary)">填写商品信息，让闲置物品找到新主人</p>
        </div>

        <c:if test="${not empty info}"><div class="alert alert-success"><i data-lucide="check-circle" class="icon"></i> <c:out value="${info}" /></div></c:if>
        <c:if test="${not empty isCheck}">
            <div class="alert alert-danger">
                <i data-lucide="alert-circle" class="icon"></i>
                <div>
                    <c:if test="${not empty nameCheck}"><c:out value="${nameCheck}" /></c:if>
                    <c:if test="${not empty quantityCheck}"><c:out value="${quantityCheck}" /></c:if>
                    <c:if test="${not empty contentCheck}"><c:out value="${contentCheck}" /></c:if>
                    <c:if test="${not empty fileCheck}"><c:out value="${fileCheck}" /></c:if>
                </div>
            </div>
        </c:if>

        <form action="${basePath}GoodsCheckServlet" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label class="form-label"><i data-lucide="tag" class="icon-sm"></i> 商品名称</label>
                <input class="form-control" name="name-goods" placeholder="给商品起个名字" required>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="banknote" class="icon-sm"></i> 价格（元）</label>
                <input type="number" class="form-control" name="quantity-goods" placeholder="0.00" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="grid-3x3" class="icon-sm"></i> 商品分类</label>
                <div class="type-grid">
                    <c:forEach var="cat" items="${categoryList}">
                    <label class="type-option"><input type="radio" name="type_id-goods" value="${cat.id}" required><i data-lucide="${cat.icon}" class="icon-sm"></i> ${cat.name}</label>
                    </c:forEach>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="file-text" class="icon-sm"></i> 商品描述</label>
                <textarea class="form-control" name="content-goods" rows="5" placeholder="详细描述商品状态..." required></textarea>
            </div>
            <div class="form-group">
                <label class="form-label"><i data-lucide="camera" class="icon-sm"></i> 商品图片</label>
                <div class="file-upload" onclick="document.getElementById('fileInput').click()">
                    <i data-lucide="upload" style="width:48px;height:48px;color:var(--text-light);margin-bottom:var(--space-sm)"></i>
                    <p style="color:var(--text-secondary)">点击上传商品图片</p>
                    <input type="file" name="file" id="fileInput" accept="image/*" onchange="previewFile(this)">
                </div>
                <div id="filePreview" style="margin-top:var(--space-md);display:none">
                    <img id="previewImg" style="max-width:200px;border-radius:var(--border-radius)">
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg"><i data-lucide="rocket" class="icon"></i> 发布商品</button>
        </form>
    </div>

    </main></div>
    <script>
        document.querySelectorAll('.type-option').forEach(function(opt) {
            opt.addEventListener('click', function() {
                document.querySelectorAll('.type-option').forEach(function(o) { o.classList.remove('selected'); });
                this.classList.add('selected');
            });
        });
        function previewFile(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                    document.getElementById('filePreview').style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
