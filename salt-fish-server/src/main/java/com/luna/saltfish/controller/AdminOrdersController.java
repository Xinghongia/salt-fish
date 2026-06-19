package com.luna.saltfish.controller;

import com.luna.saltfish.constant.GoodsStatusConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.OrderHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Order;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;
import com.luna.saltfish.util.PageResult;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class AdminOrdersController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        String filter = request.getParameter("filter");
        int pn = 1;
        try { pn = Integer.parseInt(request.getParameter("pn")); } catch (Exception e) {}
        if (pn < 1) pn = 1;
        int perPage = 15;
        int limitMin = (pn - 1) * perPage;

        try {
            OrderHandle orderHandle = new OrderHandle();
            GoodsHandle goodsHandle = new GoodsHandle();
            UserHandle userHandle = new UserHandle();

            List<Order> orderList;
            int total;

            if ("trading".equals(filter)) {
                total = orderHandle.countByGoodsStatus(GoodsStatusConstant.TRADING);
                orderList = orderHandle.findByStatusPaged(GoodsStatusConstant.TRADING, limitMin, perPage);
            } else if ("completed".equals(filter)) {
                total = orderHandle.countByGoodsStatus(GoodsStatusConstant.COMPLETION);
                orderList = orderHandle.findByStatusPaged(GoodsStatusConstant.COMPLETION, limitMin, perPage);
            } else {
                total = orderHandle.countAll();
                orderList = orderHandle.findAllPaged(limitMin, perPage);
            }

            Map<Integer, Goods> goodsMap = new HashMap<>();
            Map<Integer, User> buyerMap = new HashMap<>();
            Map<Integer, User> sellerMap = new HashMap<>();

            for (Order order : orderList) {
                if (!goodsMap.containsKey(order.getGoodsId())) {
                    Goods g = goodsHandle.findById(order.getGoodsId());
                    if (g != null) goodsMap.put(order.getGoodsId(), g);
                }
                if (!buyerMap.containsKey(order.getUserId())) {
                    User u = userHandle.findById(order.getUserId());
                    if (u != null) buyerMap.put(order.getUserId(), u);
                }
                Goods g = goodsMap.get(order.getGoodsId());
                if (g != null && g.getProducterId() != null && !sellerMap.containsKey(g.getProducterId())) {
                    User s = userHandle.findById(g.getProducterId());
                    if (s != null) sellerMap.put(g.getProducterId(), s);
                }
            }

            int tradingCount = orderHandle.countByGoodsStatus(GoodsStatusConstant.TRADING);
            int completedCount = orderHandle.countByGoodsStatus(GoodsStatusConstant.COMPLETION);

            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("orderList", orderList);
            request.setAttribute("goodsMap", goodsMap);
            request.setAttribute("buyerMap", buyerMap);
            request.setAttribute("sellerMap", sellerMap);
            request.setAttribute("filter", filter);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
            request.setAttribute("tradingCount", tradingCount);
            request.setAttribute("completedCount", completedCount);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}