package com.luna.saltfish.controller;

import com.luna.saltfish.dao.SystemSettingHandle;
import com.luna.saltfish.entity.SystemSetting;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminSettingsController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        SystemSettingHandle handle = new SystemSettingHandle();
        try {
            List<SystemSetting> settings = handle.findAll();
            request.setAttribute("settings", settings);
            request.setAttribute("siteName", handle.getValue("site_name"));
            request.setAttribute("siteDesc", handle.getValue("site_description"));
            request.setAttribute("perPageGoods", handle.getValue("perpage_goods"));
            request.setAttribute("maintenanceMode", handle.getValue("maintenance_mode"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        String msg = request.getParameter("msg");
        if (msg != null) request.setAttribute("msg", msg);

        request.getRequestDispatcher("/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return;
        }

        SystemSettingHandle handle = new SystemSettingHandle();
        try {
            String[] keys = {"site_name", "site_description", "perpage_goods", "maintenance_mode"};
            for (String key : keys) {
                String value = request.getParameter(key);
                if (value != null) {
                    handle.setValue(key, value.trim());
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/settings?msg=" +
                java.net.URLEncoder.encode("\u4fdd\u5b58\u6210\u529f", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/settings?msg=" +
                java.net.URLEncoder.encode("\u4fdd\u5b58\u5931\u8d25", "UTF-8"));
        }
    }
}