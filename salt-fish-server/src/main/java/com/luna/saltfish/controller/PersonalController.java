package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.*;
import com.luna.saltfish.entity.*;
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
 * 个人中心路由控制器
 * 预加载 tab 数据，转发到对应的独立子页面
 */
public class PersonalController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!LoginVerify.isLogin(request)) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        UserHandle userHandle = new UserHandle();
        User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);

        String userIdStr = request.getParameter("userId");
        User viewUser = me;
        boolean isMe = true;

        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdStr);
                if (userId != me.getId()) {
                    viewUser = userHandle.findById(userId);
                    isMe = false;
                    if (viewUser == null) { viewUser = me; isMe = true; }
                }
            } catch (Exception e) {}
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) tab = "info";

        request.setAttribute("viewUser", viewUser);
        request.setAttribute("isMe", isMe);
        request.setAttribute("tab", tab);
        request.setAttribute("isAdmin", LoginVerify.isAdmin(request));

        try { loadTabData(request, viewUser, me, isMe, tab); }
        catch (Exception e) { e.printStackTrace(); }

        // 映射 tab 到独立子页面
        String target;
        switch (tab) {
            case "pushed":   target = "/site/personal/pushed.jsp"; break;
            case "shopcart": target = "/site/personal/shopcart.jsp"; break;
            case "like":     target = "/site/personal/like.jsp"; break;
            case "mess":     target = "/site/personal/mess.jsp"; break;
            case "history":  target = "/site/personal/history.jsp"; break;
            case "auditing": target = "/site/personal/auditing.jsp"; break;
            case "push":     target = "/site/personal/push.jsp"; break;
            default:         target = "/site/personal/info.jsp"; break;
        }
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void loadTabData(HttpServletRequest request, User viewUser, User me, boolean isMe, String tab)
            throws Exception {
        UserHandle userHandle = new UserHandle();

        switch (tab) {
            case "pushed": {
                GoodsHandle goodsHandle = new GoodsHandle();
                List<Goods> goodsList = goodsHandle.findByUserId(viewUser.getId());
                request.setAttribute("goodsList", goodsList);
                request.setAttribute("userMap", buildUserMap(goodsList, userHandle));
                break;
            }
            case "shopcart": {
                if (isMe) {
                    int pn = parseIntParam(request, "pn", 1);
                    int perPage = StaticVar.PERPAGE_CART;
                    int limitMin = (pn - 1) * perPage;
                    ShopCartHandle shopCartHandle = new ShopCartHandle();
                    int total = shopCartHandle.countByUser(me.getId());
                    String sort = request.getParameter("sort"); if (sort == null || sort.isEmpty()) sort = "date_desc"; List<Goods> goodsList = shopCartHandle.findGoodsByUserPaged(me, limitMin, perPage, sort); request.setAttribute("sort", sort);
                    request.setAttribute("goodsList", goodsList);
                    request.setAttribute("userMap", buildUserMap(goodsList, userHandle));
                    request.setAttribute("info", request.getParameter("info"));
                    int maxPage = Math.max(1, (total + perPage - 1) / perPage);
                    request.setAttribute("pn", pn);
                    request.setAttribute("maxPage", maxPage);
                    request.setAttribute("total", total);
                }
                break;
            }
            case "like": {
                if (isMe) {
                    int pn = parseIntParam(request, "pn", 1);
                    int perPage = StaticVar.PERPAGE_COLLECT;
                    int limitMin = (pn - 1) * perPage;
                    CollectHandle collectHandle = new CollectHandle();
                    PageResult count = new PageResult(0);
                    String sort = request.getParameter("sort"); if (sort == null || sort.isEmpty()) sort = "date_desc"; List<Goods> goodsList = collectHandle.findGoodsByUser(me, count, limitMin, perPage, sort); request.setAttribute("sort", sort);
                    request.setAttribute("goodsList", goodsList);
                    request.setAttribute("userMap", buildUserMap(goodsList, userHandle));
                    int total = count.value;
                    int maxPage = Math.max(1, (total + perPage - 1) / perPage);
                    request.setAttribute("pn", pn);
                    request.setAttribute("maxPage", maxPage);
                    request.setAttribute("total", total);
                }
                break;
            }
            case "mess": {
                if (isMe) {
                    userHandle.emptyMessnum(me);
                    int pn = parseIntParam(request, "pn", 1);
                    int perPage = StaticVar.PERPAGE_MESS;
                    int limitMin = (pn - 1) * perPage;
                    MessHandle messHandle = new MessHandle();
                    PageResult count = new PageResult(0);
                    List<Mess> messList = messHandle.findAllMessByUser(count, me, limitMin, perPage, "date_desc");
                    Map<Integer, User> senderMap = new HashMap<>();
                    for (Mess mess : messList) {
                        int sid = mess.getMessFromId();
                        if (!senderMap.containsKey(sid)) {
                            User sender = userHandle.findById(sid);
                            if (sender != null) senderMap.put(sid, sender);
                        }
                    }
                    int total = count.value;
                    int maxPage = Math.max(1, (total + perPage - 1) / perPage);
                    request.setAttribute("messList", messList);
                    request.setAttribute("senderMap", senderMap);
                    request.setAttribute("pn", pn);
                    request.setAttribute("maxPage", maxPage);
                    request.setAttribute("total", total);
                    request.setAttribute("handle", request.getParameter("handle"));
                    request.setAttribute("toemail", request.getParameter("toemail"));
                    request.setAttribute("toname", request.getParameter("toname"));
                }
                break;
            }
            case "history": {
                if (isMe) {
                    int pn = parseIntParam(request, "pn", 1);
                    int perPage = StaticVar.PERPAGE_HISTORY;
                    int limitMin = (pn - 1) * perPage;
                    OrderHandle orderHandle = new OrderHandle();
                    int total = orderHandle.countByUser(me.getId());
                    String sort = request.getParameter("sort"); if (sort == null || sort.isEmpty()) sort = "date_desc"; List<Goods> goodsList = orderHandle.findGoodsByUserPaged(me.getId(), limitMin, perPage, sort); request.setAttribute("sort", sort);
                    request.setAttribute("goodsList", goodsList);
                    request.setAttribute("userMap", buildUserMap(goodsList, userHandle));
                    int maxPage = Math.max(1, (total + perPage - 1) / perPage);
                    request.setAttribute("pn", pn);
                    request.setAttribute("maxPage", maxPage);
                    request.setAttribute("total", total);
                }
                break;
            }
            case "auditing": {
                if (LoginVerify.isAdmin(request)) {
                    GoodsHandle goodsHandle = new GoodsHandle();
                    List<Goods> goodsList = goodsHandle.findAllNotAuditing();
                    request.setAttribute("goodsList", goodsList);
                    request.setAttribute("userMap", buildUserMap(goodsList, userHandle));
                }
                break;
            }
            case "info": {
                request.setAttribute("info", request.getParameter("info"));
                break;
            }
        }
    }

    private Map<Integer, User> buildUserMap(List<Goods> goodsList, UserHandle userHandle) throws Exception {
        Map<Integer, User> userMap = new HashMap<>();
        for (Goods goods : goodsList) {
            if (goods.getProducterId() != null && !userMap.containsKey(goods.getProducterId())) {
                User u = userHandle.findById(goods.getProducterId());
                if (u != null) userMap.put(goods.getProducterId(), u);
            }
        }
        return userMap;
    }

    private int parseIntParam(HttpServletRequest request, String name, int defaultVal) {
        try { return Integer.parseInt(request.getParameter(name)); }
        catch (Exception e) { return defaultVal; }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}