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

public class UpdateUserInfoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String getNotNullParameter(HttpServletRequest request, String s) {
        return request.getParameter(s) == null ? "" : request.getParameter(s);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        String name = getNotNullParameter(request, "name");
        String phone = getNotNullParameter(request, "phone");
        String stuNum = getNotNullParameter(request, "stuNum");
        String qq = getNotNullParameter(request, "qq");
        String password = getNotNullParameter(request, "password");
        String verify = getNotNullParameter(request, "verify");
        String info;

        if (password.length() > 0) {
            if (password.equals(verify) && password.matches("[A-Za-z0-9]{6,}")) {
                user.setPwd(MD5.getMD5(MD5.getMD5(password)));
            } else {
                info = "密码不一致或格式错误";
                response.sendRedirect(request.getContextPath() + "/personal/info?info=" + java.net.URLEncoder.encode(info, "UTF-8"));
                return;
            }
        }

        if (name.length() > 0 && (phone.matches("^[0-9]*$") || phone.length() == 0)) {
            user.setName(name);
            user.setPhone(phone);
            user.setStuNum(stuNum);
            user.setQq(qq);
            try {
                UserHandle userHandle = new UserHandle();
                if (userHandle.doUpdate(user)) {
                    info = "更新成功";
                } else {
                    info = "更新失败";
                }
            } catch (Exception e) {
                info = "数据库错误";
                e.printStackTrace();
            }
        } else {
            info = "请检查输入";
        }

        response.sendRedirect(request.getContextPath() + "/personal/info?info=" + java.net.URLEncoder.encode(info, "UTF-8"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}