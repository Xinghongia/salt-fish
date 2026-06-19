package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 发布商品页面控制器
 */
public class PushController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        request.setAttribute("viewUser", me);
        request.setAttribute("isMe", true);

        // info 参数来自成功重定向: /push?info=xxx
        if (request.getParameter("info") != null) {
            request.setAttribute("info", request.getParameter("info"));
        }

        // 从数据库加载分类列表
        try {
            CategoryHandle categoryHandle = new CategoryHandle();
            List<Category> categoryList = categoryHandle.findAllActive();
            request.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/site/personal/push.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}