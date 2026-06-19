package com.luna.saltfish.controller;

import com.luna.saltfish.constant.GoodsStatusConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminGoodsController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        int pn = 1;
        try { pn = Integer.parseInt(request.getParameter("pn")); } catch (Exception e) {}
        if (pn < 1) pn = 1;
        int perPage = 20;
        int limitMin = (pn - 1) * perPage;

        String filter = request.getParameter("filter");

        GoodsHandle goodsHandle = new GoodsHandle();
        UserHandle userHandle = new UserHandle();

        try {
            List<Goods> goodsList;
            int total;

            if ("pending".equals(filter)) {
                goodsList = goodsHandle.findAllNotAuditing();
                total = goodsList.size();
            } else if ("active".equals(filter)) {
                goodsList = goodsHandle.findAllByStatus(GoodsStatusConstant.REVIEW_ED, limitMin, perPage);
                total = goodsHandle.countByStatus(GoodsStatusConstant.REVIEW_ED);
            } else if ("rejected".equals(filter)) {
                goodsList = goodsHandle.findAllByStatus(GoodsStatusConstant.REVIEW_FAIL, limitMin, perPage);
                total = goodsHandle.countByStatus(GoodsStatusConstant.REVIEW_FAIL);
            } else if ("trading".equals(filter)) {
                goodsList = goodsHandle.findAllByStatus(GoodsStatusConstant.TRADING, limitMin, perPage);
                total = goodsHandle.countByStatus(GoodsStatusConstant.TRADING);
            } else if ("sold".equals(filter)) {
                goodsList = goodsHandle.findAllByStatus(GoodsStatusConstant.COMPLETION, limitMin, perPage);
                total = goodsHandle.countByStatus(GoodsStatusConstant.COMPLETION);
            } else {
                goodsList = goodsHandle.findAllAdmin(limitMin, perPage);
                total = goodsHandle.countAll();
            }

            Map<Integer, User> userMap = new HashMap<>();
            for (Goods goods : goodsList) {
                if (goods.getProducterId() != null && !userMap.containsKey(goods.getProducterId())) {
                    User u = userHandle.findById(goods.getProducterId());
                    if (u != null) userMap.put(goods.getProducterId(), u);
                }
            }

            // Category filter
            String category = request.getParameter("category");
            if (category != null && !category.isEmpty() && goodsList != null) {
                try {
                    int catId = Integer.parseInt(category);
                    java.util.List<Goods> filtered = new java.util.ArrayList<>();
                    for (Goods g : goodsList) {
                        if (g.getTypeId() != null && g.getTypeId() == catId) filtered.add(g);
                    }
                    goodsList = filtered;
                    total = goodsList.size();
                } catch (Exception e) {}
            }

            // Load categories for filter dropdown
            try {
                CategoryHandle categoryHandle = new CategoryHandle();
                java.util.List<Category> categoryList = categoryHandle.findAll();
                request.setAttribute("categoryList", categoryList);
            } catch (Exception e) { e.printStackTrace(); }

            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("goodsList", goodsList);
            request.setAttribute("userMap", userMap);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
            request.setAttribute("filter", filter);
            request.setAttribute("category", category);

            // Status counts for filter pills
            request.setAttribute("pendingCount", goodsHandle.countByStatus(GoodsStatusConstant.PRE_VIEW));
            request.setAttribute("activeCount", goodsHandle.countByStatus(GoodsStatusConstant.REVIEW_ED));
            request.setAttribute("rejectedCount", goodsHandle.countByStatus(GoodsStatusConstant.REVIEW_FAIL));
            request.setAttribute("tradingCount", goodsHandle.countByStatus(GoodsStatusConstant.TRADING));
            request.setAttribute("soldCount", goodsHandle.countByStatus(GoodsStatusConstant.COMPLETION));
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/goods.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}