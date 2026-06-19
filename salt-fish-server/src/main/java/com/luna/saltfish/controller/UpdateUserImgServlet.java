package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;

@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class UpdateUserImgServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        UserHandle userHandle = new UserHandle();
        try { user = userHandle.findById(user.getId()); }
        catch (Exception e) { e.printStackTrace(); }

        Part part = request.getPart("file");
        if (part == null || part.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/personal/info?info=" + java.net.URLEncoder.encode("请选择文件", "UTF-8"));
            return;
        }

        String savePath = request.getServletContext().getRealPath("static/user_img");
        part.write(savePath + "/" + user.getId() + ".jpg");
        user.setImg("static/user_img/" + user.getId() + ".jpg");

        try {
            userHandle.doUpdate(user);
            // Refresh session user
            request.getSession().setAttribute(UserLoginConstant.LOGIN_USER, userHandle.findById(user.getId()));
            response.sendRedirect(request.getContextPath() + "/personal/info?info=" + java.net.URLEncoder.encode("头像更新成功", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/personal/info?info=" + java.net.URLEncoder.encode("更新失败", "UTF-8"));
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doGet(request, response);
    }
}