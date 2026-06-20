package com.luna.saltfish.api;

import com.luna.saltfish.constant.ResultConstant;
import com.luna.saltfish.constant.UserLoginConstant;
import com.luna.saltfish.dao.AdminLogHandle;
import com.luna.saltfish.dao.FeedbackHandle;
import com.luna.saltfish.dao.GoodsHandle;
import com.luna.saltfish.dao.OrderHandle;
import com.luna.saltfish.dao.UserHandle;
import com.luna.saltfish.entity.AdminLog;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Order;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.service.LoginVerify;
import com.luna.saltfish.util.MD5;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import com.luna.saltfish.dao.AnnouncementHandle;
import com.luna.saltfish.dao.CategoryHandle;

public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private void logAction(HttpServletRequest request, String action, String target, String detail) {
        try {
            User admin = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
            AdminLog log = new AdminLog();
            log.setAdminId(admin.getId());
            log.setAdminName(admin.getName());
            log.setAction(action);
            log.setTarget(target);
            log.setDetail(detail);
            log.setCreateTime(new Date());
            new AdminLogHandle().doCreate(log);
        } catch (Exception e) {
            // silently fail
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");

        if (!LoginVerify.isAdmin(request)) {
            response.getWriter().print(ResultConstant.ERROR);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.getWriter().print(ResultConstant.ERROR);
            return;
        }

        try {
            switch (action) {
                case "deleteGoods": {
                    int goodsId = Integer.parseInt(request.getParameter("goodsId"));
                    GoodsHandle goodsHandle = new GoodsHandle();
                    if (goodsHandle.doDelete(goodsId)) {
                        logAction(request, "删除商品", "商品#" + goodsId, "管理员删除了商品#" + goodsId);
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "deleteUser": {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    UserHandle userHandle = new UserHandle();
                    User target = userHandle.findById(userId);
                    if (target != null && target.getRole() != 1 && userHandle.doDelete(userId)) {
                        logAction(request, "删除用户", "用户#" + userId, "管理员删除了用户 " + (target.getName() != null ? target.getName() : target.getEmail()));
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "addUser": {
                    String email = request.getParameter("email");
                    String name = request.getParameter("name");
                    String pwd = request.getParameter("pwd");
                    String phone = request.getParameter("phone");
                    if (email == null || email.trim().isEmpty() || pwd == null || pwd.trim().isEmpty()) {
                        response.getWriter().print("error:邮箱和密码不能为空");
                        break;
                    }
                    UserHandle userHandle = new UserHandle();
                    if (userHandle.findByEmail(email.trim()) != null) {
                        response.getWriter().print("error:邮箱已存在");
                        break;
                    }
                    User newUser = new User();
                    newUser.setEmail(email.trim());
                    newUser.setName(name != null && !name.trim().isEmpty() ? name.trim() : email.split("@")[0]);
                    newUser.setPwd(MD5.getMD5(pwd.trim()));
                    newUser.setPhone(phone != null ? phone.trim() : "");
                    newUser.setStuNum("");
                    if (userHandle.doCreate(newUser)) {
                        logAction(request, "添加用户", email.trim(), "管理员添加了新用户 " + newUser.getName());
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "editUser": {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String name = request.getParameter("name");
                    String phone = request.getParameter("phone");
                    String stuNum = request.getParameter("stuNum");
                    UserHandle userHandle = new UserHandle();
                    if (userHandle.doUpdateInfo(userId, name, phone, stuNum != null ? stuNum : "")) {
                        logAction(request, "编辑用户", "用户#" + userId, "管理员编辑了用户#" + userId + "的信息");
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "setRole": {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    int role = Integer.parseInt(request.getParameter("role"));
                    UserHandle userHandle = new UserHandle();
                    if (userHandle.setRole(userId, role)) {
                        String roleName = role == 1 ? "管理员" : "普通用户";
                        logAction(request, "修改角色", "用户#" + userId, "管理员将用户#" + userId + "的角色设为" + roleName);
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "toggleGoodsStatus": {
                    int goodsId = Integer.parseInt(request.getParameter("goodsId"));
                    int status = Integer.parseInt(request.getParameter("status"));
                    GoodsHandle goodsHandle = new GoodsHandle();
                    Goods goods = new Goods();
                    goods.setId(goodsId);
                    goods.setStatus(status);
                    if (goodsHandle.doUpdate(goods)) {
                        String[] statusNames = {"", "待审核", "在售", "已拒绝", "交易中", "已售出"};
                        String statusName = (status >= 1 && status <= 5) ? statusNames[status] : "未知";
                        logAction(request, "修改商品状态", "商品#" + goodsId, "管理员将商品#" + goodsId + "的状态设为" + statusName);
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "deleteLog": {
                    int logId = Integer.parseInt(request.getParameter("logId"));
                    AdminLogHandle logHandle = new AdminLogHandle();
                    if (logHandle.doDelete(logId)) {
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "clearLogs": {
                    AdminLogHandle logHandle = new AdminLogHandle();
                    if (logHandle.doDeleteAll()) {
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "completeOrder": {
                    int goodsId = Integer.parseInt(request.getParameter("goodsId"));
                    GoodsHandle gh = new GoodsHandle();
                    Goods g = gh.findById(goodsId);
                    if (g == null) { response.getWriter().print(ResultConstant.ERROR); break; }
                    // Only seller can complete
                    User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
                    if (g.getProducterId() == null || !g.getProducterId().equals(me.getId())) {
                        response.getWriter().print(ResultConstant.ERROR);
                        break;
                    }
                    if (gh.updateStatusIfMatch(goodsId, 5, 4)) {
                        logAction(request, "\u786e\u8ba4\u4ea4\u6613\u5b8c\u6210", "\u5546\u54c1#" + goodsId, "\u5356\u5bb6\u786e\u8ba4\u4ea4\u6613\u5b8c\u6210 " + g.getName());
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }
                case "cancelOrder": {
                    int goodsId = Integer.parseInt(request.getParameter("goodsId"));
                    GoodsHandle gh = new GoodsHandle();
                    Goods g = gh.findById(goodsId);
                    if (g == null) { response.getWriter().print(ResultConstant.ERROR); break; }
                    User me = (User) request.getSession().getAttribute(UserLoginConstant.LOGIN_USER);
                    if (g.getProducterId() == null || !g.getProducterId().equals(me.getId())) {
                        response.getWriter().print(ResultConstant.ERROR);
                        break;
                    }
                    if (gh.updateStatusIfMatch(goodsId, 2, 4)) {
                        OrderHandle oh = new OrderHandle();
                        oh.doDeleteByGoodsId(goodsId);
                        logAction(request, "\u53d6\u6d88\u4ea4\u6613", "\u5546\u54c1#" + goodsId, "\u5356\u5bb6\u53d6\u6d88\u4ea4\u6613 " + g.getName());
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else {
                        response.getWriter().print(ResultConstant.ERROR);
                    }
                    break;
                }                case "resetPassword": {
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String newPwd = request.getParameter("newPwd");
                    if (newPwd == null || newPwd.trim().isEmpty()) {
                        response.getWriter().print("error:\u5bc6\u7801\u4e0d\u80fd\u4e3a\u7a7a");
                        break;
                    }
                    UserHandle rh = new UserHandle();
                    if (rh.resetPassword(userId, MD5.getMD5(newPwd.trim()))) {
                        User target = rh.findById(userId);
                        logAction(request, "\u91cd\u7f6e\u5bc6\u7801", "\u7528\u6237#" + userId, "\u7ba1\u7406\u5458\u91cd\u7f6e\u4e86 " + (target != null ? target.getName() : "") + " \u7684\u5bc6\u7801");
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else { response.getWriter().print(ResultConstant.ERROR); }
                    break;
                }
                case "cancelOrderAdmin": {
                    int goodsId = Integer.parseInt(request.getParameter("goodsId"));
                    GoodsHandle gh = new GoodsHandle();
                    Goods g = gh.findById(goodsId);
                    if (g == null) { response.getWriter().print(ResultConstant.ERROR); break; }
                    if (gh.updateStatusIfMatch(goodsId, 2, 4)) {
                        OrderHandle oh = new OrderHandle();
                        oh.doDeleteByGoodsId(goodsId);
                        logAction(request, "\u7ba1\u7406\u5458\u53d6\u6d88\u4ea4\u6613", "\u5546\u54c1#" + goodsId, "\u7ba1\u7406\u5458\u53d6\u6d88\u4ea4\u6613 " + g.getName());
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else { response.getWriter().print(ResultConstant.ERROR); }
                    break;
                }
                case "deleteOrder": {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    OrderHandle oh = new OrderHandle();
                    if (oh.doDeleteById(orderId)) {
                        logAction(request, "\u5220\u9664\u8ba2\u5355", "\u8ba2\u5355#" + orderId, "\u7ba1\u7406\u5458\u5220\u9664\u4e86\u8ba2\u5355#" + orderId);
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else { response.getWriter().print(ResultConstant.ERROR); }
                    break;
                }
                case "deleteFeedback": {
                    int fbId = Integer.parseInt(request.getParameter("feedbackId"));
                    FeedbackHandle fbh = new FeedbackHandle();
                    if (fbh.doDelete(fbId)) {
                        logAction(request, "\u5220\u9664\u53cd\u9988", "\u53cd\u9988#" + fbId, "\u7ba1\u7406\u5458\u5220\u9664\u4e86\u53cd\u9988#" + fbId);
                        response.getWriter().print(ResultConstant.SUCCESS);
                    } else { response.getWriter().print(ResultConstant.ERROR); }
                    break;
                }
                case "exportOrders": {
                    response.setContentType("text/csv;charset=UTF-8");
                    response.setHeader("Content-Disposition", "attachment;filename=orders.csv");
                    response.getWriter().write("\uFEFF\u8ba2\u5355ID,\u5546\u54c1ID,\u5546\u54c1\u540d\u79f0,\u4e70\u5bb6ID,\u4e70\u5bb6,\u4ef6\u683c,\u72b6\u6001,\u4e0b\u5355\u65f6\u95f4,\u7559\u8a00\n");
                    OrderHandle oeh = new OrderHandle();
                    GoodsHandle geh = new GoodsHandle();
                    UserHandle ueh = new UserHandle();
                    java.util.List<com.luna.saltfish.entity.Order> allOrders = oeh.findAllPaged(0, 99999);
                    for (com.luna.saltfish.entity.Order o : allOrders) {
                        Goods g = geh.findById(o.getGoodsId());
                        User buyer = ueh.findById(o.getUserId());
                        String gName = g != null ? g.getName() : "\u5df2\u5220\u9664";
                        String gPrice = g != null ? String.valueOf(g.getPrice()) : "0";
                        String gStatus = g != null ? (g.getStatus() == 4 ? "\u4ea4\u6613\u4e2d" : (g.getStatus() == 5 ? "\u5df2\u5b8c\u6210" : "\u5176\u4ed6")) : "-";
                        String bName = buyer != null ? buyer.getName() : "";
                        String msg = o.getMessage() != null ? o.getMessage().replace(",", "\uff0c").replace("\n", " ") : "";
                        response.getWriter().write(o.getId() + "," + o.getGoodsId() + "," + gName + "," + o.getUserId() + "," + bName + "," + gPrice + "," + gStatus + "," + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(o.getDate()) + "," + msg + "\n");
                    }
                    return;
                }
                case "exportUsers": {
                    response.setContentType("text/csv;charset=UTF-8");
                    response.setHeader("Content-Disposition", "attachment;filename=users.csv");
                    response.getWriter().write("\uFEFF\u7528\u6237ID,\u6635\u79f0,\u90ae\u7bb1,\u624b\u673a,\u5b66\u53f7,\u89d2\u8272\n");
                    UserHandle ueh2 = new UserHandle();
                    java.util.List<User> allUsers = ueh2.findAll(0, 99999);
                    for (User u : allUsers) {
                        String role = u.getRole() == 1 ? "\u7ba1\u7406\u5458" : "\u666e\u901a\u7528\u6237";
                        response.getWriter().write(u.getId() + "," + (u.getName() != null ? u.getName() : "") + "," + u.getEmail() + "," + (u.getPhone() != null ? u.getPhone() : "") + "," + (u.getStuNum() != null ? u.getStuNum() : "") + "," + role + "\n");
                    }
                    return;
                }
                case "exportGoods": {
                    response.setContentType("text/csv;charset=UTF-8");
                    response.setHeader("Content-Disposition", "attachment;filename=goods.csv");
                    response.getWriter().write("\uFEFF\u5546\u54c1ID,\u540d\u79f0,\u4ef6\u683c,\u5206\u7c7b,\u72b6\u6001,\u5356\u5bb6ID,\u53d1\u5e03\u65f6\u95f4\n");
                    GoodsHandle geh2 = new GoodsHandle();
                    java.util.List<Goods> allGoods = geh2.findAllAdmin(0, 99999);
                    String[] typeNames = {"", "\u4e66\u7c4d", "\u751f\u6d3b", "\u8863\u7269", "\u7535\u5b50", "\u8fd0\u52a8", "\u5176\u4ed6"};
                    String[] statusNames = {"", "\u5f85\u5ba1\u6838", "\u5728\u552e", "\u5df2\u62d2\u7edd", "\u4ea4\u6613\u4e2d", "\u5df2\u552e\u51fa"};
                    for (Goods g : allGoods) {
                        String tName = (g.getTypeId() != null && g.getTypeId() >= 1 && g.getTypeId() <= 6) ? typeNames[g.getTypeId()] : "";
                        String sName = (g.getStatus() != null && g.getStatus() >= 1 && g.getStatus() <= 5) ? statusNames[g.getStatus()] : "";
                        response.getWriter().write(g.getId() + "," + g.getName() + "," + g.getPrice() + "," + tName + "," + sName + "," + (g.getProducterId() != null ? g.getProducterId() : "") + "," + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(g.getCreateDate()) + "\n");
                    }
                    return;
                }
                case "batchDeleteGoods": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    GoodsHandle bg = new GoodsHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (bg.doDelete(Integer.parseInt(id.trim()))) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量删除商品", "共" + count + "件", "管理员批量删除了" + count + "件商品");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchAuditGoods": {
                    String ids = request.getParameter("ids");
                    int status = Integer.parseInt(request.getParameter("status"));
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    GoodsHandle ba = new GoodsHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try {
                            Goods g = ba.findById(Integer.parseInt(id.trim()));
                            if (g != null && ba.updateStatusIfMatch(g.getId(), status, g.getStatus())) count++;
                        } catch (Exception ignored) {}
                    }
                    String sName = status == 2 ? "通过" : "拒绝";
                    logAction(request, "批量审核商品", "共" + count + "件", "管理员批量" + sName + "了" + count + "件商品");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchDeleteUsers": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    UserHandle bu = new UserHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try {
                            User u = bu.findById(Integer.parseInt(id.trim()));
                            if (u != null && u.getRole() != 1 && bu.doDelete(u.getId())) count++;
                        } catch (Exception ignored) {}
                    }
                    logAction(request, "批量删除用户", "共" + count + "人", "管理员批量删除了" + count + "个用户");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchSetRole": {
                    String ids = request.getParameter("ids");
                    int role = Integer.parseInt(request.getParameter("role"));
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    UserHandle bsu = new UserHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try {
                            int uid = Integer.parseInt(id.trim());
                            User u = bsu.findById(uid);
                            if (u != null && bsu.setRole(uid, role)) count++;
                        } catch (Exception ignored) {}
                    }
                    String roleName = role == 1 ? "管理员" : "普通用户";
                    logAction(request, "批量修改角色", "共" + count + "人", "管理员批量将" + count + "人设为" + roleName);
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchDeleteOrders": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    OrderHandle bo = new OrderHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (bo.doDeleteById(Integer.parseInt(id.trim()))) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量删除订单", "共" + count + "笔", "管理员批量删除了" + count + "笔订单");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchCancelOrders": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    OrderHandle bco = new OrderHandle();
                    GoodsHandle bcg = new GoodsHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try {
                            Order o = bco.findById(Integer.parseInt(id.trim()));
                            if (o != null && bcg.updateStatusIfMatch(o.getGoodsId(), 2, 4)) {
                                bco.doDeleteByGoodsId(o.getGoodsId());
                                count++;
                            }
                        } catch (Exception ignored) {}
                    }
                    logAction(request, "批量取消交易", "共" + count + "笔", "管理员批量取消了" + count + "笔交易");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchCompleteOrders": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    OrderHandle bmo = new OrderHandle();
                    GoodsHandle bmg = new GoodsHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try {
                            Order o = bmo.findById(Integer.parseInt(id.trim()));
                            if (o != null && bmg.updateStatusIfMatch(o.getGoodsId(), 5, 4)) count++;
                        } catch (Exception ignored) {}
                    }
                    logAction(request, "批量确认完成", "共" + count + "笔", "管理员批量确认了" + count + "笔交易完成");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchDeleteAnnouncements": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    AnnouncementHandle ban = new AnnouncementHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (ban.doDelete(Integer.parseInt(id.trim()))) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量删除公告", "共" + count + "条", "管理员批量删除了" + count + "条公告");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchToggleAnnouncements": {
                    String ids = request.getParameter("ids");
                    boolean active = Boolean.parseBoolean(request.getParameter("active"));
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    AnnouncementHandle bta = new AnnouncementHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (bta.toggleActive(Integer.parseInt(id.trim()), active)) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量" + (active ? "显示" : "隐藏") + "公告", "共" + count + "条", "管理员批量" + (active ? "显示" : "隐藏") + "了" + count + "条公告");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchDeleteFeedback": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    FeedbackHandle bf = new FeedbackHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (bf.doDelete(Integer.parseInt(id.trim()))) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量删除反馈", "共" + count + "条", "管理员批量删除了" + count + "条反馈");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchDeleteCategories": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    CategoryHandle bc = new CategoryHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (bc.doDelete(Integer.parseInt(id.trim()))) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量删除分类", "共" + count + "个", "管理员批量删除了" + count + "个分类");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchToggleCategories": {
                    String ids = request.getParameter("ids");
                    boolean active = Boolean.parseBoolean(request.getParameter("active"));
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    CategoryHandle btc = new CategoryHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (btc.toggleActive(Integer.parseInt(id.trim()), active)) count++; } catch (Exception ignored) {}
                    }
                    logAction(request, "批量" + (active ? "启用" : "禁用") + "分类", "共" + count + "个", "管理员批量" + (active ? "启用" : "禁用") + "了" + count + "个分类");
                    response.getWriter().print("success:" + count);
                    break;
                }
                case "batchDeleteLogs": {
                    String ids = request.getParameter("ids");
                    if (ids == null || ids.isEmpty()) { response.getWriter().print(ResultConstant.ERROR); break; }
                    AdminLogHandle bl = new AdminLogHandle();
                    int count = 0;
                    for (String id : ids.split(",")) {
                        try { if (bl.doDelete(Integer.parseInt(id.trim()))) count++; } catch (Exception ignored) {}
                    }
                    response.getWriter().print("success:" + count);
                    break;
                }
                default:
                    response.getWriter().print(ResultConstant.ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print(ResultConstant.ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
