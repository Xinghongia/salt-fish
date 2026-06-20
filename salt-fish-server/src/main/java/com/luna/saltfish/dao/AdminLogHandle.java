package com.luna.saltfish.dao;

import com.luna.saltfish.entity.AdminLog;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.sql.Timestamp;
import java.util.List;

public class AdminLogHandle {

    private BeanListHandler<AdminLog> beanListHandler;

    public BeanListHandler<AdminLog> getBeanListHandler() {
        if (beanListHandler == null) {
            return new BeanListHandler<>(AdminLog.class);
        }
        return beanListHandler;
    }

    public boolean doCreate(AdminLog log) throws Exception {
        String sql = "INSERT INTO admin_log (admin_id, admin_name, action, target, detail, create_time) VALUES (?, ?, ?, ?, ?, ?)";
        return JdbcTemplate.update(sql, log.getAdminId(), log.getAdminName(), log.getAction(),
            log.getTarget(), log.getDetail(), new Timestamp(log.getCreateTime().getTime())) > 0;
    }

    public List<AdminLog> findAll(int limitMin, int perPage) throws Exception {
        String sql = "SELECT id, admin_id, admin_name, action, target, detail, create_time FROM admin_log ORDER BY create_time DESC LIMIT ?,?";
        return JdbcTemplate.query(sql, getBeanListHandler(), limitMin, perPage);
    }

    public int countAll() throws Exception {
        String sql = "SELECT COUNT(*) FROM admin_log";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>()).toString());
    }

    public boolean doDelete(int id) throws Exception {
        String sql = "DELETE FROM admin_log WHERE id=?";
        return JdbcTemplate.update(sql, id) > 0;
    }

    public boolean doDeleteAll() throws Exception {
        String sql = "DELETE FROM admin_log";
        return JdbcTemplate.update(sql) > 0;
    }
}
