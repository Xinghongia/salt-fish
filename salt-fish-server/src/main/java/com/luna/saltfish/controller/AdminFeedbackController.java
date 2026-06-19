package com.luna.saltfish.controller;

import com.luna.saltfish.dao.FeedbackHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Feedback;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminFeedbackController extends HttpServlet {
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

        FeedbackHandle feedbackHandle = new FeedbackHandle();
        UserHandle userHandle = new UserHandle();

        String filter = request.getParameter("filter");

        try {
            List<Feedback> feedbackList;
            int total;

            if ("bug".equals(filter) || "feature".equals(filter) || "improve".equals(filter)) {
                feedbackList = feedbackHandle.findByType(filter, limitMin, perPage);
                total = feedbackHandle.countByType(filter);
            } else {
                feedbackList = feedbackHandle.findAll(limitMin, perPage);
                total = feedbackHandle.countAll();
            }

            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            Map<Integer, User> userMap = new HashMap<>();
            for (Feedback f : feedbackList) {
                if (f.getUserId() != null && !userMap.containsKey(f.getUserId())) {
                    User u = userHandle.findById(f.getUserId());
                    if (u != null) userMap.put(f.getUserId(), u);
                }
            }

            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("userMap", userMap);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
            request.setAttribute("filter", filter);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
