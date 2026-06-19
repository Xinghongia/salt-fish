package com.luna.saltfish.controller;

import com.luna.saltfish.constant.GoodsStatusConstant;
import com.luna.saltfish.dao.*;
import com.luna.saltfish.entity.Announcement;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        GoodsHandle goodsHandle = new GoodsHandle();
        UserHandle userHandle = new UserHandle();
        OrderHandle orderHandle = new OrderHandle();
        AnnouncementHandle annHandle = new AnnouncementHandle();
        FeedbackHandle feedbackHandle = new FeedbackHandle();

        try {
            int totalUsers = userHandle.countAll();
            int totalGoods = goodsHandle.countAll();
            int pendingGoods = goodsHandle.countByStatus(GoodsStatusConstant.PRE_VIEW);
            int activeGoods = goodsHandle.countByStatus(GoodsStatusConstant.REVIEW_ED);
            int soldGoods = goodsHandle.countByStatus(GoodsStatusConstant.TRADING);
            int completedGoods = goodsHandle.countByStatus(GoodsStatusConstant.COMPLETION);
            int totalOrders = orderHandle.countAll();
            int totalAnnouncements = annHandle.countAll();
            int totalFeedback = feedbackHandle.countAll();

            int recentUsers = userHandle.countRecent(7);
            int recentGoods = goodsHandle.countRecent(7);
            int recentOrders = orderHandle.countRecent(7);

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalGoods", totalGoods);
            request.setAttribute("pendingGoods", pendingGoods);
            request.setAttribute("activeGoods", activeGoods);
            request.setAttribute("soldGoods", soldGoods);
            request.setAttribute("completedGoods", completedGoods);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalAnnouncements", totalAnnouncements);
            request.setAttribute("totalFeedback", totalFeedback);
            request.setAttribute("recentUsers", recentUsers);
            request.setAttribute("recentGoods", recentGoods);
            request.setAttribute("recentOrders", recentOrders);

            // Chart data (7-day trend)
            // 7-day daily trend
            int[] dailyUsers = userHandle.dailyCounts(7);
            int[] dailyGoods = goodsHandle.dailyCounts(7);
            int[] dailyOrders = orderHandle.dailyCounts(7);
            request.setAttribute("dailyUsers", dailyUsers);
            request.setAttribute("dailyGoods", dailyGoods);
            request.setAttribute("dailyOrders", dailyOrders);

            // Top collected goods
            try {
                request.setAttribute("topCollectedGoods", goodsHandle.findTopByCollected(5));
            } catch (Exception e) { /* table may not exist */ }

            // Recent announcements
            List<Announcement> announcements = annHandle.findActive();
            request.setAttribute("announcements", announcements);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
