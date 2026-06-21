<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <title>购物车 - 校园盐鱼</title>

    <style>
        .sort-wrap{display:inline-flex;align-items:center;gap:6px;margin-left:auto}
        .sort-wrap label{font-size:0.82rem;color:var(--text-secondary);white-space:nowrap}
        .sort-wrap select{appearance:none!important;-webkit-appearance:none!important;-moz-appearance:none!important;padding:6px 30px 6px 12px;border:1px solid var(--border-color);border-radius:20px;background:var(--bg-card) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E") no-repeat right 10px center;font-size:0.82rem;color:var(--text-primary);cursor:pointer;transition:all 0.2s;outline:none}
        .sort-wrap select:hover{border-color:var(--primary)}
        .sort-wrap select:focus{border-color:var(--primary);box-shadow:0 0 0 3px var(--primary-bg)}
    </style>

    <style>
        .cart-item{display:flex;gap:var(--space-lg);background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-lg);margin-bottom:var(--space-md);box-shadow:var(--shadow-sm);border:1px solid var(--border-color)}
        .cart-item .item-img{width:100px;height:100px;border-radius:var(--border-radius);object-fit:cover;flex-shrink:0}
        .cart-item .item-info{flex:1;display:flex;flex-direction:column;justify-content:space-between}
        .cart-item .item-price{font-size:1.15rem;font-weight:700;color:var(--danger)}
        .cart-summary{background:var(--bg-card);border-radius:var(--border-radius-lg);padding:var(--space-xl);box-shadow:var(--shadow-md);margin-top:var(--space-xl);display:flex;justify-content:space-between;align-items:center;border:1px solid var(--border-color)}
        .cart-item.unavailable{opacity:0.55}
        .cart-item.unavailable .item-name a{color:var(--text-light);text-decoration:line-through}
    </style>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <jsp:include page="/common/personal-sidebar.jsp">
        <jsp:param name="activeTab" value="shopcart"/>
    </jsp:include>

    <c:if test="${not empty param.info}">
        <div style="background:var(--success-bg,var(--primary-bg));border:1px solid var(--success,var(--primary));border-radius:var(--border-radius);padding:var(--space-md) var(--space-lg);margin-bottom:var(--space-lg);display:flex;align-items:center;gap:8px;font-size:0.92rem"><i data-lucide="check-circle" class="icon-sm" style="color:var(--success,var(--primary))"></i> <c:out value="${param.info}" /></div>
    </c:if>

    <div style="display:flex;align-items:center;margin-bottom:var(--space-xl)">
        <div>
            <h1 style="font-size:1.4rem;display:flex;align-items:center;gap:8px"><i data-lucide="shopping-cart" class="icon-lg"></i> 我的购物车</h1>
            <p style="color:var(--text-secondary);font-size:0.85rem;margin-top:2px">共 ${total} 件商品</p>
        </div>
                <div class="sort-wrap">
            <label>排序</label>
            <select onchange="location.href=this.value">
                <option value="${pageContext.request.contextPath}/shopcart?pn=${pn}&sort=date_desc" ${sort == 'date_desc' ? 'selected' : ''}>时间最新</option>
                <option value="${pageContext.request.contextPath}/shopcart?pn=${pn}&sort=date_asc" ${sort == 'date_asc' ? 'selected' : ''}>时间最早</option>
                <option value="${pageContext.request.contextPath}/shopcart?pn=${pn}&sort=price_asc" ${sort == 'price_asc' ? 'selected' : ''}>价格低→高</option>
                <option value="${pageContext.request.contextPath}/shopcart?pn=${pn}&sort=price_desc" ${sort == 'price_desc' ? 'selected' : ''}>价格高→低</option>
            </select>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty goodsList}">
            <div id="cartItems">
                <c:forEach var="goods" items="${goodsList}">
                    <div class="cart-item ${goods.status == 2 ? '' : 'unavailable'}" id="cart-item-${goods.id}">
                        <img class="item-img" src="${pageContext.request.contextPath}/${goods.image}" alt="${goods.name}">
                        <div class="item-info">
                            <div>
                                <div class="item-name">
                                <c:choose>
                                    <c:when test="${goods.status == 2}"><span class="badge badge-success" style="font-size:0.7rem">在售</span></c:when>
                                    <c:when test="${goods.status == 4}"><span class="badge badge-warning" style="font-size:0.7rem">交易中</span></c:when>
                                    <c:when test="${goods.status == 5}"><span class="badge badge-secondary" style="font-size:0.7rem">已售出</span></c:when>
                                    <c:otherwise><span class="badge badge-danger" style="font-size:0.7rem">已下架</span></c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/goods/info?goodsId=${goods.id}" style="color:var(--text-primary);text-decoration:none"><c:out value="${goods.name}" /></a>
                            </div>
                                <div style="font-size:0.78rem;color:var(--text-secondary);margin-top:4px">
                                    卖家：<c:choose><c:when test="${not empty userMap[goods.producterId].name}"><c:out value="${userMap[goods.producterId].name}" /></c:when><c:otherwise><c:out value="${userMap[goods.producterId].email}" /></c:otherwise></c:choose>
                                    · <fmt:formatDate value="${goods.createDate}" pattern="yyyy-MM-dd" />
                                </div>
                            </div>
                            <div class="item-price">¥${goods.price}</div>
                        </div>
                        <div style="display:flex;align-items:flex-end;gap:8px">
                            <c:if test="${goods.status == 2}">
                                <form action="${pageContext.request.contextPath}/OrderCheckServlet" method="post" style="margin:0">
                                    <input type="hidden" name="goodsId" value="${goods.id}">
                                    <button type="submit" class="btn btn-primary btn-sm"><i data-lucide="shopping-bag" class="icon-sm"></i> 购买</button>
                                </form>
                            </c:if>
                            <button class="btn btn-danger btn-sm" onclick="removeFromCart(${goods.id}, this)"><i data-lucide="trash-2" class="icon-sm"></i> 移除</button>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="cart-summary" id="cartSummary">
                <div><span style="color:var(--text-secondary)">合计：</span><span id="totalPrice" style="font-size:1.4rem;font-weight:700;color:var(--danger)">计算中...</span></div>
                <button class="btn btn-primary btn-lg" id="buyAllBtn" onclick="buyAll(this)"><i data-lucide="check" class="icon"></i> 全部购买</button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state"><div class="empty-icon"><i data-lucide="shopping-cart" style="width:56px;height:56px;color:var(--text-light)"></i></div><h3>购物车是空的</h3><a href="${pageContext.request.contextPath}/index" class="btn btn-primary">去逛逛</a></div>
        </c:otherwise>
    </c:choose>

    <c:if test="${total > 0}">
    <div class="pagination" style="margin-top:var(--space-xl)">
        <a href="${pageContext.request.contextPath}/shopcart?pn=${pn > 1 ? pn-1 : 1}&sort=${sort}" class="page-btn ${pn <= 1 ? 'disabled' : ''}">&#8249;</a>
        <c:forEach begin="1" end="${maxPage}" var="i">
            <a href="${pageContext.request.contextPath}/shopcart?pn=${i}&sort=${sort}" class="page-btn ${i == pn ? 'active' : ''}">${i}</a>
        </c:forEach>
        <a href="${pageContext.request.contextPath}/shopcart?pn=${pn < maxPage ? pn+1 : maxPage}&sort=${sort}" class="page-btn ${pn >= maxPage ? 'disabled' : ''}">&#8250;</a>
    </div>
    </c:if>

    </main></div>
    <script>
