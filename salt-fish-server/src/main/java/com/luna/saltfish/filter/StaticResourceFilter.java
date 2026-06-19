package com.luna.saltfish.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 静态资源编码过滤器
 * 确保JS/CSS等静态文件的Content-Type包含charset=UTF-8
 */
public class StaticResourceFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            // 在响应提交之前设置charset
            httpResponse.setCharacterEncoding("UTF-8");
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
