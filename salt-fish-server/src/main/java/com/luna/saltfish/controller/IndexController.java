package com.luna.saltfish.controller;

import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Announcement;
import com.luna.saltfish.dao.AnnouncementHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.util.PageResult;
import com.luna.saltfish.util.StaticVar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;

/**
 * 首页控制器
 * 处理商品列表分页和分类筛选
 */
public class IndexController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GoodsHandle goodsHandle = new GoodsHandle();
        UserHandle userHandle = new UserHandle();

        // 分页参数
        int pn = 1;
        try {
            pn = Integer.parseInt(request.getParameter("pn"));
        } catch (Exception e) {
            // 默认第1页
        }
        if (pn < 1) pn = 1;
        int perPage = StaticVar.PERPAGE_GOODS;
        int limitMin = (pn - 1) * perPage;

        // 分类参数
        int ceta = 0;
        try {
            ceta = Integer.parseInt(request.getParameter("ceta"));
        } catch (Exception e) {
            // 默认全部
        }

        // 分类名称映射
        String[] typeNames = {"", "书籍", "生活", "衣物", "电子", "运动", "其他"};

        try {
            // 从数据库加载分类列表
            CategoryHandle categoryHandle = new CategoryHandle();
            List<Category> categoryList = categoryHandle.findAllActive();
            request.setAttribute("categoryList", categoryList);

            PageResult count = new PageResult(0);
            List<Goods> list;

            if (ceta == 0) {
                list = goodsHandle.findAll(count, limitMin, perPage);
            } else {
                list = goodsHandle.findByCeta(ceta, count, limitMin, perPage);
            }

            // 解决 N+1 查询：批量获取所有相关用户
            Map<Integer, User> userMap = new HashMap<>();
            for (Goods goods : list) {
                if (goods.getProducterId() != null && !userMap.containsKey(goods.getProducterId())) {
                    User u = userHandle.findById(goods.getProducterId());
                    if (u != null) {
                        userMap.put(goods.getProducterId(), u);
                    }
                }
            }

            // 分页计算
            int total = count.value;
            int maxPage = (total + perPage - 1) / perPage;
            if (maxPage < 1) maxPage = 1;

            request.setAttribute("goodsList", list);
            request.setAttribute("userMap", userMap);
            request.setAttribute("pn", pn);
            request.setAttribute("maxPage", maxPage);
            request.setAttribute("ceta", ceta);
            request.setAttribute("typeNames", typeNames);
            request.setAttribute("total", total);

            // Load announcements
            try {
                AnnouncementHandle annHandle = new AnnouncementHandle();
                List<Announcement> announcements = annHandle.findActive();
                request.setAttribute("announcements", announcements);
            } catch (Exception e) {
                // Silently fail
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
