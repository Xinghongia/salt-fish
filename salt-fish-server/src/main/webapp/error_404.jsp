<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/lucide@0.344.0/dist/umd/lucide.min.js"></script>
    <script src="${pageContext.request.contextPath}/src/js/common.js" charset="UTF-8"></script>
    <title>页面未找到 - 校园盐鱼</title>
    <style>
        .error-page{min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--bg-body)}
        .error-content{text-align:center;padding:var(--space-2xl)}
        .error-code{font-size:8rem;font-weight:800;background:linear-gradient(135deg,var(--primary),#8b5cf6);-webkit-background-clip:text;-webkit-text-fill-color:transparent;line-height:1;margin-bottom:var(--space-md)}
        .error-title{font-size:1.6rem;margin-bottom:var(--space-sm)}.error-desc{color:var(--text-secondary);margin-bottom:var(--space-xl)}
    </style>
</head>
<body class="error-page">
    <div class="error-content">
        <div class="error-code">404</div>
        <h1 class="error-title">页面走丢了</h1>
        <p class="error-desc">你访问的页面不存在或已被移除</p>
        <div class="flex gap-md justify-center">
            <a href="${pageContext.request.contextPath}/index" class="btn btn-primary btn-lg"><i data-lucide="home" class="icon"></i> 返回首页</a>
            <a href="javascript:history.back()" class="btn btn-outline btn-lg"><i data-lucide="arrow-left" class="icon"></i> 返回上一页</a>
        </div>
    </div>
</body>
</html>
