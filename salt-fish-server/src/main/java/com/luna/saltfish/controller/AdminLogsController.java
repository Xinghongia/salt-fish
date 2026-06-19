package com.luna.saltfish.controller;

import com.luna.saltfish.dao.AdminLogHandle;
import com.luna.saltfish.entity.AdminLog;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminLogsController extends HttpServlet {
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
        int perPage = 30;
        int limitMin = (pn - 1) * perPage;

        AdminLogHandle logHandle = new AdminLogHandle();

        try {
            List<AdminLog> logList = logHandle.findAll(limitMin, perPage);
            int total = logHandle.countAll();
            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("logList", logList);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/logs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
