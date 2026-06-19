package com.luna.saltfish.dao;

import com.luna.saltfish.constant.GoodsStatusConstant;
import com.luna.saltfish.entity.Goods;
import com.luna.saltfish.util.PageResult;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.BasicRowProcessor;
import org.apache.commons.dbutils.BeanProcessor;
import org.apache.commons.dbutils.GenerousBeanProcessor;
import org.apache.commons.dbutils.RowProcessor;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class GoodsHandle {

    private BeanHandler<Goods>     beanHandler;
    private BeanListHandler<Goods> beanListHandler;

    public BeanHandler<Goods> getBeanHandler() {
        if (beanHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanHandler<Goods>(Goods.class, processor);
        }
        return beanHandler;
    }

    public void setBeanHandler(BeanHandler<Goods> beanHandler) {
        this.beanHandler = beanHandler;
    }

    public BeanListHandler<Goods> getBeanListHandler() {
        if (beanListHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanListHandler<Goods>(Goods.class, processor);
        }
        return beanListHandler;
    }

    public void setBeanListHandler(BeanListHandler<Goods> beanListHandler) {
        this.beanListHandler = beanListHandler;
    }

    public Goods findById(int id) throws Exception {
        String sql = "SELECT id,image,type_id,name,num,price,status,content,producter_id,create_date FROM goods WHERE id=?";
        return JdbcTemplate.query(sql, getBeanHandler(), id);
    }

    public boolean doCreate(Goods good) throws Exception {
        String sql = "INSERT INTO `goods`(name, price, image, content, status, id, type_id, producter_id, create_date, num) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return JdbcTemplate.update(sql, good.getName(), good.getPrice(), good.getImage(), good.getContent(),
            GoodsStatusConstant.PRE_VIEW, good.getId(), good.getTypeId(), good.getProducterId(),
            new Timestamp(good.getCreateDate().getTime()), 1) > 0;
    }

    public int getMaxId() throws Exception {
        String sql = "SELECT MAX(id) FROM goods";
        return JdbcTemplate.query(sql, new ScalarHandler<Integer>());
    }

    public List<Goods> findAll(PageResult num, int limitMin, int perPage) throws Exception {
        String sql = "SELECT g.id, g.num, g.content, g.type_id, g.image, g.producter_id, g.price, g.create_date, g.name, g.status FROM goods g LEFT JOIN category c ON g.type_id = c.id WHERE g.status=? AND (c.is_active=1 OR c.id IS NULL) ORDER BY g.create_date DESC LIMIT ?,?";
        List<Goods> queryGoodsList = JdbcTemplate.query(sql, getBeanListHandler(), GoodsStatusConstant.REVIEW_ED, limitMin, perPage);
        String count = "SELECT COUNT(*) FROM goods g LEFT JOIN category c ON g.type_id = c.id WHERE g.status=? AND (c.is_active=1 OR c.id IS NULL)";
        num.value = Integer.parseInt(JdbcTemplate.query(count, new ScalarHandler<>(), GoodsStatusConstant.REVIEW_ED).toString());
        return queryGoodsList;
    }

    public List<Goods> findAllNotAuditing() throws Exception {
        String sql = "SELECT id, num, content, type_id, image, producter_id, price, name, create_date FROM goods WHERE status=?";
        return JdbcTemplate.query(sql, getBeanListHandler(), GoodsStatusConstant.PRE_VIEW);
    }

    public boolean updateStatusIfMatch(int goodsId, int newStatus, int expectedStatus) throws Exception {
        String sql = "UPDATE goods SET status=? WHERE id=? AND status=?";
        return JdbcTemplate.update(sql, newStatus, goodsId, expectedStatus) > 0;
    }

    public boolean doUpdate(Goods good) throws Exception {
        StringBuilder sql = new StringBuilder("UPDATE goods SET ");
        List<Object> params = new ArrayList<>();
        if (good.getName() != null) { sql.append("name=?,"); params.add(good.getName()); }
        if (good.getImage() != null) { sql.append("image=?,"); params.add(good.getImage()); }
        if (good.getTypeId() != null) { sql.append("type_id=?,"); params.add(good.getTypeId()); }
        if (good.getNum() != null) { sql.append("num=?,"); params.add(good.getNum()); }
        if (good.getPrice() != null) { sql.append("price=?,"); params.add(good.getPrice()); }
        if (good.getStatus() != null) { sql.append("status=?,"); params.add(good.getStatus()); }
        if (good.getContent() != null) { sql.append("content=?,"); params.add(good.getContent()); }
        if (good.getProducterId() != null) { sql.append("producter_id=?,"); params.add(good.getProducterId()); }
        if (good.getCreateDate() != null) { sql.append("create_date=?,"); params.add(good.getCreateDate()); }
        if (params.isEmpty()) return false;
        sql.setLength(sql.length() - 1);
        sql.append(" WHERE id=?");
        params.add(good.getId());
        Object[] param = params.toArray();
        return JdbcTemplate.update(sql.toString(), param) > 0;
    }

    public List<Goods> findByCeta(int cetaId, PageResult num, int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, num, content, type_id, image, producter_id, price, name, create_date, status FROM goods WHERE status=? AND type_id=? ORDER BY create_date DESC LIMIT ?,?";
        List<Goods> goodsList = JdbcTemplate.query(sql, getBeanListHandler(), GoodsStatusConstant.REVIEW_ED, cetaId, limitMin, perPage);
        String count = "SELECT COUNT(*) FROM goods WHERE status=? AND type_id=?";
        num.value = Integer.parseInt(JdbcTemplate.query(count, new ScalarHandler<>(), GoodsStatusConstant.REVIEW_ED, cetaId).toString());
        return goodsList;
    }

    public List<Goods> findByKey(String key) throws Exception {
        String sql = "SELECT g.id, g.num, g.content, g.type_id, g.image, g.producter_id, g.price, g.name, g.create_date FROM goods g LEFT JOIN category c ON g.type_id = c.id WHERE g.status=? AND g.name LIKE ? AND (c.is_active=1 OR c.id IS NULL) ORDER BY g.create_date DESC";
        return JdbcTemplate.query(sql, getBeanListHandler(), GoodsStatusConstant.REVIEW_ED, "%" + key + "%");
    }

    public List<Goods> findByKeyPaged(String key, PageResult num, int limitMin, int perPage) throws Exception {
        String sql = "SELECT g.id, g.num, g.content, g.type_id, g.image, g.producter_id, g.price, g.name, g.create_date FROM goods g LEFT JOIN category c ON g.type_id = c.id WHERE g.status=? AND g.name LIKE ? AND (c.is_active=1 OR c.id IS NULL) ORDER BY g.create_date DESC LIMIT ?,?";
        List<Goods> list = JdbcTemplate.query(sql, getBeanListHandler(), GoodsStatusConstant.REVIEW_ED, "%" + key + "%", limitMin, perPage);
        String count = "SELECT COUNT(*) FROM goods g LEFT JOIN category c ON g.type_id = c.id WHERE g.status=? AND g.name LIKE ? AND (c.is_active=1 OR c.id IS NULL)";
        num.value = Integer.parseInt(JdbcTemplate.query(count, new ScalarHandler<>(), GoodsStatusConstant.REVIEW_ED, "%" + key + "%").toString());
        return list;
    }

    public List<Goods> findByUserId(int userId) throws Exception {
        String sql = "SELECT id, num, content, type_id, image, producter_id, price, name, create_date, status FROM goods WHERE producter_id=? ORDER BY create_date DESC";
        return JdbcTemplate.query(sql, getBeanListHandler(), userId);
    }

    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM goods";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }

    public int countByStatus(int status) throws Exception {
        String sql = "SELECT COUNT(*) FROM goods WHERE status=?";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), status).toString());
    }

    public int countRecent(int days) throws Exception {
        String sql = "SELECT COUNT(*) FROM goods WHERE create_date >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days).toString());
    }

    public int[] dailyCounts(int days) throws Exception {
        int[] result = new int[days];
        for (int i = 0; i < days; i++) {
            String sql = "SELECT COUNT(*) FROM goods WHERE DATE(create_date) = DATE(DATE_SUB(NOW(), INTERVAL ? DAY))";
            result[i] = Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days - 1 - i).toString());
        }
        return result;
    }

    public List<Goods> findTopByCollected(int limit) throws Exception {
        String sql = "SELECT g.id, g.name, g.price, g.image, g.producter_id, g.status FROM goods g INNER JOIN collect c ON g.id=c.goods_id GROUP BY g.id ORDER BY COUNT(*) DESC LIMIT ?";
        return JdbcTemplate.query(sql, getBeanListHandler(), limit);
    }

    public List<Goods> findTopByOrderCount(int limit) throws Exception {
        String sql = "SELECT g.id, g.name, g.price, g.image, g.producter_id, g.status FROM goods g INNER JOIN `order` o ON g.id=o.goods_id GROUP BY g.id ORDER BY COUNT(*) DESC LIMIT ?";
        return JdbcTemplate.query(sql, getBeanListHandler(), limit);
    }

    public List<Goods> findAllAdmin(int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, num, content, type_id, image, producter_id, price, name, create_date, status FROM goods ORDER BY create_date DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getBeanListHandler(), limitMin, perPage);
    }

    public List<Goods> findAllByStatus(int status, int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, num, content, type_id, image, producter_id, price, name, create_date, status FROM goods WHERE status=? ORDER BY create_date DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getBeanListHandler(), status, limitMin, perPage);
    }
    public boolean doDelete(int goodsId) throws Exception {
        String sql = "DELETE FROM goods WHERE id=?";
        return JdbcTemplate.update(sql, goodsId) > 0;
    }
}
