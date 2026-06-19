/**
 * Salt Fish - Admin Console v3
 * Full admin logic: modals, CRUD, confirm dialogs, logging
 */
var Admin = {
    /* ---- Batch Operations Framework ---- */
    _batchBar: null,
    _batchCount: null,
    _selectedIds: [],

    initBatch: function(tableId, barId) {
        var table = document.getElementById(tableId);
        var bar = document.getElementById(barId);
        if (!table || !bar) return;
        Admin._batchBar = bar;
        Admin._batchCount = bar.querySelector('.batch-count');
        var selectAll = table.querySelector('th .batch-select-all');
        var checkboxes = table.querySelectorAll('td .batch-select');

        if (selectAll) {
            selectAll.addEventListener('change', function() {
                checkboxes.forEach(function(cb) {
                    cb.checked = selectAll.checked;
                });
                Admin._updateBatch();
            });
        }
        checkboxes.forEach(function(cb) {
            cb.addEventListener('change', function() {
                Admin._updateBatch();
                if (selectAll) {
                    var allChecked = checkboxes.length > 0;
                    checkboxes.forEach(function(c) { if (!c.checked) allChecked = false; });
                    selectAll.checked = allChecked;
                }
            });
        });
    },

    _updateBatch: function() {
        var allCbs = document.querySelectorAll('td .batch-select');
        var checked = document.querySelectorAll('td .batch-select:checked');
        Admin._selectedIds = [];
        checked.forEach(function(cb) {
            Admin._selectedIds.push(cb.value);
            var tr = cb.closest('tr');
            if (tr) tr.classList.add('row-selected');
        });
        allCbs.forEach(function(cb) {
            if (!cb.checked) {
                var tr = cb.closest('tr');
                if (tr) tr.classList.remove('row-selected');
            }
        });
        if (Admin._batchBar) {
            if (Admin._selectedIds.length > 0) {
                Admin._batchBar.classList.add('show');
                if (Admin._batchCount) Admin._batchCount.textContent = Admin._selectedIds.length;
            } else {
                Admin._batchBar.classList.remove('show');
            }
        }
    },

    _getSelectedIds: function() {
        return Admin._selectedIds.join(',');
    },

    batchRequest: function(action, params, callback) {
        var ids = Admin._getSelectedIds();
        if (!ids) {
            SaltFish.showToast('warning', '\u8bf7\u5148\u9009\u62e9\u6570\u636e');
            return;
        }
        var body = 'ids=' + encodeURIComponent(ids);
        if (params) body += '&' + params;
        SaltFish.ajax('api/admin/action?action=' + action, {
            method: 'POST',
            body: body,
            callback: function(resp) {
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', '\u64cd\u4f5c\u6210\u529f');
                    if (callback) callback(resp);
                    else setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                }
            }
        });
    },

    batchDeleteGoods: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u5546\u54c1\uff1f', function() {
            Admin.batchRequest('batchDeleteGoods');
        });
    },
    batchAuditGoods: function(status) {
        var action = status == 2 ? '\u901a\u8fc7' : '\u62d2\u7edd';
        Admin.confirm('\u786e\u5b9a' + action + '\u9009\u4e2d\u7684\u5546\u54c1\uff1f', function() {
            Admin.batchRequest('batchAuditGoods', 'status=' + status);
        });
    },
    batchDeleteUsers: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u7528\u6237\uff1f\u7ba1\u7406\u5458\u4e0d\u4f1a\u88ab\u5220\u9664\u3002', function() {
            Admin.batchRequest('batchDeleteUsers');
        });
    },
    batchSetRole: function(role) {
        var roleName = role == 1 ? '\u7ba1\u7406\u5458' : '\u666e\u901a\u7528\u6237';
        Admin.confirm('\u786e\u5b9a\u5c06\u9009\u4e2d\u7528\u6237\u8bbe\u4e3a' + roleName + '\uff1f', function() {
            Admin.batchRequest('batchSetRole', 'role=' + role);
        });
    },
    batchDeleteOrders: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u8ba2\u5355\uff1f', function() {
            Admin.batchRequest('batchDeleteOrders');
        });
    },
    batchDeleteAnnouncements: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u516c\u544a\uff1f', function() {
            Admin.batchRequest('batchDeleteAnnouncements');
        });
    },
    batchToggleAnnouncements: function(active) {
        var action = active ? '\u663e\u793a' : '\u9690\u85cf';
        Admin.confirm('\u786e\u5b9a' + action + '\u9009\u4e2d\u7684\u516c\u544a\uff1f', function() {
            Admin.batchRequest('batchToggleAnnouncements', 'active=' + active);
        });
    },
    batchDeleteFeedback: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u53cd\u9988\uff1f', function() {
            Admin.batchRequest('batchDeleteFeedback');
        });
    },
    batchDeleteCategories: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u5206\u7c7b\uff1f\u5df2\u6709\u5546\u54c1\u5c06\u5931\u53bb\u5206\u7c7b\u3002', function() {
            Admin.batchRequest('batchDeleteCategories');
        });
    },
    batchToggleCategories: function(active) {
        var action = active ? '\u542f\u7528' : '\u7981\u7528';
        Admin.confirm('\u786e\u5b9a' + action + '\u9009\u4e2d\u7684\u5206\u7c7b\uff1f', function() {
            Admin.batchRequest('batchToggleCategories', 'active=' + active);
        });
    },
    batchDeleteLogs: function() {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u9009\u4e2d\u7684\u65e5\u5fd7\uff1f', function() {
            Admin.batchRequest('batchDeleteLogs');
        });
    },

    path: function() { return SaltFish.path; },

    ajax: function(url, opts) {
        opts = opts || {};
        SaltFish.ajax(url, opts);
    },

    /* ---- Modal system ---- */
    showModal: function(id) {
        var bd = document.getElementById(id);
        if (bd) { bd.classList.add('show'); document.body.style.overflow = 'hidden'; }
    },

    hideModal: function(id) {
        var bd = document.getElementById(id);
        if (bd) { bd.classList.remove('show'); document.body.style.overflow = ''; }
    },

    hideAllModals: function() {
        document.querySelectorAll('.modal-backdrop.show').forEach(function(bd) {
            bd.classList.remove('show');
        });
        document.body.style.overflow = '';
    },

    /* ---- Custom confirm dialog ---- */
    confirm: function(message, onConfirm) {
        var existing = document.getElementById('adminConfirmDialog');
        if (existing) existing.remove();

        var bd = document.createElement('div');
        bd.className = 'modal-backdrop';
        bd.id = 'adminConfirmDialog';
        bd.innerHTML =
            '<div class="modal" style="max-width:420px">' +
                '<div class="modal-header">' +
                    '<h3>' + message + '</h3>' +
                '</div>' +
                '<div class="modal-footer">' +
                    '<button class="btn btn-ghost" data-action="cancel">\u53d6\u6d88</button>' +
                    '<button class="btn btn-danger" data-action="confirm">\u786e\u8ba4</button>' +
                '</div>' +
            '</div>';
        document.body.appendChild(bd);

        bd.querySelector('[data-action="cancel"]').onclick = function() {
            bd.classList.remove('show');
            setTimeout(function() { bd.remove(); }, 300);
        };
        bd.querySelector('[data-action="confirm"]').onclick = function() {
            bd.classList.remove('show');
            setTimeout(function() { bd.remove(); }, 300);
            onConfirm();
        };

        requestAnimationFrame(function() { bd.classList.add('show'); });
    },

    /* ---- User Management ---- */
    showUserDetail: function(id, name, email, phone, stuNum, img, role, msgCount) {
        document.getElementById('udAvatar').src = img || (Admin.path() + 'static/user_img/0.jpg');
        document.getElementById('udName').textContent = name || '\u672a\u8bbe\u7f6e\u6635\u79f0';
        document.getElementById('udRole').innerHTML = role == 1
            ? '<span class="badge badge-primary"><i data-lucide="shield" style="width:12px;height:12px"></i> \u7ba1\u7406\u5458</span>'
            : '<span class="badge badge-secondary">\u666e\u901a\u7528\u6237</span>';
        document.getElementById('udEmail').textContent = email || '-';
        document.getElementById('udPhone').textContent = phone || '-';
        document.getElementById('udStuNum').textContent = stuNum || '-';
        document.getElementById('udMsgCount').textContent = msgCount || 0;
        Admin._currentUserId = id;
        Admin.showModal('userModal');
        SaltFish.initIcons();
    },

    showAddUserModal: function() {
        var form = document.getElementById('addUserForm');
        if (form) form.reset();
        Admin.showModal('addUserModal');
    },

    addUser: function() {
        var form = document.getElementById('addUserForm');
        var email = form.querySelector('[name="email"]').value.trim();
        var pwd = form.querySelector('[name="pwd"]').value.trim();
        var name = form.querySelector('[name="name"]').value.trim();
        var phone = form.querySelector('[name="phone"]').value.trim();

        if (!email || !pwd) {
            SaltFish.showToast('warning', '\u8bf7\u586b\u5199\u90ae\u7bb1\u548c\u5bc6\u7801');
            return;
        }

        var btn = document.querySelector('#addUserModal .btn-primary');
        SaltFish._setLoading(btn, true);

        Admin.ajax('api/admin/action?action=addUser&email=' + encodeURIComponent(email) +
            '&pwd=' + encodeURIComponent(pwd) +
            '&name=' + encodeURIComponent(name) +
            '&phone=' + encodeURIComponent(phone), {
            callback: function(resp) {
                SaltFish._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', '\u7528\u6237\u6dfb\u52a0\u6210\u529f');
                    Admin.hideAllModals();
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    var msg = (resp && resp.indexOf('error:') >= 0) ? resp.replace('error:', '') : '\u6dfb\u52a0\u5931\u8d25';
                    SaltFish.showToast('error', msg);
                }
            }
        });
    },

    showEditUserModal: function(id, name, phone, stuNum) {
        document.getElementById('editUserId').value = id;
        document.getElementById('editUserName').value = name || '';
        document.getElementById('editUserPhone').value = phone || '';
        document.getElementById('editUserStuNum').value = stuNum || '';
        Admin.showModal('editUserModal');
    },

    saveEditUser: function() {
        var id = document.getElementById('editUserId').value;
        var name = document.getElementById('editUserName').value.trim();
        var phone = document.getElementById('editUserPhone').value.trim();
        var stuNum = document.getElementById('editUserStuNum').value.trim();

        var btn = document.querySelector('#editUserModal .btn-primary');
        SaltFish._setLoading(btn, true);

        Admin.ajax('api/admin/action?action=editUser&userId=' + id +
            '&name=' + encodeURIComponent(name) +
            '&phone=' + encodeURIComponent(phone) +
            '&stuNum=' + encodeURIComponent(stuNum), {
            callback: function(resp) {
                SaltFish._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', '\u7528\u6237\u4fe1\u606f\u5df2\u66f4\u65b0');
                    Admin.hideAllModals();
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u66f4\u65b0\u5931\u8d25');
                }
            }
        });
    },

    setRole: function(userId, role) {
        var roleName = role == 1 ? '\u7ba1\u7406\u5458' : '\u666e\u901a\u7528\u6237';
        Admin.confirm('\u786e\u5b9a\u5c06\u8be5\u7528\u6237\u8bbe\u4e3a' + roleName + '\uff1f', function() {
            Admin.ajax('api/admin/action?action=setRole&userId=' + userId + '&role=' + role, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u89d2\u8272\u5df2\u66f4\u65b0');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                    }
                }
            });
        });
    },

    deleteUser: function(userId) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u7528\u6237\uff1f\u6b64\u64cd\u4f5c\u4e0d\u53ef\u64a4\u9500\u3002', function() {
            Admin.ajax('api/admin/action?action=deleteUser&userId=' + userId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u7528\u6237\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25\uff08\u4e0d\u80fd\u5220\u9664\u7ba1\u7406\u5458\uff09');
                    }
                }
            });
        });
    },

    /* ---- Goods Management ---- */
    showGoodsDetail: function(id, name, price, seller, status, time, desc, image) {
        document.getElementById('gdImage').src = image || '';
        document.getElementById('gdName').textContent = name || '';
        document.getElementById('gdPrice').textContent = '\u00a5' + (price || '0');
        document.getElementById('gdSeller').textContent = seller || '\u5df2\u5220\u9664';
        document.getElementById('gdDesc').textContent = desc || '\u65e0\u63cf\u8ff0';

        var statusMap = { '1': ['\u5f85\u5ba1\u6838', 'badge-warning'], '2': ['\u5728\u552e', 'badge-success'], '3': ['\u5df2\u62d2\u7edd', 'badge-danger'], '4': ['\u4ea4\u6613\u4e2d', 'badge-info'], '5': ['\u5df2\u552e\u51fa', 'badge-secondary'] };
        var st = statusMap[status] || ['\u672a\u77e5', 'badge-secondary'];
        document.getElementById('gdStatus').innerHTML = '<span class="badge ' + st[1] + '">' + st[0] + '</span>';
        document.getElementById('gdTime').textContent = time || '';

        var actionsEl = document.getElementById('gdActions');
        actionsEl.innerHTML = '';
        if (status === '1') {
            actionsEl.innerHTML =
                '<button class="btn btn-success btn-sm" onclick="Admin.auditing(' + id + ', 2)"><i data-lucide="check" class="icon-sm"></i> \u901a\u8fc7</button>' +
                '<button class="btn btn-warning btn-sm" onclick="Admin.auditing(' + id + ', 3)"><i data-lucide="x" class="icon-sm"></i> \u62d2\u7edd</button>';
        }
        if (status === '4') {
            actionsEl.innerHTML +=
                '<button class="btn btn-success btn-sm" onclick="Admin.toggleGoodsStatus(' + id + ', 5)"><i data-lucide="check-circle" class="icon-sm"></i> \u6807\u8bb0\u5df2\u552e\u51fa</button>' +
                '<button class="btn btn-warning btn-sm" onclick="Admin.toggleGoodsStatus(' + id + ', 2)"><i data-lucide="rotate-ccw" class="icon-sm"></i> \u6062\u590d\u5728\u552e</button>';
        }
        if (status === '3') {
            actionsEl.innerHTML +=
                '<button class="btn btn-success btn-sm" onclick="Admin.toggleGoodsStatus(' + id + ', 2)"><i data-lucide="rotate-ccw" class="icon-sm"></i> \u6062\u590d\u5728\u552e</button>';
        }
        if (status === '5') {
            actionsEl.innerHTML +=
                '<button class="btn btn-warning btn-sm" onclick="Admin.toggleGoodsStatus(' + id + ', 2)"><i data-lucide="rotate-ccw" class="icon-sm"></i> \u6062\u590d\u5728\u552e</button>';
        }
        actionsEl.innerHTML += '<button class="btn btn-ghost btn-sm" onclick="Admin.deleteGoods(' + id + ')"><i data-lucide="trash-2" class="icon-sm"></i> \u5220\u9664</button>';

        Admin.showModal('goodsModal');
        SaltFish.initIcons();
    },

    auditing: function(goodsId, pass) {
        var btn = event.target.closest('button');
        SaltFish._setLoading(btn, true);
        Admin.ajax('api/auditing?goodsId=' + goodsId + '&pass=' + pass, {
            callback: function(resp) {
                SaltFish._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', pass === 2 ? '\u5df2\u901a\u8fc7' : '\u5df2\u62d2\u7edd');
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                }
            }
        });
    },

    deleteGoods: function(goodsId) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u5546\u54c1\uff1f\u6b64\u64cd\u4f5c\u4e0d\u53ef\u64a4\u9500\u3002', function() {
            Admin.ajax('api/admin/action?action=deleteGoods&goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u5546\u54c1\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25');
                    }
                }
            });
        });
    },

    /* ---- Announcement Management ---- */
    createAnnouncement: function(form) {
        var title = form.querySelector('[name="title"]').value.trim();
        var content = form.querySelector('[name="content"]').value.trim();
        if (!title || !content) {
            SaltFish.showToast('warning', '\u8bf7\u586b\u5199\u5b8c\u6574');
            return;
        }
        var btn = form.querySelector('button[type="submit"]');
        SaltFish._setLoading(btn, true);

        SaltFish.ajax('admin/announcements', {
            method: 'POST',
            body: 'title=' + encodeURIComponent(title) + '&content=' + encodeURIComponent(content),
            callback: function(resp, status) {
                SaltFish._setLoading(btn, false);
                if (status === 200 || status === 302 || resp !== null) {
                    SaltFish.showToast('success', '\u53d1\u5e03\u6210\u529f');
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u53d1\u5e03\u5931\u8d25');
                }
            }
        });
    },

    toggleAnnouncement: function(id, active) {
        var action = active ? '\u663e\u793a' : '\u9690\u85cf';
        Admin.ajax('admin/announcements?action=toggle&id=' + id + '&active=' + active, {
            callback: function(resp) {
                if (resp !== null) {
                    SaltFish.showToast('success', '\u5df2' + action);
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                }
            }
        });
    },

    deleteAnnouncement: function(id) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u516c\u544a\uff1f', function() {
            Admin.ajax('admin/announcements?action=delete&id=' + id, {
                callback: function(resp) {
                    if (resp !== null) {
                        SaltFish.showToast('success', '\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25');
                    }
                }
            });
        });
    },

    editAnnouncement: function(id) {
        var row = document.querySelector('tr[data-ann-id="' + id + '"]');
        if (!row) return;
        document.getElementById('editAnnId').value = id;
        document.getElementById('editAnnTitle').value = row.dataset.title;
        document.getElementById('editAnnContent').value = row.dataset.content;
        Admin.showModal('editAnnModal');
    },

    saveEditAnnouncement: function() {
        var id = document.getElementById('editAnnId').value;
        var title = document.getElementById('editAnnTitle').value.trim();
        var content = document.getElementById('editAnnContent').value.trim();
        if (!title || !content) {
            SaltFish.showToast('warning', '\u8bf7\u586b\u5199\u5b8c\u6574');
            return;
        }
        var btn = document.querySelector('#editAnnModal .btn-primary');
        SaltFish._setLoading(btn, true);

        SaltFish.ajax('admin/announcements?action=edit&id=' + id, {
            method: 'POST',
            body: 'title=' + encodeURIComponent(title) + '&content=' + encodeURIComponent(content),
            callback: function(resp) {
                SaltFish._setLoading(btn, false);
                if (resp !== null) {
                    SaltFish.showToast('success', '\u5df2\u66f4\u65b0');
                    Admin.hideAllModals();
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u66f4\u65b0\u5931\u8d25');
                }
            }
        });
    },


    /* ---- Category Management ---- */
    createCategory: function(form) {
        var name = form.querySelector('[name="name"]').value.trim();
        var icon = form.querySelector('[name="icon"]').value.trim() || 'tag';
        var sortOrder = form.querySelector('[name="sortOrder"]').value;
        if (!name) {
            SaltFish.showToast('warning', '\u8bf7\u586b\u5199\u5206\u7c7b\u540d\u79f0');
            return;
        }
        var btn = form.querySelector('button[type="submit"]');
        SaltFish._setLoading(btn, true);
        SaltFish.ajax('admin/categories', {
            method: 'POST',
            body: 'action=create&name=' + encodeURIComponent(name) + '&icon=' + encodeURIComponent(icon) + '&sortOrder=' + encodeURIComponent(sortOrder),
            callback: function(resp) {
                SaltFish._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', '\u6dfb\u52a0\u6210\u529f');
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u6dfb\u52a0\u5931\u8d25');
                }
            }
        });
    },

    toggleCategory: function(id, active) {
        var action = active ? '\u542f\u7528' : '\u7981\u7528';
        Admin.ajax('admin/categories?action=toggle&id=' + id + '&active=' + active, {
            callback: function(resp) {
                if (resp !== null) {
                    SaltFish.showToast('success', '\u5df2' + action);
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25');
                }
            }
        });
    },

    deleteCategory: function(id) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u5206\u7c7b\uff1f\u5df2\u6709\u5546\u54c1\u5c06\u5931\u53bb\u5206\u7c7b\u5f52\u5c5e\u3002', function() {
            Admin.ajax('admin/categories?action=delete&id=' + id, {
                callback: function(resp) {
                    if (resp !== null) {
                        SaltFish.showToast('success', '\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25');
                    }
                }
            });
        });
    },

    editCategory: function(id) {
        var row = document.querySelector('tr[data-cat-id="' + id + '"]');
        if (!row) return;
        document.getElementById('editCatId').value = id;
        document.getElementById('editCatName').value = row.dataset.name;
        document.getElementById('editCatIcon').value = row.dataset.icon || 'tag';
        document.getElementById('editCatSort').value = row.dataset.sort || 0;
        Admin.showModal('editCatModal');
    },

    saveEditCategory: function() {
        var id = document.getElementById('editCatId').value;
        var name = document.getElementById('editCatName').value.trim();
        var icon = document.getElementById('editCatIcon').value.trim() || 'tag';
        var sortOrder = document.getElementById('editCatSort').value;
        if (!name) {
            SaltFish.showToast('warning', '\u8bf7\u586b\u5199\u5206\u7c7b\u540d\u79f0');
            return;
        }
        var btn = document.querySelector('#editCatModal .btn-primary');
        SaltFish._setLoading(btn, true);
        SaltFish.ajax('admin/categories', {
            method: 'POST',
            body: 'action=edit&id=' + id + '&name=' + encodeURIComponent(name) + '&icon=' + encodeURIComponent(icon) + '&sortOrder=' + encodeURIComponent(sortOrder),
            callback: function(resp) {
                SaltFish._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', '\u5df2\u66f4\u65b0');
                    Admin.hideAllModals();
                    setTimeout(function() { location.reload(); }, 600);
                } else {
                    SaltFish.showToast('error', '\u66f4\u65b0\u5931\u8d25');
                }
            }
        });
    },
    /* ---- Feedback Management ---- */
    deleteFeedback: function(fbId) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u53cd\u9988\uff1f', function() {
            Admin.ajax('api/admin/action?action=deleteFeedback&feedbackId=' + fbId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else { SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25'); }
                }
            });
        });
    },

    /* ---- Logs Management ---- */
    deleteLog: function(logId) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u65e5\u5fd7\u8bb0\u5f55\uff1f', function() {
            Admin.ajax('api/admin/action?action=deleteLog&logId=' + logId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25');
                    }
                }
            });
        });
    },

    clearLogs: function() {
        Admin.confirm('\u786e\u5b9a\u6e05\u7a7a\u6240\u6709\u64cd\u4f5c\u65e5\u5fd7\uff1f\u6b64\u64cd\u4f5c\u4e0d\u53ef\u64a4\u9500\u3002', function() {
            Admin.ajax('api/admin/action?action=clearLogs', {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u65e5\u5fd7\u5df2\u6e05\u7a7a');
                        setTimeout(function() { location.reload(); }, 600);
                    } else {
                        SaltFish.showToast('error', '\u6e05\u7a7a\u5931\u8d25');
                    }
                }
            });
        });
    },

    /* ---- Order Management ---- */
    showOrderDetail: function(id, goodsName, price, buyer, seller, status, time, msg) {
        document.getElementById('odId').textContent = '#' + id;
        document.getElementById('odGoods').textContent = goodsName || '-';
        document.getElementById('odPrice').textContent = '\u00a5' + (parseFloat(price) || 0).toFixed(2);
        document.getElementById('odBuyer').textContent = buyer || '-';
        document.getElementById('odSeller').textContent = seller || '-';
        document.getElementById('odTime').textContent = time || '-';
        document.getElementById('odMsg').textContent = msg || '\u65e0';
        var statusNames = { '4': '\u4ea4\u6613\u4e2d', '5': '\u5df2\u5b8c\u6210' };
        var statusColors = { '4': 'badge-info', '5': 'badge-success' };
        document.getElementById('odStatus').innerHTML = '<span class="badge ' + (statusColors[status] || 'badge-secondary') + '">' + (statusNames[status] || '-') + '</span>';
        Admin.showModal('orderModal');
        SaltFish.initIcons();
    },

    cancelOrderAdmin: function(goodsId) {
        Admin.confirm('\u786e\u5b9a\u53d6\u6d88\u8be5\u4ea4\u6613\uff1f\u5546\u54c1\u5c06\u6062\u590d\u4e3a\u5728\u552e\u3002', function() {
            Admin.ajax('api/admin/action?action=cancelOrderAdmin&goodsId=' + goodsId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u4ea4\u6613\u5df2\u53d6\u6d88');
                        setTimeout(function() { location.reload(); }, 600);
                    } else { SaltFish.showToast('error', '\u64cd\u4f5c\u5931\u8d25'); }
                }
            });
        });
    },

    deleteOrder: function(orderId) {
        Admin.confirm('\u786e\u5b9a\u5220\u9664\u8be5\u8ba2\u5355\u8bb0\u5f55\uff1f', function() {
            Admin.ajax('api/admin/action?action=deleteOrder&orderId=' + orderId, {
                callback: function(resp) {
                    if (resp && resp.indexOf('success') >= 0) {
                        SaltFish.showToast('success', '\u5df2\u5220\u9664');
                        setTimeout(function() { location.reload(); }, 600);
                    } else { SaltFish.showToast('error', '\u5220\u9664\u5931\u8d25'); }
                }
            });
        });
    },

    exportOrders: function() {
        window.location.href = Admin.path() + 'api/admin/action?action=exportOrders';
    },

    exportGoods: function() {
        window.location.href = Admin.path() + 'api/admin/action?action=exportGoods';
    },

    exportUsers: function() {
        window.location.href = Admin.path() + 'api/admin/action?action=exportUsers';
    },

    filterByCategory: function(catId) {
        var url = new URL(window.location.href);
        if (catId) { url.searchParams.set('category', catId); } else { url.searchParams.delete('category'); }
        url.searchParams.delete('pn');
        window.location.href = url.toString();
    },

    /* ---- Generic table search ---- */
    filterTable: function(input, tableId) {
        var keyword = input.value.toLowerCase();
        var rows = document.querySelectorAll('#' + tableId + ' tbody tr');
        rows.forEach(function(row) {
            var text = row.textContent.toLowerCase();
            row.style.display = text.indexOf(keyword) >= 0 ? '' : 'none';
        });
    }
};

/* ---- Init ---- */
document.addEventListener('DOMContentLoaded', function() {
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal-backdrop')) {
            Admin.hideAllModals();
        }
        if (e.target.closest('[data-dismiss="modal"]')) {
            Admin.hideAllModals();
        }
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') Admin.hideAllModals();
    });
});
