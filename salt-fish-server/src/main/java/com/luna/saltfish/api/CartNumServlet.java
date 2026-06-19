package com.luna.saltfish.api;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.ShopCartHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CartNumServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");

        if (!LoginVerify.isLogin(request)) {
            response.getWriter().print("0");
            return;
        }

        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        try {
            ShopCartHandle shopCartHandle = new ShopCartHandle();
            int num = shopCartHandle.getShopCartNum(user.getId());
            response.getWriter().print(num);
        } catch (Exception e) {
            response.getWriter().print("0");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}