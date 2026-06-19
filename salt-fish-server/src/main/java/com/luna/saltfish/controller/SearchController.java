package com.luna.saltfish.controller;

import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.util.PageResult;
import com.luna.saltfish.util.StaticVar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 搜索控制器
 */
public class SearchController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String key = request.getParameter("key");

        if (key == null || key.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index?ceta=0");
            return;
        }

        key = key.trim();
        GoodsHandle goodsHandle = new GoodsHandle();
        UserHandle userHandle = new UserHandle();

        int pn = 1;
        try {
            pn = Integer.parseInt(request.getParameter("pn"));
        } catch (Exception e) { }
        if (pn < 1) pn = 1;
        int perPage = StaticVar.PERPAGE_GOODS;
        int limitMin = (pn - 1) * perPage;

        try {
            PageResult count = new PageResult(0);
            List<Goods> list = goodsHandle.findByKeyPaged(key, count, limitMin, perPage);

            // N+1 优化
            Map<Integer, User> userMap = new HashMap<>();
            for (Goods goods : list) {
                if (goods.getProducterId() != null && !userMap.containsKey(goods.getProducterId())) {
                    User u = userHandle.findById(goods.getProducterId());
                    if (u != null) {
                        userMap.put(goods.getProducterId(), u);
                    }
                }
            }

            int total = count.value;
            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("goodsList", list);
            request.setAttribute("userMap", userMap);
            request.setAttribute("key", key);
            request.setAttribute("total", total);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("goodsList", new ArrayList<>());
            request.setAttribute("total", 0);
        }

        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
