package com.luna.saltfish.controller;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.ShopCartHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;
import com.luna.saltfish.util.StaticVar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ShopCartController extends HttpServlet {
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
        String sort = request.getParameter("sort");
        if (sort == null || sort.isEmpty()) sort = "date_desc";
        request.setAttribute("sort", sort);
        int pn = 1;
        try { pn = Integer.parseInt(request.getParameter("pn")); } catch (Exception e) {}
        if (pn < 1) pn = 1;
        int perPage = StaticVar.PERPAGE_CART;
        int limitMin = (pn - 1) * perPage;
        try {
            ShopCartHandle shopCartHandle = new ShopCartHandle();
            int total = shopCartHandle.countByUser(me.getId());
            List<Goods> goodsList = shopCartHandle.findGoodsByUserPaged(me, limitMin, perPage, sort);
            UserHandle userHandle = new UserHandle();
            Map<Integer, User> userMap = new HashMap<>();
            for (Goods goods : goodsList) {
                if (goods.getProducterId() != null && !userMap.containsKey(goods.getProducterId())) {
                    User u = userHandle.findById(goods.getProducterId());
                    if (u != null) userMap.put(goods.getProducterId(), u);
                }
            }
            int maxPage = Math.max(1, (total + perPage - 1) / perPage);
            request.setAttribute("goodsList", goodsList);
            request.setAttribute("userMap", userMap);
            request.setAttribute("info", request.getParameter("info"));
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("total", total);
        } catch (Exception e) { e.printStackTrace(); }
        request.getRequestDispatcher("/site/personal/shopcart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
