package com.luna.saltfish.service;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.entity.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class LoginVerify {

    /**
     * 判断是否为管理员
     * 通过用户的role字段判断，role=1为管理员
     */
    public static boolean isAdmin(HttpServletRequest request) {
        if (!isLogin(request)) return false;
        HttpSession ses = request.getSession();
        User user = (User) ses.getAttribute(UserLoginConstant.LOGIN_USER);
        return user.getRole() == 1;
    }

    /**
     * 是否已经登录
     */
    public static boolean isLogin(HttpServletRequest request) {
        HttpSession ses = request.getSession();
        return ses.getAttribute(UserLoginConstant.IS_LOGIN) != null
            && ses.getAttribute(UserLoginConstant.IS_LOGIN).equals(true)
            && ses.getAttribute(UserLoginConstant.LOGIN_USER) != null;
    }
}