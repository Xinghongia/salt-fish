package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;
import com.luna.saltfish.util.MD5;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        String confirmPwd = request.getParameter("confirmPwd");

        if (oldPwd == null || oldPwd.trim().isEmpty() ||
            newPwd == null || newPwd.trim().isEmpty() ||
            confirmPwd == null || confirmPwd.trim().isEmpty()) {
            redirectWithError(request, response, "请填写完整");
            return;
        }

        if (newPwd.trim().length() < 6) {
            redirectWithError(request, response, "新密码至少6位");
            return;
        }

        if (!newPwd.trim().equals(confirmPwd.trim())) {
            redirectWithError(request, response, "两次密码不一致");
            return;
        }

        User sessionUser = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        UserHandle userHandle = new UserHandle();
        try {
            User user = userHandle.findById(sessionUser.getId());
            if (user == null) {
                redirectWithError(request, response, "用户不存在");
                return;
            }

            if (!MD5.getMD5(MD5.getMD5(oldPwd.trim())).equals(user.getPwd())) {
                redirectWithError(request, response, "原密码错误");
                return;
            }

            if (userHandle.resetPassword(user.getId(), MD5.getMD5(MD5.getMD5(newPwd.trim())))) {
                response.sendRedirect(request.getContextPath() + "/personal/info?info=" +
                    java.net.URLEncoder.encode("密码修改成功", "UTF-8"));
            } else {
                redirectWithError(request, response, "修改失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(request, response, "系统错误");
        }
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String msg) throws IOException {
        response.sendRedirect(request.getContextPath() + "/personal/info?info=" +
            java.net.URLEncoder.encode(msg, "UTF-8"));
    }
}
