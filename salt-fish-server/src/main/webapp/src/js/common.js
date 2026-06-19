/**
 * Salt Fish - Common JavaScript Utilities
 */
var SaltFish = {
    path: '',
    _busy: {},

    init: function() {
        this.path = document.querySelector('meta[name="ctx"]')?.getAttribute('content') || '';
        this.initIcons();
        this.initToasts();
        this.initAnimations();
        this.initFormProtection();
    },

    initIcons: function() {
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    },

    initAnimations: function() {
        var cards = document.querySelectorAll('.product-card, .stat-card, .card, .action-card');
        if (!cards.length) return;
        var observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });
        cards.forEach(function(card, i) {
            card.style.opacity = '0';
            card.style.transform = 'translateY(16px)';
            card.style.transition = 'opacity 0.4s ease ' + (i % 4) * 0.08 + 's, transform 0.4s ease ' + (i % 4) * 0.08 + 's';
            observer.observe(card);
        });
    },

    // Form submit protection - prevent double submit
    initFormProtection: function() {
        var forms = document.querySelectorAll('form');
        forms.forEach(function(form) {
            form.addEventListener('submit', function() {
                var btn = form.querySelector('button[type="submit"], input[type="submit"]');
                if (btn && !btn.disabled) {
                    btn.disabled = true;
                    btn.style.opacity = '0.7';
                    btn.style.cursor = 'not-allowed';
                    var origText = btn.innerHTML;
                    btn.setAttribute('data-orig-text', origText);
                    btn.innerHTML = '<span class="loading-spinner" style="width:16px;height:16px;border-width:2px;margin-right:6px"></span>' + (btn.getAttribute('data-loading-text') || '\u63d0\u4ea4\u4e2d...');
                    // Re-enable after 5s as safety net
                    setTimeout(function() {
                        btn.disabled = false;
                        btn.style.opacity = '';
                        btn.style.cursor = '';
                        btn.innerHTML = btn.getAttribute('data-orig-text') || origText;
                    }, 5000);
                }
            });
        });
    },

    showToast: function(type, title, message, duration) {
        duration = duration || 3000;
        var container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container';
            document.body.appendChild(container);
        }
        var iconMap = {
            success: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
            error: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>',
            warning: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>',
            info: '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>'
        };
        var toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        toast.innerHTML = '<span class="toast-icon">' + (iconMap[type] || iconMap.info) + '</span><div class="toast-content"><div class="toast-title">' + title + '</div>' + (message ? '<div class="toast-message">' + message + '</div>' : '') + '</div>';
        container.appendChild(toast);
        setTimeout(function() { toast.classList.add('toast-exit'); setTimeout(function() { toast.remove(); }, 300); }, duration);
    },

    initToasts: function() {
        var msgEl = document.getElementById('toast-message');
        if (msgEl && msgEl.value) {
            var type = document.getElementById('toast-type')?.value || 'info';
            this.showToast(type, msgEl.value);
        }
    },

    ajax: function(url, options) {
        options = options || {};
        var method = options.method || 'GET';
        var body = options.body || null;
        var callback = options.callback || function() {};
        var xhr = new XMLHttpRequest();
        xhr.open(method, this.path + url, true);
        if (method === 'POST' && body && typeof body === 'string') {
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        }
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    callback(xhr.responseText);
                } else {
                    callback(null, xhr.status);
                }
            }
        };
        xhr.send(body);
    },

    // Button loading state helpers
    _setLoading: function(btn, loading) {
        if (!btn) return;
        if (loading) {
            btn.disabled = true;
            btn.setAttribute('data-orig-html', btn.innerHTML);
            btn.style.opacity = '0.6';
            btn.style.pointerEvents = 'none';
        } else {
            btn.disabled = false;
            var orig = btn.getAttribute('data-orig-html');
            if (orig) btn.innerHTML = orig;
            btn.style.opacity = '';
            btn.style.pointerEvents = '';
        }
    },

    addToCart: function(goodsId, btn) {
        var key = 'cart_' + goodsId;
        if (this._busy[key]) return;
        this._busy[key] = true;
        this._setLoading(btn, true);
        var self = this;
        this.ajax('api/shopping?goodsId=' + goodsId, {
            callback: function(resp, status) {
                self._busy[key] = false;
                self._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    SaltFish.showToast('success', '\u5df2\u52a0\u5165\u8d2d\u7269\u8f66');
                    SaltFish.updateCartBadge();
                    if (btn) {
                        btn.style.transform = 'scale(1.2)';
                        setTimeout(function() { btn.style.transform = ''; }, 200);
                    }
                } else if (resp && resp.indexOf('login') >= 0) {
                    SaltFish.showToast('warning', '\u8bf7\u5148\u767b\u5f55');
                    setTimeout(function() { location.href = SaltFish.path + 'user/login.jsp'; }, 1000);
                } else if (resp && resp.indexOf('duplicate') >= 0) {
                    SaltFish.showToast('info', '\u8be5\u5546\u54c1\u5df2\u5728\u8d2d\u7269\u8f66\u4e2d');
                } else {
                    SaltFish.showToast('error', status ? '\u7f51\u7edc\u9519\u8bef' : '\u64cd\u4f5c\u5931\u8d25\uff0c\u5546\u54c1\u53ef\u80fd\u5df2\u4e0b\u67b6');
                }
            }
        });
    },

    updateCartBadge: function() {
        this.ajax('api/cartnum', {
            callback: function(resp) {
                var count = (resp && resp !== '0') ? resp : '0';
                var badges = document.querySelectorAll('.cart-badge');
                if (badges.length === 0) {
                    // Badge element doesn't exist yet, create it
                    var cartLink = document.querySelector('a[href*="shopcart"]');
                    if (cartLink) {
                        var span = document.createElement('span');
                        span.className = 'badge-count cart-badge';
                        span.textContent = count;
                        cartLink.appendChild(span);
                    }
                } else {
                    badges.forEach(function(b) {
                        b.textContent = count;
                        b.style.display = count !== '0' ? 'flex' : 'none';
                    });
                }
            }
        });
    },

    updateMessBadge: function() {
        this.ajax('api/messnum', {
            callback: function(resp) {
                var count = parseInt(resp) || 0;
                var badges = document.querySelectorAll('.mess-badge');
                badges.forEach(function(b) {
                    if (count > 0) {
                        b.textContent = count;
                        b.style.display = 'flex';
                    } else {
                        b.style.display = 'none';
                    }
                });
            }
        });
    },

    confirmDialog: function(message, onConfirm) {
        var existing = document.getElementById('sfConfirmDialog');
        if (existing) existing.remove();
        var bd = document.createElement('div');
        bd.className = 'modal-backdrop';
        bd.id = 'sfConfirmDialog';
        var html = '<div class="modal" style="max-width:420px">';
        html += '<div class="modal-header"><h3>' + message + '</h3></div>';
        html += '<div class="modal-footer">';
        html += '<button class="btn btn-ghost" data-action="cancel">\u53d6\u6d88</button>';
        html += '<button class="btn btn-primary" data-action="confirm">\u786e\u8ba4</button>';
        html += '</div></div>';
        bd.innerHTML = html;
        document.body.appendChild(bd);
        bd.querySelector('[data-action="cancel"]').onclick = function() { bd.classList.remove('show'); setTimeout(function(){ bd.remove(); }, 300); };
        bd.querySelector('[data-action="confirm"]').onclick = function() { bd.classList.remove('show'); setTimeout(function(){ bd.remove(); }, 300); onConfirm(); };
        bd.addEventListener('click', function(e) { if (e.target === bd) { bd.classList.remove('show'); setTimeout(function(){ bd.remove(); }, 300); } });
        requestAnimationFrame(function(){ bd.classList.add('show'); });
    },

    toggleCollect: function(goodsId, btn) {
        var isCollected = btn.classList.contains('collected');
        var url = isCollected ? 'api/removeCollect?goodsId=' + goodsId : 'api/collect?goodsId=' + goodsId;
        var key = 'collect_' + goodsId;
        if (this._busy[key]) return;
        this._busy[key] = true;
        this._setLoading(btn, true);
        var self = this;
        this.ajax(url, {
            callback: function(resp, status) {
                self._busy[key] = false;
                self._setLoading(btn, false);
                if (resp && resp.indexOf('success') >= 0) {
                    btn.classList.toggle('collected');
                    // Heart fill animation
                    btn.style.transform = 'scale(1.3)';
                    setTimeout(function() { btn.style.transform = ''; }, 250);
                    SaltFish.showToast('success', isCollected ? '\u5df2\u53d6\u6d88\u6536\u85cf' : '\u5df2\u6536\u85cf');
                } else if (resp && resp.indexOf('login') >= 0) {
                    SaltFish.showToast('warning', '\u8bf7\u5148\u767b\u5f55');
                    setTimeout(function() { location.href = SaltFish.path + 'user/login.jsp'; }, 1000);
                } else {
                    SaltFish.showToast('error', status ? '\u7f51\u7edc\u9519\u8bef' : '\u64cd\u4f5c\u5931\u8d25\uff0c\u5546\u54c1\u53ef\u80fd\u5df2\u4e0b\u67b6');
                }
            }
        });
    },

    confirm: function(message, onConfirm) {
        if (window.confirm(message)) {
            onConfirm();
        }
    },

    formatPrice: function(price) {
        return '\u00a5' + parseFloat(price).toFixed(2);
    },

    timeAgo: function(dateStr) {
        var now = new Date();
        var date = new Date(dateStr);
        var diff = Math.floor((now - date) / 1000);
        if (diff < 60) return '\u521a\u521a';
        if (diff < 3600) return Math.floor(diff / 60) + '\u5206\u949f\u524d';
        if (diff < 86400) return Math.floor(diff / 3600) + '\u5c0f\u65f6\u524d';
        if (diff < 604800) return Math.floor(diff / 86400) + '\u5929\u524d';
        return dateStr;
    }
};

document.addEventListener('DOMContentLoaded', function() { SaltFish.init(); });