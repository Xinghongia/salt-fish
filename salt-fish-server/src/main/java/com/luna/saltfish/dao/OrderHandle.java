package com.luna.saltfish.dao;

import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.entity.Order;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.util.List;

public class OrderHandle {

    public boolean doCreate(Order order) throws Exception {
        String sql = "INSERT INTO `order`(goods_id, user_id, date, message) VALUES (?, ?, ?, ?)";
        return JdbcTemplate.update(sql, order.getGoodsId(), order.getUserId(),
            new java.sql.Timestamp(order.getDate().getTime()), order.getMessage()) > 0;
    }

    public List<Goods> findGoodsByUser(int userId) throws Exception {
        String sql = "SELECT id, num, content, type_id, image, producter_id, price, create_date, name, status FROM `goods` WHERE id=ANY(SELECT goods_id FROM `order` WHERE user_id=?)";
        return JdbcTemplate.query(sql, new GoodsHandle().getBeanListHandler(), userId);
    }

    public List<Goods> findGoodsByUserPaged(int userId, int limitMin, int perPage, String sort) throws Exception {
        String orderBy = "o.date DESC, g.id DESC";
        if ("price_asc".equals(sort)) orderBy = "g.price ASC, g.id DESC";
        else if ("price_desc".equals(sort)) orderBy = "g.price DESC, g.id DESC";
        else if ("date_asc".equals(sort)) orderBy = "o.date ASC, g.id DESC";
        String sql = "SELECT g.id, g.num, g.content, g.type_id, g.image, g.producter_id, g.price, g.create_date, g.name, g.status, o.date AS order_date FROM goods g JOIN `order` o ON g.id=o.goods_id WHERE o.user_id=? ORDER BY " + orderBy + " LIMIT ?,?";
        return JdbcTemplate.query(sql, new GoodsHandle().getBeanListHandler(), userId, limitMin, perPage);
    }

    public int countByUser(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM `order` WHERE user_id=?";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), userId).toString());
    }
    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM `order`";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }

    public int countRecent(int days) throws Exception {
        String sql = "SELECT COUNT(*) FROM `order` WHERE date >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days).toString());
    }

    public Order findByGoodsId(int goodsId) throws Exception {
        String sql = "SELECT id, goods_id, user_id, date, message FROM `order` WHERE goods_id=? LIMIT 1";
        org.apache.commons.dbutils.BeanProcessor bean = new org.apache.commons.dbutils.GenerousBeanProcessor();
        org.apache.commons.dbutils.RowProcessor processor = new org.apache.commons.dbutils.BasicRowProcessor(bean);
        return JdbcTemplate.query(sql, new BeanHandler<>(Order.class, processor), goodsId);
    }

    public boolean doDeleteByGoodsId(int goodsId) throws Exception {
        String sql = "DELETE FROM `order` WHERE goods_id=?";
        return JdbcTemplate.update(sql, goodsId) > 0;
    }

    public boolean doDeleteById(int orderId) throws Exception {
        String sql = "DELETE FROM `order` WHERE id=?";
        return JdbcTemplate.update(sql, orderId) > 0;
    }

    private BeanListHandler<Order> orderListHandler;
    private BeanListHandler<Order> getOrderListHandler() {
        if (orderListHandler == null) {
            org.apache.commons.dbutils.BeanProcessor bean = new org.apache.commons.dbutils.GenerousBeanProcessor();
            org.apache.commons.dbutils.RowProcessor processor = new org.apache.commons.dbutils.BasicRowProcessor(bean);
            return new BeanListHandler<>(Order.class, processor);
        }
        return orderListHandler;
    }

    public List<Order> findAllPaged(int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, goods_id, user_id, date, message FROM `order` ORDER BY date DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getOrderListHandler(), limitMin, perPage);
    }

    public List<Order> findByStatusPaged(int goodsStatus, int limitMin, int perPage) throws Exception {
        String sql = "SELECT o.id, o.goods_id, o.user_id, o.date, o.message FROM `order` o JOIN goods g ON o.goods_id=g.id WHERE g.status=? ORDER BY o.date DESC, g.id DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getOrderListHandler(), goodsStatus, limitMin, perPage);
    }

    public int countByGoodsStatus(int goodsStatus) throws Exception {
        String sql = "SELECT COUNT(*) FROM `order` o JOIN goods g ON o.goods_id=g.id WHERE g.status=?";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), goodsStatus).toString());
    }

    public int countDayRange(int days) throws Exception {
        String sql = "SELECT COUNT(*) FROM `order` WHERE date >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days).toString());
    }

    public int[] dailyCounts(int days) throws Exception {
        int[] result = new int[days];
        for (int i = 0; i < days; i++) {
            String sql = "SELECT COUNT(*) FROM `order` WHERE DATE(date) = DATE(DATE_SUB(NOW(), INTERVAL ? DAY))";
            result[i] = Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days - 1 - i).toString());
        }
        return result;
    }
}