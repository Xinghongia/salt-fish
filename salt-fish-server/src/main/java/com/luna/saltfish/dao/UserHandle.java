package com.luna.saltfish.dao;

import com.luna.saltfish.entity.User;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.BasicRowProcessor;
import org.apache.commons.dbutils.BeanProcessor;
import org.apache.commons.dbutils.GenerousBeanProcessor;
import org.apache.commons.dbutils.RowProcessor;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.util.List;

public class UserHandle {

    private BeanHandler<User>     beanHandler;
    private BeanListHandler<User> beanListHandler;

    public BeanHandler<User> getBeanHandler() {
        if (beanHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanHandler<User>(User.class, processor);
        }
        return beanHandler;
    }

    public void setBeanHandler(BeanHandler<User> beanHandler) {
        this.beanHandler = beanHandler;
    }

    public BeanListHandler<User> getBeanListHandler() {
        if (beanListHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanListHandler<User>(User.class, processor);
        }
        return beanListHandler;
    }

    public void setBeanListHandler(BeanListHandler<User> beanListHandler) {
        this.beanListHandler = beanListHandler;
    }

    public boolean doCreate(User user) throws Exception {
        String sql = "INSERT INTO user(email, pwd, name, stu_num, phone) VALUES (?, ?, ?, ?, ?)";
        return JdbcTemplate.update(sql, user.getEmail(), user.getPwd(), user.getName(), user.getStuNum(),
            user.getPhone()) > 0;
    }

    public boolean doUpdate(User user) throws Exception {
        String sql = "UPDATE user SET pwd=?, name=?, phone=?, img=?, stu_num=?, qq=? WHERE id=?";
        return JdbcTemplate.update(sql, user.getPwd(), user.getName(), user.getPhone(), user.getImg(),
            user.getStuNum(), user.getQq(), user.getId()) > 0;
    }

    public boolean doUpdateInfo(int id, String name, String phone, String stuNum) throws Exception {
        String sql = "UPDATE user SET name=?, phone=?, stu_num=? WHERE id=?";
        return JdbcTemplate.update(sql, name, phone, stuNum, id) > 0;
    }

    public List<User> findAll(String keyWord) throws Exception {
        String sql = "SELECT id, email, pwd, name, stu_num, qq, phone, mess_num, img, role FROM user WHERE name LIKE ? OR email LIKE ?";
        return JdbcTemplate.query(sql, getBeanListHandler(), "%" + keyWord + "%", "%" + keyWord + "%");
    }

    public void emptyMessnum(User user) throws Exception {
        String sql = "UPDATE user SET mess_num=0 WHERE id=?";
        JdbcTemplate.update(sql, user.getId());
    }

    public User findById(int id) throws Exception {
        String sql = "SELECT id, email, pwd, name, stu_num, qq, phone, mess_num, img, role FROM user WHERE id=?";
        return JdbcTemplate.query(sql, getBeanHandler(), id);
    }

    public User findByEmail(String str) throws Exception {
        String sql = "SELECT id, email, pwd, name, stu_num, qq, phone, mess_num, img, role FROM user WHERE email=?";
        return JdbcTemplate.query(sql, getBeanHandler(), str);
    }

    public List<User> findAll(int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, email, pwd, name, stu_num, qq, phone, mess_num, img, role FROM user ORDER BY id DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getBeanListHandler(), limitMin, perPage);
    }

    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM user";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }

    public int countRecent(int days) throws Exception {
        String sql = "SELECT COUNT(*) FROM user WHERE id > (SELECT IFNULL(MAX(id),0) - ? FROM user)";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days * 2).toString());
    }

    public boolean doDelete(int userId) throws Exception {
        String sql = "DELETE FROM user WHERE id=?";
        return JdbcTemplate.update(sql, userId) > 0;
    }

    public boolean setRole(int userId, int role) throws Exception {
        String sql = "UPDATE user SET role=? WHERE id=?";
        return JdbcTemplate.update(sql, String.valueOf(role), userId) > 0;
    }

    public int[] dailyCounts(int days) {
        int[] result = new int[days];
        try {
            for (int i = 0; i < days; i++) {
                String sql = "SELECT COUNT(*) FROM user WHERE DATE(create_date) = DATE(DATE_SUB(NOW(), INTERVAL ? DAY))";
                result[i] = Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), days - 1 - i).toString());
            }
        } catch (Exception e) {
            // user table may not have create_date column
        }
        return result;
    }

    public int countGoodsByUser(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM goods WHERE producter_id=?";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), userId).toString());
    }

    public int countOrdersByUser(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM `order` WHERE user_id=?";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), userId).toString());
    }

    public boolean resetPassword(int userId, String newPwdMd5) throws Exception {
        String sql = "UPDATE user SET pwd=? WHERE id=?";
        return JdbcTemplate.update(sql, newPwdMd5, userId) > 0;
    }
}
