package com.luna.saltfish.dao;

import com.luna.saltfish.entity.Feedback;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.Timestamp;
import java.util.List;

public class FeedbackHandle {

    private BeanListHandler<Feedback> beanListHandler;

    public BeanListHandler<Feedback> getBeanListHandler() {
        if (beanListHandler == null) {
            return new BeanListHandler<>(Feedback.class);
        }
        return beanListHandler;
    }

    public boolean doCreate(Feedback f) throws Exception {
        String sql = "INSERT INTO feedback (user_id, type, content, contact, create_time) VALUES (?, ?, ?, ?, ?)";
        return JdbcTemplate.update(sql, f.getUserId(), f.getType(), f.getContent(),
            f.getContact(), new Timestamp(f.getCreateTime().getTime())) > 0;
    }

    public List<Feedback> findAll(int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, user_id, type, content, contact, create_time FROM feedback ORDER BY create_time DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getBeanListHandler(), limitMin, perPage);
    }

    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM feedback";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }

    public boolean doDelete(int id) throws Exception {
        String sql = "DELETE FROM feedback WHERE id=?";
        return JdbcTemplate.update(sql, id) > 0;
    }

    public List<Feedback> findByType(String type, int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, user_id, type, content, contact, create_time FROM feedback WHERE type=? ORDER BY create_time DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getBeanListHandler(), type, limitMin, perPage);
    }

    public int countByType(String type) throws Exception {
        String sql = "SELECT COUNT(*) FROM feedback WHERE type=?";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), type).toString());
    }
}