package com.luna.saltfish.entity;

import java.util.Date;

public class Mess {
    private int messFromId;
    private int messToId;
    private String messText;
    private Date sendTime;
    private int messId;
    private int messType;
    private int isRead;

    public int getMessFromId() { return messFromId; }
    public void setMessFromId(int messFromId) { this.messFromId = messFromId; }

    public int getMessToId() { return messToId; }
    public void setMessToId(int messToId) { this.messToId = messToId; }

    public String getMessText() { return messText; }
    public void setMessText(String messText) { this.messText = messText; }

    public Date getSendTime() { return sendTime; }
    public void setSendTime(Date sendTime) { this.sendTime = sendTime; }

    public int getMessId() { return messId; }
    public void setMessId(int messId) { this.messId = messId; }

    public int getMessType() { return messType; }
    public void setMessType(int messType) { this.messType = messType; }

    public int getIsRead() { return isRead; }
    public void setIsRead(int isRead) { this.isRead = isRead; }
}