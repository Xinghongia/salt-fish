package com.luna.saltfish.dao;

import com.luna.saltfish.entity.SystemSetting;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

import java.util.List;

public class SystemSettingHandle {

    private BeanListHandler<SystemSetting> beanListHandler;

    public BeanListHandler<SystemSetting> getBeanListHandler() {
        if (beanListHandler == null) {
            return new BeanListHandler<>(SystemSetting.class);
        }
        return beanListHandler;
    }

    public String getValue(String key) throws Exception {
        String sql = "SELECT setting_value FROM system_setting WHERE setting_key=?";
        Object result = JdbcTemplate.query(sql, new org.apache.commons.dbutils.handlers.ScalarHandler<>(), key);
        return result != null ? result.toString() : null;
    }

    public boolean setValue(String key, String value) throws Exception {
        String existing = getValue(key);
        if (existing != null) {
            String sql = "UPDATE system_setting SET setting_value=? WHERE setting_key=?";
            return JdbcTemplate.update(sql, value, key) > 0;
        } else {
            String sql = "INSERT INTO system_setting (setting_key, setting_value) VALUES (?, ?)";
            return JdbcTemplate.update(sql, key, value) > 0;
        }
    }

    public List<SystemSetting> findAll() throws Exception {
        String sql = "SELECT id, setting_key, setting_value, description FROM system_setting ORDER BY id";
        return JdbcTemplate.query(sql, getBeanListHandler());
    }
}