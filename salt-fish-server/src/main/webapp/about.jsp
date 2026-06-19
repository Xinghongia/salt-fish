<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>关于我们 - 校园盐鱼</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="page-hero">
        <div class="container" style="position:relative;z-index:1;text-align:center">
            <h1 style="display:flex;align-items:center;justify-content:center;gap:12px"><i data-lucide="fish" style="width:40px;height:40px"></i> 关于校园盐鱼</h1>
            <p>让每一件闲置都找到新主人</p>
        </div>
    </div>
    <div class="container" style="max-width:800px">
        <div style="background:var(--bg-card);border-radius:var(--border-radius-lg);box-shadow:var(--shadow-md);padding:var(--space-2xl);margin-top:calc(-1 * var(--space-xl));position:relative;z-index:2;border:1px solid var(--border-color)">
            <div style="line-height:2;color:var(--text-primary)">
                <h3>关于我们</h3>
                <p>校园盐鱼是一个面向在校学生的二手物品交易平台，旨在帮助同学们方便地买卖闲置物品，促进资源的循环利用。</p>

                <h3 style="margin-top:var(--space-lg)">我们的愿景</h3>
                <p>我们希望打造一个安全、便捷、诚信的校园二手交易环境，让每一件闲置物品都能找到新的主人，减少资源浪费。</p>

                <h3 style="margin-top:var(--space-lg)">平台特色</h3>
                <div class="grid grid-3" style="margin-top:var(--space-md)">
                    <div style="text-align:center;padding:var(--space-lg)">
                        <i data-lucide="shield-check" style="width:48px;height:48px;color:var(--primary);margin-bottom:var(--space-sm)"></i>
                        <h4>安全可靠</h4>
                        <p style="font-size:0.88rem;color:var(--text-secondary)">商品审核机制，保障交易安全</p>
                    </div>
                    <div style="text-align:center;padding:var(--space-lg)">
                        <i data-lucide="banknote" style="width:48px;height:48px;color:var(--success);margin-bottom:var(--space-sm)"></i>
                        <h4>价格实惠</h4>
                        <p style="font-size:0.88rem;color:var(--text-secondary)">校园内部交易，省去中间环节</p>
                    </div>
                    <div style="text-align:center;padding:var(--space-lg)">
                        <i data-lucide="leaf" style="width:48px;height:48px;color:var(--success-dark);margin-bottom:var(--space-sm)"></i>
                        <h4>绿色环保</h4>
                        <p style="font-size:0.88rem;color:var(--text-secondary)">闲置再利用，为环保出一份力</p>
                    </div>
                </div>

                <h3 style="margin-top:var(--space-lg)">联系我们</h3>
                <p>如有任何问题或建议，欢迎通过平台站内消息联系我们。</p>
            </div>
            <div style="text-align:center;margin-top:var(--space-2xl)">
                <a href="${pageContext.request.contextPath}/index" class="btn btn-primary btn-lg"><i data-lucide="arrow-right" class="icon"></i> 开始逛逛</a>
            </div>
        </div>
    </div>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>
