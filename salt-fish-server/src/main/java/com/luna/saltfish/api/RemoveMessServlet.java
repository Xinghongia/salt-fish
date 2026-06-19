package com.luna.saltfish.api;

import com.luna.saltfish.constant.ResultConstant;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.MessHandle;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//删除一条消息
/**
 * @author luna@mac
 */
public class RemoveMessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RemoveMessServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getParameter("messid") == null || request.getParameter("messid").length() == 0) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print("false");
            return;
        }
        Integer messId = Integer.parseInt(request.getParameter("messid"));
        if (LoginVerify.isLogin(request)) {
            User user = (User)request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
            int userId = user.getId();
            MessHandle messHandle = new MessHandle();
            try {
                if (messHandle.removeOneMess(messId, userId)) ;
                response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print(ResultConstant.SUCCESS);
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print("false");
            }
        } else {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().print("false");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

}
