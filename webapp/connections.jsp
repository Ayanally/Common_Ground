<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String userName = (String) session.getAttribute("userFname");
    if (userName == null) userName = "User";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Common Ground – Connections</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            background: #f5f5f5;
            font-family: system-ui, -apple-system, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 80px auto 40px;
            padding: 20px;
        }
        .section {
            background: white;
            border-radius: 20px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .section h2 {
            margin-top: 0;
            font-size: 1.5rem;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        .connection-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        .connection-card:last-child {
            border-bottom: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .avatar {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 20px;
        }
        .details h4 {
            margin: 0 0 4px 0;
        }
        .details p {
            margin: 0;
            font-size: 12px;
            color: #666;
        }
        .actions button {
            margin-left: 10px;
            padding: 6px 12px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-weight: 500;
        }
        .accept-btn {
            background: #4CAF50;
            color: white;
        }
        .reject-btn {
            background: #f44336;
            color: white;
        }
        .cancel-btn {
            background: #ff9800;
            color: white;
        }
        .connected-badge {
            background: #e0e0e0;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #667eea;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        @media (max-width: 600px) {
            .container { padding: 15px; }
            .connection-card { flex-direction: column; text-align: center; gap: 12px; }
            .actions button { margin: 5px; }
        }
    </style>
</head>
<body>

<!-- Simple navbar -->
<nav class="navbar" style="position: fixed; top:0; width:100%; background:white; box-shadow:0 2px 8px rgba(0,0,0,0.1); z-index:100;">
    <div class="nav-left">
        <span class="logo-text">Common Ground</span>
    </div>
    <div class="nav-right">
        <span>Welcome, <%= userName %></span>
        <button onclick="window.location.href='dashboard.jsp'" style="margin-left:15px; background:#667eea; color:white; border:none; padding:6px 12px; border-radius:20px; cursor:pointer;">Dashboard</button>
        <button onclick="window.location.href='logout'" style="margin-left:10px; background:#f44336; color:white; border:none; padding:6px 12px; border-radius:20px; cursor:pointer;">Logout</button>
    </div>
</nav>

<div class="container">
    <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>

    <!-- Received Requests -->
    <div class="section">
        <h2>📬 Requests Received</h2>
        <div id="receivedList">Loading...</div>
    </div>

    <!-- Sent Requests -->
    <div class="section">
        <h2>📤 Requests Sent</h2>
        <div id="sentList">Loading...</div>
    </div>

    <!-- Connected People -->
    <div class="section">
        <h2>🤝 Your Connections</h2>
        <div id="connectedList">Loading...</div>
    </div>
</div>

<script>
    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/[&<>]/g, function(m) {
            if (m === '&') return '&amp;';
            if (m === '<') return '&lt;';
            if (m === '>') return '&gt;';
            return m;
        });
    }

    function showToast(message, type) {
        let toast = document.createElement('div');
        toast.innerText = message;
        toast.style.position = 'fixed';
        toast.style.bottom = '20px';
        toast.style.right = '20px';
        toast.style.backgroundColor = type === 'success' ? '#4CAF50' : '#f44336';
        toast.style.color = 'white';
        toast.style.padding = '12px 20px';
        toast.style.borderRadius = '8px';
        toast.style.zIndex = '2000';
        document.body.appendChild(toast);
        setTimeout(() => toast.remove(), 3000);
    }

    function loadConnections() {
        fetch('/getConnections')
            .then(res => res.json())
            .then(data => {
                if (data.error) {
                    document.getElementById('receivedList').innerHTML = '<div class="empty-state">Error loading</div>';
                    return;
                }

                // Render received requests
                const receivedDiv = document.getElementById('receivedList');
                if (data.received && data.received.length > 0) {
                    let html = '';
                    data.received.forEach(req => {
                        html += `
                            <div class="connection-card">
                                <div class="user-info">
                                    <div class="avatar">${escapeHtml(req.name.charAt(0))}</div>
                                    <div class="details">
                                        <h4>${escapeHtml(req.name)}</h4>
                                        <p>${escapeHtml(req.level)} • ${escapeHtml(req.city)}</p>
                                    </div>
                                </div>
                                <div class="actions">
                                    <button class="accept-btn" onclick="respond('${escapeHtml(req.email)}', 'accept')">✓ Accept</button>
                                    <button class="reject-btn" onclick="respond('${escapeHtml(req.email)}', 'reject')">✗ Reject</button>
                                </div>
                            </div>
                        `;
                    });
                    receivedDiv.innerHTML = html;
                } else {
                    receivedDiv.innerHTML = '<div class="empty-state">No pending requests</div>';
                }

                // Render sent requests
                const sentDiv = document.getElementById('sentList');
                if (data.sent && data.sent.length > 0) {
                    let html = '';
                    data.sent.forEach(req => {
                        html += `
                            <div class="connection-card">
                                <div class="user-info">
                                    <div class="avatar">${escapeHtml(req.name.charAt(0))}</div>
                                    <div class="details">
                                        <h4>${escapeHtml(req.name)}</h4>
                                        <p>${escapeHtml(req.level)} • ${escapeHtml(req.city)}</p>
                                    </div>
                                </div>
                                <div class="actions">
                                    <button class="cancel-btn" onclick="respond('${escapeHtml(req.email)}', 'cancel')">⏳ Cancel Request</button>
                                </div>
                            </div>
                        `;
                    });
                    sentDiv.innerHTML = html;
                } else {
                    sentDiv.innerHTML = '<div class="empty-state">No pending outgoing requests</div>';
                }

                // Render connected people
                const connectedDiv = document.getElementById('connectedList');
                if (data.connected && data.connected.length > 0) {
                    let html = '';
                    data.connected.forEach(conn => {
                        html += `
                            <div class="connection-card">
                                <div class="user-info">
                                    <div class="avatar">${escapeHtml(conn.name.charAt(0))}</div>
                                    <div class="details">
                                        <h4>${escapeHtml(conn.name)}</h4>
                                        <p>${escapeHtml(conn.level)} • ${escapeHtml(conn.city)}</p>
                                    </div>
                                </div>
                                <div class="actions">
                                    <span class="connected-badge">✓ Connected</span>
                                </div>
                            </div>
                        `;
                    });
                    connectedDiv.innerHTML = html;
                } else {
                    connectedDiv.innerHTML = '<div class="empty-state">No connections yet. Send some requests!</div>';
                }
            })
            .catch(err => {
                console.error(err);
                document.getElementById('receivedList').innerHTML = '<div class="empty-state">Error loading connections</div>';
            });
    }

    function respond(Email, action) {
        fetch('/connect', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=' + action + '&user_email=' + encodeURIComponent(Email)
        })
            .then(res => res.json())
            .then(data => {
                showToast(data.message, data.success ? 'success' : 'error');
                if (data.success) {
                    loadConnections(); // refresh the page
                }
            })
            .catch(err => showToast('Error', 'error'));
    }

    // Load on page load
    loadConnections();
</script>
</body>
</html>