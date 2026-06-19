package com.luna.saltfish.filter;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.MessHandle;
import com.luna.saltfish.dao.ShopCartHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;
import java.util.List;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * 公共数据过滤器
 * 为所有页面准备 header 需要的数据：登录用户、购物车数量、消息数量
 */
public class CommonDataFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;

        // basePath
        String path = req.getContextPath();
        String basePath = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + path + "/";
        req.setAttribute("basePath", basePath);
        req.setAttribute("path", path);

        if (LoginVerify.isLogin(req)) {
            User user = (User) req.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
            try {
                UserHandle userHandle = new UserHandle();
                // 刷新用户数据
                User freshUser = userHandle.findById(user.getId());
                if (freshUser != null) {
                    user = freshUser;
                    req.getSession().setAttribute(UserLoginConstant.LOGIN_USER, user);
                }
                req.setAttribute("loginUser", user);
                req.setAttribute("isLogin", true);
                req.setAttribute("isAdmin", LoginVerify.isAdmin(req));

                // 购物车数量
                ShopCartHandle shopCartHandle = new ShopCartHandle();
                int cartNum = shopCartHandle.getShopCartNum(user.getId());
                req.setAttribute("cartNum", cartNum);

                // 消息数量
                try {
                    MessHandle messHandle = new MessHandle();
                    req.setAttribute("messNum", messHandle.countUnread(user.getId()));
                } catch (Exception e) {
                    req.setAttribute("messNum", user.getMessnum());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            req.setAttribute("isLogin", false);
            req.setAttribute("isAdmin", false);
            req.setAttribute("cartNum", 0);
            req.setAttribute("messNum", 0);
        }

        // 加载分类列表（供 footer 等公共组件使用）
        try {
            CategoryHandle categoryHandle = new CategoryHandle();
            List<Category> categoryList = categoryHandle.findAllActive();
            req.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