(function(){
    var total = 0;
    document.querySelectorAll('.item-price').forEach(function(el){
        total += parseFloat(el.textContent.replace('¥',''));
    });
    var te = document.getElementById('totalPrice');
    if(te) te.textContent = '¥' + total.toFixed(2);
})();

function removeFromCart(goodsId, btn){
    if(btn){btn.disabled=true; btn.style.opacity='0.5';}
    SaltFish.ajax('RemoveShopCartServlet?goodsId='+goodsId, {
        callback: function(resp){
            if(btn){btn.disabled=false; btn.style.opacity='';}
            if(resp && resp.indexOf('success')>=0){
                var el = document.getElementById('cart-item-'+goodsId);
                if(el) el.remove();
                SaltFish.showToast('success','已移除');
                SaltFish.updateCartBadge();
                recalcTotal();
            } else {
                SaltFish.showToast('error','移除失败');
            }
        }
    });
}

function recalcTotal(){
    var t = 0;
    document.querySelectorAll('.item-price').forEach(function(el){
        t += parseFloat(el.textContent.replace('¥',''));
    });
    var tp = document.getElementById('totalPrice');
    if(tp) tp.textContent = '¥' + t.toFixed(2);
    if(document.querySelectorAll('.item-price').length === 0){
        var c = document.getElementById('cartItems');
        if(c) c.innerHTML = '<div class="empty-state"><h3>购物车是空的</h3></div>';
        var s = document.getElementById('cartSummary');
        if(s) s.style.display = 'none';
    }
}

function buyAll(btn){
    SaltFish.confirmDialog('确定购买购物车中的所有商品吗？', function(){
        if(btn){btn.disabled=true; btn.innerHTML='<span class="loading-spinner" style="width:16px;height:16px;border-width:2px;margin-right:6px"></span>购买中...';}
        SaltFish.ajax('BuyAllShopcartServlet', {
            callback: function(resp){
                if(btn){btn.disabled=false; btn.innerHTML='<i data-lucide="shopping-bag" class="icon-sm"></i> 全部购买'; if(typeof lucide!=='undefined') lucide.createIcons();}
                if(resp && resp.indexOf('success')>=0){
                    var parts = resp.split(',');
                    var s=parseInt(parts[1])||0, f=parseInt(parts[2])||0, su=parseInt(parts[3])||0, ss=parseInt(parts[4])||0;
                    var m='';
                    if(s>0) m+='成功购买 '+s+' 件。';
                    if(su>0) m+=su+' 件已下架。';
                    if(ss>0) m+=ss+' 件已跳过。';
                    if(f>0) m+=f+' 件失败。';
                    document.getElementById('cartItems').innerHTML='<div class="empty-state"><div class="empty-icon"><i data-lucide="check-circle" style="width:56px;height:56px;color:var(--success)"></i></div><h3>购买完成！</h3><p>'+m+'</p></div>';
                    var sm=document.getElementById('cartSummary');
                    if(sm) sm.style.display='none';
                    if(typeof lucide!=='undefined') lucide.createIcons();
                    SaltFish.showToast('success', m);
                    SaltFish.updateCartBadge();
                } else if(resp==='购物车为空'){
                    SaltFish.showToast('warning','购物车是空的');
                } else if(resp==='login'){
                    SaltFish.showToast('warning','请先登录');
                    setTimeout(function(){location.href=SaltFish.path+'user/login.jsp';},1000);
                } else {
                    SaltFish.showToast('error','购买失败，请重试');
                }
            }
        });
    });
}
</script>
    <jsp:include page="/common/footer.jsp" />
</body>
</html>