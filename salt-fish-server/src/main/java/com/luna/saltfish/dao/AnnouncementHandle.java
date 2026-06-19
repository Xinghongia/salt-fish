package com.luna.saltfish.dao;

import com.luna.saltfish.entity.Announcement;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.BasicRowProcessor;
import org.apache.commons.dbutils.BeanProcessor;
import org.apache.commons.dbutils.GenerousBeanProcessor;
import org.apache.commons.dbutils.RowProcessor;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.Timestamp;
import java.util.List;

public class AnnouncementHandle {

    private BeanHandler<Announcement> beanHandler;
    private BeanListHandler<Announcement> beanListHandler;

    public BeanHandler<Announcement> getBeanHandler() {
        if (beanHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanHandler<>(Announcement.class, processor);
        }
        return beanHandler;
    }

    public BeanListHandler<Announcement> getBeanListHandler() {
        if (beanListHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanListHandler<>(Announcement.class, processor);
        }
        return beanListHandler;
    }

    public boolean doCreate(Announcement a) throws Exception {
        String sql = "INSERT INTO announcement (title, content, admin_id, is_active, create_time) VALUES (?, ?, ?, ?, ?)";
        return JdbcTemplate.update(sql, a.getTitle(), a.getContent(), a.getAdminId(),
            a.getIsActive() ? 1 : 0, new Timestamp(a.getCreateTime().getTime())) > 0;
    }

    public boolean doDelete(int id) throws Exception {
        String sql = "DELETE FROM announcement WHERE id=?";
        return JdbcTemplate.update(sql, id) > 0;
    }

    public boolean doUpdate(int id, String title, String content) throws Exception {
        String sql = "UPDATE announcement SET title=?, content=? WHERE id=?";
        return JdbcTemplate.update(sql, title, content, id) > 0;
    }

    public boolean toggleActive(int id, boolean active) throws Exception {
        String sql = "UPDATE announcement SET is_active=? WHERE id=?";
        return JdbcTemplate.update(sql, active ? 1 : 0, id) > 0;
    }

    public List<Announcement> findActive() throws Exception {
        String sql = "SELECT id, title, content, admin_id, is_active, create_time FROM announcement WHERE is_active=1 ORDER BY create_time DESC LIMIT 5";
        return JdbcTemplate.query(sql, getBeanListHandler());
    }

    public List<Announcement> findAll() throws Exception {
        String sql = "SELECT id, title, content, admin_id, is_active, create_time FROM announcement ORDER BY create_time DESC";
        return JdbcTemplate.query(sql, getBeanListHandler());
    }

    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM announcement";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }
}