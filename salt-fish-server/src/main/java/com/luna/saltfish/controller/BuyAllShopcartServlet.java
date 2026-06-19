package com.luna.saltfish.controller;

import com.luna.saltfish.constant.GoodsStatusConstant;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.OrderHandle;
import com.luna.saltfish.dao.ShopCartHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Order;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

public class BuyAllShopcartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");

        if (!LoginVerify.isLogin(request)) {
            response.getWriter().print("login");
            return;
        }

        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        ShopCartHandle shopCartHandle = new ShopCartHandle();

        try {
            List<Goods> list = shopCartHandle.findGoodsByUser(user);
            if (list == null || list.isEmpty()) {
                response.getWriter().print("购物车为空");
                return;
            }

            OrderHandle orderHandle = new OrderHandle();
            GoodsHandle goodsHandle = new GoodsHandle();
            int success = 0;
            int fail = 0;
            int skippedUnavailable = 0;
            int skippedSelf = 0;

            for (Goods goods : list) {
                // 跳过不在售的商品（已被购买/下架），自动清理购物车
                if (goods.getStatus() == null || !goods.getStatus().equals(GoodsStatusConstant.REVIEW_ED)) {
                    shopCartHandle.removeList(goods.getId(), user.getId());
                    skippedUnavailable++;
                    continue;
                }

                // 跳过自己的商品
                if (goods.getProducterId() != null && goods.getProducterId().equals(user.getId())) {
                    shopCartHandle.removeList(goods.getId(), user.getId());
                    skippedSelf++;
                    continue;
                }

                // 原子更新状态：仅当状态为在售(2)时才允许购买
                boolean locked = goodsHandle.updateStatusIfMatch(goods.getId(), GoodsStatusConstant.TRADING, GoodsStatusConstant.REVIEW_ED);
                if (locked) {
                    Order order = new Order();
                    order.setGoodsId(goods.getId());
                    order.setUserId(user.getId());
                    order.setMessage("通过购物车批量购买");
                    order.setDate(new Date());
                    try {
                        orderHandle.doCreate(order);
                        shopCartHandle.removeList(goods.getId(), user.getId());
                        success++;
                    } catch (Exception e) {
                        fail++;
                    }
                } else {
                    // 状态已被其他人改变，清理购物车
                    shopCartHandle.removeList(goods.getId(), user.getId());
                }
            }

            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print("success," + success + "," + fail + "," + skippedUnavailable + "," + skippedSelf);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doGet(request, response);
    }
}
