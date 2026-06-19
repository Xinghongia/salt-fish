package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.MessHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Mess;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

public class MessCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        String toEmail = request.getParameter("InputEmailToSend");
        String toMess = request.getParameter("InputMess");
        User fromUser = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);

        if (toEmail != null) {
            toEmail = toEmail.split(" ")[0].trim();
        }

        if (toEmail == null || toEmail.isEmpty() || toMess == null || toMess.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/personal/mess?handle=write&info=" +
                java.net.URLEncoder.encode("请填写完整信息", "UTF-8"));
            return;
        }

        try {
            UserHandle userHandle = new UserHandle();
            User toUser = userHandle.findByEmail(toEmail);
            if (toUser == null) {
                response.sendRedirect(request.getContextPath() + "/personal/mess?handle=write&info=" +
                    java.net.URLEncoder.encode("用户不存在", "UTF-8"));
                return;
            }

            MessHandle messHandle = new MessHandle();
            Mess mess = new Mess();
            mess.setMessFromId(fromUser.getId());
            mess.setMessToId(toUser.getId());
            mess.setMessText(toMess.trim());
            mess.setSendTime(new Date());
            messHandle.doCreate(mess);

            response.sendRedirect(request.getContextPath() + "/personal/mess?info=" +
                java.net.URLEncoder.encode("消息已发送", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/personal/mess?handle=write&info=" +
                java.net.URLEncoder.encode("发送失败", "UTF-8"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}