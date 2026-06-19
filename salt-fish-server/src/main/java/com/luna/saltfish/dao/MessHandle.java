package com.luna.saltfish.dao;

import com.luna.saltfish.entity.Mess;
import com.luna.saltfish.entity.User;
import com.luna.saltfish.util.PageResult;
import com.luna.saltfish.util.JdbcTemplate;
import org.apache.commons.dbutils.BasicRowProcessor;
import org.apache.commons.dbutils.BeanProcessor;
import org.apache.commons.dbutils.GenerousBeanProcessor;
import org.apache.commons.dbutils.RowProcessor;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import java.util.List;

/**
 * @author luna@mac
 */
public class MessHandle {

    private BeanHandler<Mess>     beanHandler;

    private BeanListHandler<Mess> beanListHandler;

    public BeanHandler<Mess> getBeanHandler() {

        if (beanHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanHandler<Mess>(Mess.class, processor);
        } else {
            return beanHandler;
        }
    }

    public void setBeanHandler(BeanHandler<Mess> beanHandler) {
        this.beanHandler = beanHandler;
    }

    public BeanListHandler<Mess> getBeanListHandler() {
        if (beanListHandler == null) {
            BeanProcessor bean = new GenerousBeanProcessor();
            RowProcessor processor = new BasicRowProcessor(bean);
            return new BeanListHandler<Mess>(Mess.class, processor);
        } else {
            return beanListHandler;
        }
    }

    public void setBeanListHandler(BeanListHandler<Mess> beanListHandler) {
        this.beanListHandler = beanListHandler;
    }

    /**
     * 创建一个消息
     * 
     * @param mess
     * @return
     * @throws Exception
     */
    public boolean doCreate(Mess mess) throws Exception {
        String sql = "INSERT INTO `message`(mess_from_id, mess_to_id, mess_text, send_time) VALUES (?, ?, ?, ?)";
        return JdbcTemplate.update(sql, mess.getMessFromId(), mess.getMessToId(), mess.getMessText(),
            new java.sql.Timestamp(mess.getSendTime().getTime())) > 0;
    }

    /**
     * 通过用户Id查询用户所有消息
     * 
     * @param num
     * @param user
     * @param limitMin
     * @param perPage
     * @return
     * @throws Exception
     */
    public List<Mess> findAllMessByUser(PageResult num, User user, int limitMin, int perPage, String sort) throws Exception {
        String orderBy = "send_time desc, mess_id desc";
        if ("date_asc".equals(sort)) orderBy = "send_time asc, mess_id desc";
        else if ("unread".equals(sort)) orderBy = "is_read asc, send_time desc, mess_id desc";
        String sql =
            "SELECT mess_id, mess_from_id, mess_to_id, send_time, mess_text, is_read from `message` where mess_to_id=? order by " + orderBy + " limit ?,?";
        List<Mess> messList = JdbcTemplate.query(sql, getBeanListHandler(), user.getId(), limitMin, perPage);
        String count = "SELECT count(*) from message  where mess_to_id=?";
        num.value = Integer
            .parseInt(JdbcTemplate.query(count, new ScalarHandler<>(), user.getId()).toString());
        return messList;
    }

    /**
     * 删除指定消息
     * 
     * @param messId
     * @param userId
     * @return
     * @throws Exception
     */
    public boolean removeOneMess(int messId, int userId) throws Exception {
        String sql = "Delete from `message` where mess_id=? and mess_to_id=?";
        return JdbcTemplate.update(sql, messId, userId) > 0;
    }

    public Mess findById(int messId, int userId) throws Exception {
        String sql = "SELECT mess_id, mess_from_id, mess_to_id, send_time, mess_text, is_read FROM message WHERE mess_id=? AND mess_to_id=?";
        return JdbcTemplate.query(sql, getBeanHandler(), messId, userId);
    }
    public boolean markAsRead(int messId, int userId) throws Exception {
        String sql = "UPDATE `message` SET is_read=1 WHERE mess_id=? AND mess_to_id=?";
        return JdbcTemplate.update(sql, messId, userId) > 0;
    }

    public boolean markAllAsRead(int userId) throws Exception {
        String sql = "UPDATE `message` SET is_read=1 WHERE mess_to_id=? AND is_read=0";
        return JdbcTemplate.update(sql, userId) > 0;
    }

    public int countUnread(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM `message` WHERE mess_to_id=? AND is_read=0";
        return Integer.parseInt(JdbcTemplate.query(sql, new ScalarHandler<>(), userId).toString());
    }
}
