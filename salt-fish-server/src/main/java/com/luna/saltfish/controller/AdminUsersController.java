package com.luna.saltfish.controller;

import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 管理员用户管理
 */
public class AdminUsersController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        int pn = 1;
        try { pn = Integer.parseInt(request.getParameter("pn")); } catch (Exception e) {}
        if (pn < 1) pn = 1;
        int perPage = 20;
        int limitMin = (pn - 1) * perPage;

        String keyword = request.getParameter("keyword");

        UserHandle userHandle = new UserHandle();

        try {
            List<User> userList;
            int total;

            if (keyword != null && !keyword.trim().isEmpty()) {
                userList = userHandle.findAll(keyword.trim());
                total = userList.size();
            } else {
                userList = userHandle.findAll(limitMin, perPage);
                total = userHandle.countAll();
            }

            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("userList", userList);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
            request.setAttribute("keyword", keyword);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}