package com.luna.saltfish.controller;

import com.luna.saltfish.constant.CookieNameConstant;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.SessionHandle;
import com.luna.saltfish.entity.User;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author luna@mac
 */
public class ExitLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ExitLoginServlet() {
        super();
    }

    /**
     * 退出登录，移除cookies和session属性
     * 
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 清除数据库中的session key
        User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        if (user != null) {
            try {
                new SessionHandle().deleteByUserId(user.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // 销毁session
        request.getSession().invalidate();
        // 清除cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (CookieNameConstant.LOGIN_EMAIL.equals(cookie.getName())) {
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/index");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
