package com.luna.saltfish.controller;

import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminCategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!LoginVerify.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/index");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        CategoryHandle handle = new CategoryHandle();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                handle.doDelete(id);
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().print("success");
                return;
            }
            if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean active = Boolean.parseBoolean(request.getParameter("active"));
                handle.toggleActive(id, active);
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().print("success");
                return;
            }

            List<Category> list = handle.findAll();
            request.setAttribute("categoryList", list);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        String action = request.getParameter("action");
        CategoryHandle handle = new CategoryHandle();
        response.setContentType("text/plain; charset=UTF-8");

        try {
            if ("create".equals(action)) {
                String name = request.getParameter("name");
                String icon = request.getParameter("icon");
                String sortOrderStr = request.getParameter("sortOrder");
                if (name == null || name.trim().isEmpty()) {
                    response.getWriter().print("error:empty");
                    return;
                }
                Category c = new Category();
                c.setName(name.trim());
                c.setIcon(icon != null && !icon.trim().isEmpty() ? icon.trim() : "tag");
                c.setSortOrder(sortOrderStr != null && !sortOrderStr.isEmpty() ? Integer.parseInt(sortOrderStr) : handle.getMaxSortOrder() + 1);
                c.setIsActive(true);
                handle.doCreate(c);
                response.getWriter().print("success");
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String icon = request.getParameter("icon");
                String sortOrderStr = request.getParameter("sortOrder");
                if (name == null || name.trim().isEmpty()) {
                    response.getWriter().print("error:empty");
                    return;
                }
                Category c = handle.findById(id);
                if (c == null) {
                    response.getWriter().print("error:notfound");
                    return;
                }
                c.setName(name.trim());
                c.setIcon(icon != null && !icon.trim().isEmpty() ? icon.trim() : "tag");
                c.setSortOrder(sortOrderStr != null && !sortOrderStr.isEmpty() ? Integer.parseInt(sortOrderStr) : c.getSortOrder());
                handle.doUpdate(c);
                response.getWriter().print("success");
            } else {
                response.getWriter().print("error:unknown");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("error:" + e.getMessage());
        }
    }
}