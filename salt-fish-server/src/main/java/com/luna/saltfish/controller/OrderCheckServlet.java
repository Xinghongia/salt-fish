package com.luna.saltfish.controller;


import com.luna.saltfish.constant.GoodsStatusConstant;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.MessHandle;
import com.luna.saltfish.dao.OrderHandle;
import com.luna.saltfish.dao.ShopCartHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Mess;
import com.luna.saltfish.entity.Order;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

/**
 * @author luna@mac
 */
public class OrderCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public OrderCheckServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取来源URL，处理null Referer
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isEmpty()) {
            referer = request.getContextPath() + "/index";
        }
        String fromUrl = referer.split("&")[0];

        // 检查登录状态
        if (!LoginVerify.isLogin(request)) {
            String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("请先登录", "UTF-8"));
            return;
        }

        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);

        // 解析参数
        int goodsId;
        try {
            goodsId = Integer.parseInt(request.getParameter("goodsId"));
        } catch (NumberFormatException e) {
            String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("参数错误", "UTF-8"));
            return;
        }

        String messageToSeller = request.getParameter("message-to-seller");

        try {
            GoodsHandle goodsHandle = new GoodsHandle();
            Goods goods = goodsHandle.findById(goodsId);

            // 商品不存在
            if (goods == null) {
                String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("商品不存在", "UTF-8"));
                return;
            }

            // 不能购买自己的商品
            if (goods.getProducterId() != null && goods.getProducterId().equals(user.getId())) {
                String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("不能购买自己的商品", "UTF-8"));
                return;
            }

            // 原子更新状态：仅当状态为在售(2)时才允许购买
            boolean locked = goodsHandle.updateStatusIfMatch(goodsId, GoodsStatusConstant.TRADING, GoodsStatusConstant.REVIEW_ED);
            if (!locked) {
                String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("商品已被他人购买或已下架", "UTF-8"));
                return;
            }

            // 创建订单
            OrderHandle orderHandle = new OrderHandle();
            Order order = new Order();
            order.setGoodsId(goodsId);
            order.setUserId(user.getId());
            order.setMessage(messageToSeller);
            order.setDate(new Date());
            orderHandle.doCreate(order);
            // 购买成功后从购物车移除
            try { new ShopCartHandle().removeList(goodsId, user.getId()); } catch (Exception ignored) {}

            // 发送站内信通知卖家
            try {
                MessHandle messHandle = new MessHandle();
                Mess mess = new Mess();
                mess.setMessFromId(user.getId());
                mess.setMessToId(goods.getProducterId());
                String buyerName = (user.getName() != null && !user.getName().isEmpty()) ? user.getName() : user.getEmail();
                String notifyText = "\u3010\u8d2d\u4e70\u901a\u77e5\u3011\u7528\u6237 " + buyerName + " \u8d2d\u4e70\u4e86\u4f60\u7684\u5546\u54c1\u300c" + goods.getName() + "\u300d\uff0c\u8bf7\u53ca\u65f6\u786e\u8ba4\u4ea4\u6613\u3002" + (messageToSeller != null && !messageToSeller.trim().isEmpty() ? "\u4e70\u5bb6\u7559\u8a00\uff1a" + messageToSeller : "");
                mess.setMessText(notifyText);
                mess.setSendTime(new Date());
                messHandle.doCreate(mess);
            } catch (Exception msgEx) {
                msgEx.printStackTrace();
            }

            String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("\u8d2d\u4e70\u6210\u529f\uff0c\u5df2\u901a\u77e5\u5356\u5bb6", "UTF-8"));

        } catch (Exception e) {
            e.printStackTrace();
            String sep = fromUrl.contains("?") ? "&" : "?"; response.sendRedirect(fromUrl + sep + "info=" + java.net.URLEncoder.encode("购买失败，请重试", "UTF-8"));
        }
    }
}
