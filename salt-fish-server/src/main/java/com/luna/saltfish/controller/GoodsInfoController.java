package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.OrderHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Order;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;

public class GoodsInfoController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String goodsIdStr = request.getParameter("goodsId");
        if (goodsIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/index?ceta=0");
            return;
        }

        try {
            int goodsId = Integer.parseInt(goodsIdStr);
            GoodsHandle goodsHandle = new GoodsHandle();
            UserHandle userHandle = new UserHandle();

            Goods goods = goodsHandle.findById(goodsId);
            if (goods == null) {
                request.setAttribute("errorMsg", "商品不存在");
                request.getRequestDispatcher("/error_404.jsp").forward(request, response);
                return;
            }

            User producer = null;
            if (goods.getProducterId() != null) {
                producer = userHandle.findById(goods.getProducterId());
            }

            // 从数据库加载分类名称
            String typeName = "";
            if (goods.getTypeId() != null) {
                try {
                    CategoryHandle categoryHandle = new CategoryHandle();
                    Category cat = categoryHandle.findById(goods.getTypeId());
                    if (cat != null) {
                        typeName = cat.getName();
                    }
                } catch (Exception ce) {
                    ce.printStackTrace();
                }
            }

            boolean canBuy = goods.getStatus() == 2;
            boolean isSold = goods.getStatus() == 4 || goods.getStatus() == 5;
            boolean isRejected = goods.getStatus() == 3;

            // Check if current user is the seller
            boolean isSeller = false;
            boolean isBuyer = false;
            Order order = null;
            if (LoginVerify.isLogin(request)) {
                User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
                if (goods.getProducterId() != null && goods.getProducterId().equals(me.getId())) {
                    isSeller = true;
                }
                // Check if current user is the buyer (has an order for this goods)
                if (goods.getStatus() == 4) {
                    OrderHandle orderHandle = new OrderHandle();
                    order = orderHandle.findByGoodsId(goodsId);
                    if (order != null && order.getUserId() == me.getId()) {
                        isBuyer = true;
                    }
                }
            }

            request.setAttribute("goods", goods);
            request.setAttribute("producer", producer);
            request.setAttribute("typeName", typeName);
            request.setAttribute("canBuy", canBuy);
            request.setAttribute("isSold", isSold);
            request.setAttribute("isRejected", isRejected);
            request.setAttribute("isSeller", isSeller);
            request.setAttribute("isBuyer", isBuyer);
            request.setAttribute("order", order);
            request.setAttribute("info", request.getParameter("info"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index?ceta=0");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/goods/info.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}