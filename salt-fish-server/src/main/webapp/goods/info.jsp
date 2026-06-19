<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty goods}">
    <c:redirect url="/index?ceta=0" />
</c:if>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <base href="${basePath}">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>${goods.name} - 校园盐鱼</title>
    <style>
        .goods-detail{display:grid;grid-template-columns:1fr 1fr;gap:var(--space-2xl);margin:var(--space-2xl) 0}
        .goods-gallery{border-radius:var(--border-radius-lg);overflow:hidden;background:var(--bg-hover);height:420px;display:flex;align-items:center;justify-content:center}
        .goods-gallery img{max-width:100%;max-height:100%;object-fit:contain;display:block}
        .goods-info h1{font-size:1.75rem;margin-bottom:var(--space-md)}
        .goods-price-box{background:var(--primary-bg);padding:var(--space-lg);border-radius:var(--border-radius);margin-bottom:var(--space-lg)}
        .goods-price-box .price{font-size:2.5rem;font-weight:700;color:var(--danger)}.goods-price-box .price .symbol{font-size:1.5rem}
        .goods-meta-list{list-style:none;margin-bottom:var(--space-lg)}
        .goods-meta-list li{display:flex;align-items:center;gap:var(--space-md);padding:var(--space-sm) 0;border-bottom:1px solid var(--border-color);font-size:0.95rem}
        .goods-meta-list li .label{color:var(--text-secondary);min-width:80px}
        .goods-actions{display:flex;gap:var(--space-md);margin-top:var(--space-xl)}
        .goods-content{margin:var(--space-2xl) 0}
        .goods-content h3{font-size:1.25rem;margin-bottom:var(--space-md);padding-bottom:var(--space-sm);border-bottom:2px solid var(--primary)}
        .goods-content .content-text{line-height:2;font-size:1rem;color:var(--text-primary);background:var(--bg-card);padding:var(--space-lg);border-radius:var(--border-radius)}
        .seller-card{background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-lg);box-shadow:var(--shadow-sm);margin-top:var(--space-xl);border:1px solid var(--border-color)}
        .seller-card .seller-header{display:flex;align-items:center;gap:var(--space-md);margin-bottom:var(--space-md)}
        .buy-panel{background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-xl);box-shadow:var(--shadow-md);margin-top:var(--space-xl);display:none;border:1px solid var(--border-color)}
        .trade-panel{background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-xl);box-shadow:var(--shadow-md);margin-top:var(--space-xl);border:1px solid var(--border-color)}
        .trade-panel h3{margin-bottom:var(--space-md)}
        .trade-panel .trade-info{color:var(--text-secondary);margin-bottom:var(--space-lg);font-size:0.92rem}
        @media(max-width:768px){.goods-detail{grid-template-columns:1fr}}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />

    <div class="container">
        <!-- Breadcrumb -->
        <div style="padding:var(--space-md) 0;font-size:0.88rem;color:var(--text-secondary);display:flex;align-items:center;gap:6px">
            <a href="${basePath}index"><i data-lucide="home" class="icon-sm"></i></a>
            <span>/</span>
            <a href="${basePath}index?ceta=${goods.typeId}">${typeName}</a>
            <span>/</span>
            <span>${goods.name}</span>
        </div>

        <div class="goods-detail">
            <!-- Gallery -->
            <div class="goods-gallery">
                <img src="${goods.image}" alt="${goods.name}" title="右键查看原图">
            </div>

            <!-- Info -->
            <div class="goods-info">
                <h1><c:out value="${goods.name}" /></h1>

                <div class="goods-price-box">
                    <div class="price"><span class="symbol">&yen;</span>${goods.price}</div>
                </div>

                <ul class="goods-meta-list">
                    <li><span class="label"><i data-lucide="tag" class="icon-sm"></i> 分类</span><a href="${basePath}index?ceta=${goods.typeId}">${typeName}</a></li>
                    <li><span class="label"><i data-lucide="user" class="icon-sm"></i> 发布者</span>
                        <a href="${basePath}pushed?userId=${producer.id}">
                            <c:choose>
                                <c:when test="${not empty producer.name}"><c:out value="${producer.name}" /></c:when>
                                <c:otherwise><c:out value="${producer.email}" /></c:otherwise>
                            </c:choose>
                        </a>
                    </li>
                    <li><span class="label"><i data-lucide="calendar" class="icon-sm"></i> 发布时间</span><fmt:formatDate value="${goods.createDate}" pattern="yyyy年MM月dd日 HH:mm" /></li>
                    <li><span class="label"><i data-lucide="info" class="icon-sm"></i> 状态</span>
                        <c:choose>
                            <c:when test="${goods.status == 1}"><span class="badge badge-warning">待审核</span></c:when>
                            <c:when test="${goods.status == 2}"><span class="badge badge-success">在售</span></c:when>
                            <c:when test="${goods.status == 3}"><span class="badge badge-danger">审核未通过</span></c:when>
                            <c:when test="${goods.status == 4}"><span class="badge badge-info">交易中</span></c:when>
                            <c:when test="${goods.status == 5}"><span class="badge badge-secondary">已售出</span></c:when>
                            <c:otherwise><span class="badge badge-secondary">未知</span></c:otherwise>
                        </c:choose>
                    </li>
                </ul>

                <c:if test="${not empty info}">
                    <div class="alert alert-warning"><i data-lucide="alert-triangle" class="icon"></i> <c:out value="${info}" /></div>
                </c:if>

                <!-- Actions for visitors/buyers -->
                <c:if test="${!isSeller}">
                    <div class="goods-actions">
                        <c:if test="${goods.status == 2 || goods.status == 4}">
                            <button class="btn btn-outline btn-lg" id="collectBtn" onclick="handleCollect()"><i data-lucide="heart" class="icon"></i> 收藏</button>
                        </c:if>
                        <c:if test="${canBuy}">
                            <button class="btn btn-secondary btn-lg" id="cartBtn" onclick="handleCart()"><i data-lucide="shopping-cart" class="icon"></i> 加入购物车</button>
                            <button class="btn btn-primary btn-lg" onclick="showBuyPanel()"><i data-lucide="banknote" class="icon"></i> 立即购买</button>
                        </c:if>
                        <c:if test="${goods.status == 4 && isBuyer}">
                            <button class="btn btn-lg" disabled style="opacity:0.6;cursor:not-allowed"><i data-lucide="clock" class="icon"></i> 等待卖家确认</button>
                        </c:if>
                        <c:if test="${goods.status == 5}">
                            <button class="btn btn-lg" disabled style="opacity:0.5"><i data-lucide="check-circle" class="icon"></i> 已售出</button>
                        </c:if>
                        <c:if test="${goods.status == 3}">
                            <button class="btn btn-lg" disabled style="opacity:0.5"><i data-lucide="x-circle" class="icon"></i> 暂不可购买</button>
                        </c:if>
                    </div>
                    <c:if test="${goods.status == 4 && isBuyer && not empty order.message}">
                        <div style="margin-top:var(--space-md);background:var(--bg-hover);padding:var(--space-md);border-radius:var(--border-radius);font-size:0.88rem;color:var(--text-secondary)">
                            <strong><i data-lucide="message-circle" class="icon-sm"></i> 你的留言：</strong> <c:out value="${order.message}" />
                        </div>
                    </c:if>
                </c:if>

                <!-- Actions for seller when status=4 (trading) -->
                <c:if test="${isSeller && goods.status == 4}">
                    <div class="trade-panel">
                        <h3><i data-lucide="swap-horizontal" class="icon"></i> 交易进行中</h3>
                        <p class="trade-info">买家已下单，等待您确认交易。请与买家沟通后选择操作：</p>
                        <div class="flex gap-md">
                            <button class="btn btn-success btn-lg" onclick="handleCompleteOrder(${goods.id})"><i data-lucide="check-circle" class="icon"></i> 确认交易完成</button>
                            <button class="btn btn-danger btn-lg" onclick="handleCancelOrder(${goods.id})"><i data-lucide="x-circle" class="icon"></i> 取消交易</button>
                        </div>
                    </div>
                </c:if>

                <!-- Seller view: on sale -->
                <c:if test="${isSeller && goods.status == 2}">
                    <div class="trade-panel" style="border-left:4px solid var(--success)">
                        <h3><i data-lucide="tag" class="icon"></i> 这是你的商品</h3>
                        <p class="trade-info">当前已在售，等待买家下单。你可以在"我的发布"中管理所有商品。</p>
                    </div>
                </c:if>
                <!-- Seller view for other statuses -->
                <c:if test="${isSeller && goods.status == 5}">
                    <div class="trade-panel" style="border-left:4px solid var(--success)">
                        <h3><i data-lucide="check-circle" class="icon"></i> 交易已完成</h3>
                        <p class="trade-info">此商品已成功售出。</p>
                    </div>
                </c:if>
                <c:if test="${isSeller && goods.status == 3}">
                    <div class="trade-panel" style="border-left:4px solid var(--danger)">
                        <h3><i data-lucide="x-circle" class="icon"></i> 审核未通过</h3>
                        <p class="trade-info">此商品未通过管理员审核，前台不会展示。</p>
                    </div>
                </c:if>
                <c:if test="${isSeller && goods.status == 1}">
                    <div class="trade-panel" style="border-left:4px solid var(--warning)">
                        <h3><i data-lucide="clock" class="icon"></i> 等待审核</h3>
                        <p class="trade-info">商品正在审核中，请耐心等待。</p>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Buy Panel -->
        <div class="buy-panel" id="buyPanel">
            <h3 style="margin-bottom:var(--space-md)"><i data-lucide="message-circle" class="icon"></i> 确认购买</h3>
            <p style="color:var(--text-secondary);margin-bottom:var(--space-md)">给卖家留个言吧，方便沟通交易细节</p>
            <form action="${basePath}OrderCheckServlet?goodsId=${goods.id}&userId=${loginUser.id}" method="post">
                <div class="form-group">
                    <textarea class="form-control" name="message-to-seller" placeholder="你好，我想购买这件商品..." rows="4"></textarea>
                </div>
                <div class="flex gap-md">
                    <button type="submit" class="btn btn-primary btn-lg">确认购买</button>
                    <button type="button" class="btn btn-ghost btn-lg" onclick="hideBuyPanel()">取消</button>
                </div>
            </form>
        </div>

        <!-- Description -->
        <div class="goods-content">
            <h3><i data-lucide="file-text" class="icon"></i> 商品描述</h3>
            <div class="content-text">
                <c:out value="${goods.content}" />
            </div>
        </div>

        <!-- Seller Card -->
        <div class="seller-card">
            <div class="seller-header">
                <img src="${pageContext.request.contextPath}/${producer.img}" class="avatar avatar-lg" alt="">
                <div>
                    <div style="font-size:1.05rem;font-weight:600">
                        <c:choose>
                            <c:when test="${not empty producer.name}"><c:out value="${producer.name}" /></c:when>
                            <c:otherwise><c:out value="${producer.email}" /></c:otherwise>
                        </c:choose>
                    </div>
                    <div style="color:var(--text-secondary);font-size:0.82rem;margin-top:2px">卖家</div>
                </div>
            </div>
            <div class="flex gap-md">
                <a href="mailto:${producer.email}" class="btn btn-outline btn-sm"><i data-lucide="at-sign" class="icon-sm"></i> 发邮件</a>
                <a href="${basePath}personal/mess?handle=write&toemail=${fn:escapeXml(producer.email)}&toname=${fn:escapeXml(producer.name)}" class="btn btn-outline btn-sm"><i data-lucide="send" class="icon-sm"></i> 发站内信</a>
                <a href="${basePath}pushed?userId=${producer.id}" class="btn btn-ghost btn-sm"><i data-lucide="external-link" class="icon-sm"></i> 查看TA的其他商品</a>
            </div>
        </div>
    </div>

    <script>
        var isLogin = ${isLogin ? 'true' : 'false'};
        var goodsId = ${goods.id};
        var basePath = '${basePath}';

        function handleCollect() {
            if (!isLogin) { location.href = basePath + 'user/login.jsp'; return; }
            SaltFish.toggleCollect(goodsId, document.getElementById('collectBtn'));
        }
        // 初始化收藏状态
        if (isLogin) {
            SaltFish.ajax('CheckCollectServlet?goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        document.getElementById('collectBtn').classList.add('collected');
                    }
                }
            });
        }
        function handleCart() {
            if (!isLogin) { location.href = basePath + 'user/login.jsp'; return; }
            SaltFish.addToCart(goodsId, document.getElementById('cartBtn'));
        }
        function showBuyPanel() {
            if (!isLogin) { location.href = basePath + 'user/login.jsp'; return; }
            document.getElementById('buyPanel').style.display = 'block';
            document.getElementById('buyPanel').scrollIntoView({behavior:'smooth'});
        }
        function hideBuyPanel() {
            document.getElementById('buyPanel').style.display = 'none';
        }
        function handleCompleteOrder(goodsId) {
            if (!confirm('\u786e\u8ba4\u4ea4\u6613\u5df2\u5b8c\u6210\uff1f\u78e8\u8ba4\u540e\u5546\u54c1\u5c06\u6807\u8bb0\u4e3a\u5df2\u552e\u51fa\u3002')) return;
            SaltFish.ajax('api/admin/action?action=completeOrder&goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u4ea4\u6613\u5df2\u5b8c\u6210');
                        setTimeout(function() { location.reload(); }, 800);
                    } else {
                        SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                    }
                }
            });
        }
        function handleCancelOrder(goodsId) {
            if (!confirm('\u786e\u5b9a\u53d6\u6d88\u4ea4\u6613\uff1f\u5546\u54c1\u5c06\u6062\u590d\u4e3a\u5728\u552e\u72b6\u6001\u3002')) return;
            SaltFish.ajax('api/admin/action?action=cancelOrder&goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u4ea4\u6613\u5df2\u53d6\u6d88');
                        setTimeout(function() { location.reload(); }, 800);
                    } else {
                        SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                    }
                }
            });
        }
    </script>

    <jsp:include page="/common/footer.jsp" />
</body>
</html>