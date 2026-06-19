package com.luna.saltfish.api;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.MessHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class MessNumServlet extends HttpServlet {
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
            MessHandle messHandle = new MessHandle();

            // POST: markAllRead
            String action = request.getParameter("action");
            if ("markAllRead".equals(action)) {
                messHandle.markAllAsRead(user.getId());
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().print("success");
                return;
            }

            int num = messHandle.countUnread(user.getId());
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