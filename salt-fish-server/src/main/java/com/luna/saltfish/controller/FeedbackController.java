package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.FeedbackHandle;
import com.luna.saltfish.entity.Feedback;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

public class FeedbackController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        String type = request.getParameter("type");
        String content = request.getParameter("content");
        String contact = request.getParameter("contact");

        if (content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "请填写反馈内容");
            request.getRequestDispatcher("/feedback.jsp").forward(request, response);
            return;
        }

        try {
            FeedbackHandle handle = new FeedbackHandle();
            Feedback f = new Feedback();
            f.setUserId(user.getId());
            f.setType(type != null ? type : "other");
            f.setContent(content.trim());
            f.setContact(contact != null ? contact.trim() : "");
            f.setCreateTime(new Date());
            handle.doCreate(f);
            request.setAttribute("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "提交失败，请稍后重试");
        }

        request.getRequestDispatcher("/feedback.jsp").forward(request, response);
    }
}