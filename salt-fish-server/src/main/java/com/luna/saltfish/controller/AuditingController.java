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
 * 管理员审核控制器
 */
public class AuditingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index?ceta=0");
            return;
        }

        User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        request.setAttribute("viewUser", me);
        request.setAttribute("isMe", true);

        try {
            GoodsHandle goodsHandle = new GoodsHandle();
            UserHandle userHandle = new UserHandle();
            List<Goods> goodsList = goodsHandle.findAllNotAuditing();

            // N+1 优化
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

        request.getRequestDispatcher("/site/personal/auditing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
