package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.MessHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Mess;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.util.PageResult;
import com.luna.saltfish.service.LoginVerify;
import com.luna.saltfish.util.StaticVar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 消息控制器
 */
public class MessController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
        request.setAttribute("viewUser", me);
        request.setAttribute("isMe", true);
        UserHandle userHandle = new UserHandle();
        MessHandle messHandle = new MessHandle();

        String handle = request.getParameter("handle");

        // 消息详情页
        if ("detail".equals(handle)) {
            try {
                int messId = Integer.parseInt(request.getParameter("messId"));
                Mess mess = messHandle.findById(messId, me.getId());
                if (mess == null) {
                    response.sendRedirect(request.getContextPath() + "/personal/mess");
                    return;
                }
                // 标记已读
                if (mess.getIsRead() == 0) {
                    messHandle.markAsRead(messId, me.getId());
                    mess.setIsRead(1);
                    // 更新 session 中的用户未读数
                    userHandle.emptyMessnum(me);
                }
                User sender = userHandle.findById(mess.getMessFromId());
                request.setAttribute("mess", mess);
                request.setAttribute("sender", sender);
                request.getRequestDispatcher("/site/personal/mess-detail.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/personal/mess");
                return;
            }
        }

        // 清除未读消息数
        try {
            userHandle.emptyMessnum(me);
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sort = request.getParameter("sort");
        if (sort == null || sort.isEmpty()) sort = "date_desc";
        request.setAttribute("sort", sort);

        int pn = 1;
        try {
            pn = Integer.parseInt(request.getParameter("pn"));
        } catch (Exception e) {
            // 默认第1页
        }
        if (pn < 1) pn = 1;
        int perPage = StaticVar.PERPAGE_MESS;
        int limitMin = (pn - 1) * perPage;

        try {
            PageResult count = new PageResult(0);
            List<Mess> messList = messHandle.findAllMessByUser(count, me, limitMin, perPage, sort);

            // N+1 优化：获取发送者信息
            Map<Integer, User> senderMap = new HashMap<>();
            for (Mess mess : messList) {
                int senderId = mess.getMessFromId();
                if (!senderMap.containsKey(senderId)) {
                    User sender = userHandle.findById(senderId);
                    if (sender != null) {
                        senderMap.put(senderId, sender);
                    }
                }
            }

            int total = count.value;
            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("messList", messList);
            request.setAttribute("senderMap", senderMap);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
            request.setAttribute("handle", handle);
            request.setAttribute("toemail", request.getParameter("toemail"));
            request.setAttribute("toname", request.getParameter("toname"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/site/personal/mess.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}