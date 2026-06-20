<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <jsp:include page="/common/head.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/admin.css?v=5">
    <title>数据统计 - 管理控制台</title>
</head>
<body>
    <jsp:include page="/common/header.jsp" />
    <div class="admin-layout">
        <jsp:include page="/common/admin-sidebar.jsp"><jsp:param name="active" value="dashboard"/></jsp:include>

        <main class="admin-content">
            <div class="admin-page-header">
                <h1><i data-lucide="bar-chart-3" class="icon-lg"></i> 数据统计</h1>
                <p>欢迎回来，管理员。以下是平台数据概览。</p>
            </div>

            <!-- Stats Grid -->
            <div class="admin-stats">
                <div class="admin-stat primary">
                    <div class="stat-icon primary"><i data-lucide="users" class="icon-lg"></i></div>
                    <div class="stat-body">
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-label">注册用户</div>
                        <div class="stat-trend up"><i data-lucide="trending-up" style="width:14px;height:14px"></i> 近7天 +${recentUsers}</div>
                    </div>
                </div>
                <div class="admin-stat success">
                    <div class="stat-icon success"><i data-lucide="package" class="icon-lg"></i></div>
                    <div class="stat-body">
                        <div class="stat-value">${totalGoods}</div>
                        <div class="stat-label">总商品数</div>
                        <div class="stat-trend up"><i data-lucide="trending-up" style="width:14px;height:14px"></i> 近7天 +${recentGoods}</div>
                    </div>
                </div>
                <div class="admin-stat warning">
                    <div class="stat-icon warning"><i data-lucide="clock" class="icon-lg"></i></div>
                    <div class="stat-body">
                        <div class="stat-value">${pendingGoods}</div>
                        <div class="stat-label">待审核</div>
                    </div>
                </div>
                <div class="admin-stat info">
                    <div class="stat-icon info"><i data-lucide="banknote" class="icon-lg"></i></div>
                    <div class="stat-body">
                        <div class="stat-value">${totalOrders}</div>
                        <div class="stat-label">总订单</div>
                        <div class="stat-trend up"><i data-lucide="trending-up" style="width:14px;height:14px"></i> 近7天 +${recentOrders}</div>
                    </div>
                </div>
                <div class="admin-stat success">
                    <div class="stat-icon success"><i data-lucide="check-circle" class="icon-lg"></i></div>
                    <div class="stat-body">
                        <div class="stat-value">${activeGoods}</div>
                        <div class="stat-label">在售商品</div>
                    </div>
                </div>
                <div class="admin-stat danger">
                    <div class="stat-icon danger"><i data-lucide="megaphone" class="icon-lg"></i></div>
                    <div class="stat-body">
                        <div class="stat-value">${totalAnnouncements}</div>
                        <div class="stat-label">系统公告</div>
                    </div>
                </div>
            </div>

            <!-- Charts -->
            <div class="admin-chart-grid">
                <div class="chart-container">
                    <h3><i data-lucide="pie-chart" class="icon-sm"></i> 商品状态分布</h3>
                    <div class="chart-wrapper">
                        <canvas id="goodsChart"></canvas>
                    </div>
                </div>
                <div class="chart-container">
                    <h3><i data-lucide="trending-up" class="icon-sm"></i> 近7天趋势</h3>
                    <div class="chart-wrapper">
                        <canvas id="trendChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Top Goods -->
            <c:if test="${not empty topCollectedGoods}">
            <div class="admin-recent-section">
                <h3><i data-lucide="star" class="icon-sm"></i> 热门商品（收藏最多）</h3>
                <c:forEach var="tg" items="${topCollectedGoods}" varStatus="idx">
                    <div class="recent-item">
                        <div class="recent-icon" style="background:#fef3c7;color:#f59e0b">${idx.index + 1}</div>
                        <div class="recent-body">
                            <div class="recent-title"><c:out value="${tg.name}" /></div>
                            <div class="recent-time">&yen;${tg.price}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            </c:if>

            <!-- Quick Actions -->
            <div class="admin-page-header">
                <h1 style="font-size:1.15rem"><i data-lucide="zap" class="icon"></i> 快捷操作</h1>
            </div>
            <div class="admin-actions">
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/goods?filter=pending">
                    <div class="action-icon warning"><i data-lucide="search" class="icon-lg"></i></div>
                    <div>
                        <h3>审核商品</h3>
                        <p>查看并审核待发布的商品</p>
                    </div>
                </a>
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/goods">
                    <div class="action-icon primary"><i data-lucide="package" class="icon-lg"></i></div>
                    <div>
                        <h3>商品管理</h3>
                        <p>查看和管理所有商品</p>
                    </div>
                </a>
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/users">
                    <div class="action-icon info"><i data-lucide="users" class="icon-lg"></i></div>
                    <div>
                        <h3>用户管理</h3>
                        <p>查看和管理注册用户</p>
                    </div>
                </a>
                <a class="admin-action-card" href="${pageContext.request.contextPath}/admin/announcements">
                    <div class="action-icon success"><i data-lucide="megaphone" class="icon-lg"></i></div>
                    <div>
                        <h3>系统公告</h3>
                        <p>发布和管理平台公告</p>
                    </div>
                </a>
            </div>

            <!-- Recent Announcements -->
            <c:if test="${not empty announcements}">
                <div class="admin-recent-section">
                    <h3><i data-lucide="bell" class="icon-sm"></i> 最新公告</h3>
                    <c:forEach var="ann" items="${announcements}" end="4">
                        <div class="recent-item">
                            <div class="recent-icon" style="background:#eef2ff;color:#6366f1">
                                <i data-lucide="megaphone" style="width:18px;height:18px"></i>
                            </div>
                            <div class="recent-body">
                                <div class="recent-title"><c:out value="${ann.title}" /></div>
                                <div class="recent-time"><c:out value="${ann.content}" /></div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="${pageContext.request.contextPath}/src/js/admin.js?v=6" charset="UTF-8"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Goods Status Doughnut
        var ctx1 = document.getElementById('goodsChart');
        if (ctx1) {
            new Chart(ctx1, {
                type: 'doughnut',
                data: {
                    labels: ['待审核', '在售', '已拒绝', '交易中', '已售出'],
                    datasets: [{
                        data: [${pendingGoods}, ${activeGoods}, 0, ${soldGoods}, ${completedGoods}],
                        backgroundColor: ['#f59e0b', '#10b981', '#ef4444', '#06b6d4', '#64748b'],
                        borderWidth: 0,
                        hoverOffset: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { padding: 16, usePointStyle: true, pointStyleWidth: 10, font: { size: 13 } }
                        }
                    },
                    cutout: '65%'
                }
            });
        }

        // 7-Day Trend Line Chart
        var ctx2 = document.getElementById('trendChart');
        if (ctx2) {
            var today = new Date();
            var labels = [];
            for (var i = 6; i >= 0; i--) {
                var d = new Date(today);
                d.setDate(d.getDate() - i);
                labels.push((d.getMonth()+1) + '/' + d.getDate());
            }
            var du = [${dailyUsers[0]}, ${dailyUsers[1]}, ${dailyUsers[2]}, ${dailyUsers[3]}, ${dailyUsers[4]}, ${dailyUsers[5]}, ${dailyUsers[6]}];
            var dg = [${dailyGoods[0]}, ${dailyGoods[1]}, ${dailyGoods[2]}, ${dailyGoods[3]}, ${dailyGoods[4]}, ${dailyGoods[5]}, ${dailyGoods[6]}];
            var dor = [${dailyOrders[0]}, ${dailyOrders[1]}, ${dailyOrders[2]}, ${dailyOrders[3]}, ${dailyOrders[4]}, ${dailyOrders[5]}, ${dailyOrders[6]}];
            new Chart(ctx2, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        { label: '\u7528\u6237', data: du, borderColor: '#6366f1', backgroundColor: 'rgba(99,102,241,0.08)', tension: 0.4, fill: true, pointRadius: 4 },
                        { label: '\u5546\u54c1', data: dg, borderColor: '#10b981', backgroundColor: 'rgba(16,185,129,0.08)', tension: 0.4, fill: true, pointRadius: 4 },
                        { label: '\u8ba2\u5355', data: dor, borderColor: '#f59e0b', backgroundColor: 'rgba(245,158,11,0.08)', tension: 0.4, fill: true, pointRadius: 4 }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom', labels: { padding: 16, usePointStyle: true, font: { size: 12 } } } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#f1f5f9' }, ticks: { font: { size: 12 }, stepSize: 1 } },
                        x: { grid: { display: false }, ticks: { font: { size: 12 } } }
                    }
                }
            });
        }
    });
    </script>
</body>
</html>
