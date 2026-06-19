package com.luna.saltfish.dao;

import com.luna.saltfish.entity.Category;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.BasicRowProcessor;
import org.apache.commons.dbutils.BeanProcessor;
import org.apache.commons.dbutils.GenerousBeanProcessor;
import org.apache.commons.dbutils.RowProcessor;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.util.List;

public class CategoryHandle {

    private BeanHandler<Category> beanHandler;
    private BeanListHandler<Category> beanListHandler;

    public BeanHandler<Category> getBeanHandler() {
        if (beanHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanHandler<>(Category.class, processor);
        }
        return beanHandler;
    }

    public BeanListHandler<Category> getBeanListHandler() {
        if (beanListHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanListHandler<>(Category.class, processor);
        }
        return beanListHandler;
    }

    public boolean doCreate(Category c) throws Exception {
        String sql = "INSERT INTO category (name, icon, sort_order, is_active) VALUES (?, ?, ?, ?)";
        return JdbcTemplate.update(sql, c.getName(), c.getIcon(), c.getSortOrder(), c.getIsActive() ? 1 : 0) > 0;
    }

    public boolean doDelete(int id) throws Exception {
        String sql = "DELETE FROM category WHERE id=?";
        return JdbcTemplate.update(sql, id) > 0;
    }

    public boolean doUpdate(Category c) throws Exception {
        String sql = "UPDATE category SET name=?, icon=?, sort_order=?, is_active=? WHERE id=?";
        return JdbcTemplate.update(sql, c.getName(), c.getIcon(), c.getSortOrder(), c.getIsActive() ? 1 : 0, c.getId()) > 0;
    }

    public boolean toggleActive(int id, boolean active) throws Exception {
        String sql = "UPDATE category SET is_active=? WHERE id=?";
        return JdbcTemplate.update(sql, active ? 1 : 0, id) > 0;
    }

    public Category findById(int id) throws Exception {
        String sql = "SELECT id, name, icon, sort_order, is_active FROM category WHERE id=?";
        return JdbcTemplate.query(sql, getBeanHandler(), id);
    }

    public List<Category> findAllActive() throws Exception {
        String sql = "SELECT id, name, icon, sort_order, is_active FROM category WHERE is_active=1 ORDER BY sort_order ASC, id ASC";
        return JdbcTemplate.query(sql, getBeanListHandler());
    }

    public List<Category> findAll() throws Exception {
        String sql = "SELECT id, name, icon, sort_order, is_active FROM category ORDER BY sort_order ASC, id ASC";
        return JdbcTemplate.query(sql, getBeanListHandler());
    }

    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM category";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }

    public int getMaxSortOrder() throws Exception {
        String sql = "SELECT COALESCE(MAX(sort_order), 0) FROM category";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }
}