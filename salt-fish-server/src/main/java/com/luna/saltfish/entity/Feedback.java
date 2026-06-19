package com.luna.saltfish.entity;

import java.util.Date;

public class Feedback {
    private Integer id;
    private Integer userId;
    private String type;
    private String content;
    private String contact;
    private Date createTime;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}