package com.luna.saltfish.api;

import com.luna.saltfish.constant.ResultConstant;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.ShopCartHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author luna@mac
 */
public class CheckShoppingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
        if (LoginVerify.isLogin(request)) {
            User user = (User)request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
            int goodsId = Integer.parseInt(request.getParameter("goodsId"));
            ShopCartHandle shopCartHandle = new ShopCartHandle();
            try {
                boolean b = shopCartHandle.checkShoppingCart(user.getId(), goodsId);
                if (b) {
                    response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print(ResultConstant.SUCCESS);
                } else {
                    response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print(ResultConstant.ERROR);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print(UserLoginConstant.UN_LOGIN);
        }
    }
}
