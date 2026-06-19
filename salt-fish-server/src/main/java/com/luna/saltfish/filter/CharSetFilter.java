package com.luna.saltfish.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @author luna@mac
 */
public class CharSetFilter implements Filter {
    public CharSetFilter() {
    }

    @Override
    public void destroy() {
    }

    /**
     * 过滤器：设置编码,统一使用UTF-8
     * 
     * @param request
     * @param response
     * @param chain
     * @throws IOException
     * @throws ServletException
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
    }

}
