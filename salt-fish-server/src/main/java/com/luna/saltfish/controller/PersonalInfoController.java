package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 个人信息控制器
 */
public class PersonalInfoController extends HttpServlet {
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

        request.setAttribute("viewUser", viewUser);
        request.setAttribute("isMe", isMe);
        request.setAttribute("info", request.getParameter("info"));

        // 头像刷新用
        String cache = request.getParameter("cache");
        if ("0".equals(cache)) {
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
        }

        request.getRequestDispatcher("/site/personal/info.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
