package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.AnnouncementHandle;
import com.luna.saltfish.entity.Announcement;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

public class AdminAnnouncementController extends HttpServlet {
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
        AnnouncementHandle handle = new AnnouncementHandle();

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
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                if (title != null && !title.trim().isEmpty() && content != null && !content.trim().isEmpty()) {
                    handle.doUpdate(id, title.trim(), content.trim());
                    response.setContentType("text/plain; charset=UTF-8");
                    response.getWriter().print("success");
                } else {
                    response.setContentType("text/plain; charset=UTF-8");
                    response.getWriter().print("error");
                }
                return;
            }

            List<Announcement> list = handle.findAll();
            request.setAttribute("announcementList", list);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/announcements.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) return;

        // AJAX edit comes as POST with action=edit in query string
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            doGet(request, response);
            return;
        }

        // Regular form submission — create announcement
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        User admin = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);

        if (title != null && !title.trim().isEmpty() && content != null && !content.trim().isEmpty()) {
            try {
                AnnouncementHandle handle = new AnnouncementHandle();
                Announcement a = new Announcement();
                a.setTitle(title.trim());
                a.setContent(content.trim());
                a.setAdminId(admin.getId());
                a.setIsActive(true);
                a.setCreateTime(new Date());
                handle.doCreate(a);
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().print("success");
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().print("error");
            }
        } else {
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().print("error");
        }
    }
}
