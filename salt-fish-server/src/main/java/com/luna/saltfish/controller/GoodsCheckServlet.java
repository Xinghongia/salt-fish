package com.luna.saltfish.controller;

import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;
import com.luna.saltfish.dao.CategoryHandle;
import com.luna.saltfish.entity.Category;
import java.util.Date;

@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class GoodsCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public String getForm(HttpServletRequest req, String formName)
            throws IllegalStateException, IOException, ServletException {
        Part part = req.getPart(formName);
        byte[] tmp = new byte[(int) part.getSize()];
        part.getInputStream().read(tmp);
        return new String(tmp, "UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String savePath = request.getServletContext().getRealPath("static/goods_img");

        try {
            String goodsName = getForm(request, "name-goods");
            String goodsContent = getForm(request, "content-goods");
            String goodsQuantityStr = getForm(request, "quantity-goods");
            Part part = request.getPart("file");
            String typeIdStr = getForm(request, "type_id-goods");

            // Validate
            if (goodsName == null || goodsName.trim().isEmpty()) {
                request.setAttribute("nameCheck", "物品名称不能为空");
                request.setAttribute("isCheck", false);
                request.setAttribute("seccess", "0");
                request.getRequestDispatcher("/push").forward(request, response);
                return;
            }
            if (goodsQuantityStr == null || goodsQuantityStr.trim().isEmpty()) {
                request.setAttribute("quantityCheck", "物品价格不能为空");
                request.setAttribute("isCheck", false);
                request.setAttribute("seccess", "0");
                request.getRequestDispatcher("/push").forward(request, response);
                return;
            }
            if (goodsContent == null || goodsContent.trim().isEmpty()) {
                request.setAttribute("contentCheck", "物品简介不能为空");
                request.setAttribute("isCheck", false);
                request.setAttribute("seccess", "0");
                request.getRequestDispatcher("/push").forward(request, response);
                return;
            }
            if (part.getSize() == 0) {
                request.setAttribute("fileCheck", "需要上传物品图片");
                request.setAttribute("isCheck", false);
                request.setAttribute("seccess", "0");
                request.getRequestDispatcher("/push").forward(request, response);
                return;
            }

            // Validate category from database
            int type = 0;
            try {
                CategoryHandle catHandle = new CategoryHandle();
                List<Category> cats = catHandle.findAllActive();
                for (Category c : cats) {
                    if (String.valueOf(c.getId()).equals(typeIdStr)) {
                        type = c.getId();
                        break;
                    }
                }
            } catch (Exception ce) {
                ce.printStackTrace();
            }

            User user = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
            Goods good = new Goods();
            good.setTypeId(type);
            good.setNum(1);
            good.setProducterId(user.getId());
            good.setName(goodsName.trim());
            good.setContent(goodsContent.trim());
            good.setPrice(Float.parseFloat(goodsQuantityStr));

            GoodsHandle goodsHandle = new GoodsHandle();
            int maxid = goodsHandle.getMaxId();
            good.setId(maxid + 1);

            // Save image
            byte[] bt = new byte[(int) part.getSize()];
            String imagePath = savePath + "/" + good.getId() + ".jpg";
            good.setImage("static/goods_img/" + good.getId() + ".jpg");
            try (FileOutputStream fos = new FileOutputStream(imagePath)) {
                part.getInputStream().read(bt);
                fos.write(bt);
            }

            good.setCreateDate(new Date());
            goodsHandle.doCreate(good);

            response.sendRedirect(request.getContextPath() + "/push?info=" + java.net.URLEncoder.encode("发布成功，等待管理员审核", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("info", "发布失败: " + e.getMessage());
            request.getRequestDispatcher("/push").forward(request, response);
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doGet(request, response);
    }
}