package com.luna.saltfish.entity;

public class SystemSetting {
    private int id;
    private String settingKey;
    private String settingValue;
    private String description;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getSettingKey() { return settingKey; }
    public void setSettingKey(String settingKey) { this.settingKey = settingKey; }
    public String getSettingValue() { return settingValue; }
    public void setSettingValue(String settingValue) { this.settingValue = settingValue; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}