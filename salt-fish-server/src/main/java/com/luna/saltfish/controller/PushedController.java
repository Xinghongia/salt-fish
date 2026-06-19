package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 已发布商品控制器
 */
public class PushedController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User me = null;
        if (LoginVerify.isLogin(request)) {
            me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        }

        String userIdStr = request.getParameter("userId");
        User viewUser = me;
        boolean isMe = true;

        if (userIdStr != null && !userIdStr.isEmpty() && me != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                if (userId != me.getId()) {
                    UserHandle userHandle = new UserHandle();
                    viewUser = userHandle.findById(userId);
                    isMe = false;
                    if (viewUser == null) {
                        viewUser = me;
                        isMe = true;
                    }
                }
            } catch (Exception e) {
                // 忽略
            }
        }

        if (viewUser != null) {
            try {
                GoodsHandle goodsHandle = new GoodsHandle();
                List<Goods> goodsList = goodsHandle.findByUserId(viewUser.getId());

                // N+1 优化
                UserHandle userHandle = new UserHandle();
                Map<Integer, User> userMap = new HashMap<>();
                for (Goods goods : goodsList) {
                    if (goods.getProducterId() != null && !userMap.containsKey(goods.getProducterId())) {
                        User u = userHandle.findById(goods.getProducterId());
                        if (u != null) {
                            userMap.put(goods.getProducterId(), u);
                        }
                    }
                }

                request.setAttribute("goodsList", goodsList);
                request.setAttribute("userMap", userMap);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("viewUser", viewUser);
        request.setAttribute("isMe", isMe);
        request.getRequestDispatcher("/site/personal/pushed.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
