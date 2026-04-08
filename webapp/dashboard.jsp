<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
  String userName  = (String) session.getAttribute("userFname");
  String userCity  = (String) session.getAttribute("userCity");
  String userLevel = (String) session.getAttribute("userLevel");
  String userEmail = (String) session.getAttribute("userEmail");
  if (userName  == null) userName  = "User";
  if (userCity  == null) userCity  = "";
  if (userLevel == null) userLevel = "Beginner";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Common Ground – Events</title>
  <link rel="stylesheet" href="styles.css" />
  <style>
    /* existing styles ... */
    .level-edit-btn {
      background: none;
      border: none;
      cursor: pointer;
      margin-left: 8px;
      padding: 4px;
      border-radius: 50%;
      transition: all 0.2s;
      vertical-align: middle;
    }
    .level-edit-btn:hover {
      background: rgba(0,0,0,0.1);
      transform: scale(1.1);
    }
    .stat-value-wrapper {
      display: flex;
      align-items: center;
      justify-content: flex-start;
      gap: 5px;
    }
    .level-modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      z-index: 2000;
      justify-content: center;
      align-items: center;
    }
    .level-modal-content {
      background: white;
      border-radius: 16px;
      padding: 24px;
      width: 90%;
      max-width: 350px;
      text-align: center;
      animation: modalSlideIn 0.3s ease;
    }
    @keyframes modalSlideIn {
      from { transform: translateY(-50px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }
    .level-modal-content h3 {
      margin-bottom: 20px;
      color: #333;
    }
    .level-options {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 20px;
    }
    .level-option {
      padding: 12px;
      border: none;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.2s;
    }
    .level-option:hover {
      transform: translateX(5px);
    }
    .level-option-beginner { background: #4CAF50; color: white; }
    .level-option-intermediate { background: #FF9800; color: white; }
    .level-option-advanced { background: #f44336; color: white; }
    .level-modal-close {
      background: #e0e0e0;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 14px;
    }
    .level-modal-close:hover { background: #ccc; }
    .custom-toast {
      position: fixed;
      bottom: 30px;
      right: 30px;
      background: #333;
      color: white;
      padding: 12px 20px;
      border-radius: 8px;
      z-index: 2001;
      animation: fadeInOut 3s ease;
      font-size: 14px;
    }
    .custom-toast.success { background: #4CAF50; }
    .custom-toast.error { background: #f44336; }
    @keyframes fadeInOut {
      0% { opacity: 0; transform: translateX(50px); }
      15% { opacity: 1; transform: translateX(0); }
      85% { opacity: 1; transform: translateX(0); }
      100% { opacity: 0; transform: translateX(50px); }
    }

    /* NEW STYLES FOR NEARBY SECTION */
    .location-bar {
      background: #f0f7ff;
      padding: 12px 20px;
      border-radius: 12px;
      margin: 20px 0 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 10px;
    }
    .btn-share-location {
      background: #4CAF50;
      color: white;
      border: none;
      padding: 8px 20px;
      border-radius: 30px;
      cursor: pointer;
      font-weight: 500;
      transition: 0.2s;
    }
    .btn-share-location:hover {
      background: #45a049;
      transform: scale(1.02);
    }
    .nearby-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: 30px 0 20px;
      flex-wrap: wrap;
      gap: 15px;
    }
    #radiusSelect {
      padding: 8px 12px;
      border-radius: 8px;
      border: 1px solid #ddd;
      background: white;
    }
    .nearby-card {
      background: white;
      border-radius: 16px;
      padding: 16px;
      margin-bottom: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      display: flex;
      justify-content: space-between;
      align-items: center;
      transition: 0.2s;
    }
    .nearby-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.12);
    }
    .nearby-avatar {
      width: 50px;
      height: 50px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
      font-size: 20px;
    }
    .nearby-info h4 {
      margin: 0 0 6px 0;
    }
    .nearby-details {
      display: flex;
      gap: 15px;
      font-size: 12px;
      color: #666;
    }
    .connect-btn {
      background: #4CAF50;
      color: white;
      border: none;
      padding: 8px 18px;
      border-radius: 30px;
      cursor: pointer;
      font-weight: 500;
    }
    .connect-btn:hover {
      background: #45a049;
    }
    .loading, .empty-nearby {
      text-align: center;
      padding: 40px;
      background: #f9f9f9;
      border-radius: 16px;
      color: #666;
    }
    @media (max-width: 700px) {
      .nearby-card { flex-direction: column; text-align: center; gap: 12px; }
      .nearby-details { flex-wrap: wrap; justify-content: center; }
    }
  </style>
</head>
<body>

<!-- LEVEL MODAL (unchanged) -->
<div id="levelModal" class="level-modal">
  <div class="level-modal-content">
    <h3>✏️ Select Your Skill Level</h3>
    <div class="level-options">
      <button class="level-option level-option-beginner" onclick="updateUserLevel('Beginner')">🏅 Beginner</button>
      <button class="level-option level-option-intermediate" onclick="updateUserLevel('Intermediate')">⭐ Intermediate</button>
      <button class="level-option level-option-advanced" onclick="updateUserLevel('Advanced')">🔥 Advanced</button>
    </div>
    <button class="level-modal-close" onclick="closeLevelModal()">Cancel</button>
  </div>
</div>
<!-- Pending Connection Requests -->
<div class="pending-section" style="margin: 30px 0;">
  <h3>📬 Connection Requests</h3>
  <div id="pendingRequestsList">
    <div class="loading">Loading requests...</div>
  </div>
</div>

<!-- NAVBAR (unchanged) -->
<nav class="navbar">
  <div class="nav-left">
    <span class="logo-icon">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="3"/>
        <path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/>
      </svg>
    </span>
    <span class="logo-text">Common Ground</span>
  </div>
  <div class="nav-links">
    <a href="#" class="nav-link" data-page="map"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="3 11 22 2 13 21 11 13 3 11"/></svg>Map View</a>
    <a href="#" class="nav-link active" data-page="events"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>Events</a>
    <a href="#" class="nav-link badge-wrap" data-page="messages"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>Messages<span class="badge">1</span></a>
    <a href="connections.jsp" class="nav-link" data-page="connections"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>Connections</a>
  </div>
  <div class="nav-right">
    <div class="notif-wrap" id="notifBell"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg><span class="notif-badge" id="notifBadge">1</span></div>
    <img src="https://i.pravatar.cc/36?img=8" alt="<%= userName %>" class="avatar" />
    <div class="profile-info">
      <span class="profile-name"><%= userName %></span>
      <span class="profile-location"><%= userCity %></span>
    </div>
    <button class="logout-btn" title="Logout" onclick="window.location.href='logout'"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg></button>
  </div>
</nav>

<main class="main">
  <!-- HERO BANNER -->
  <section class="hero">
    <div class="hero-text">
      <h1>Welcome back, <%= userName %>! 👋</h1>
      <p>You have 1 potential matches nearby</p>
    </div>
    <button class="btn-add-event" id="openModal"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>Add Event</button>
  </section>

  <!-- STATS CARDS -->
  <section class="stats">
    <div class="stat-card">
      <div class="stat-icon icon-purple"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#7c5cbf" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
      <div><div class="stat-value">1</div><div class="stat-label">Nearby Matches</div></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon icon-green"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#2e9e6b" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
      <div><div class="stat-value" id="upcomingCount">3</div><div class="stat-label">Upcoming Games</div></div>
    </div>
    <div class="stat-card">
      <div class="stat-icon icon-orange"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89L17 22l-5-3-5 3 1.523-9.11"/></svg></div>
      <div>
        <div class="stat-value-wrapper">
          <span class="stat-value" id="currentLevelDisplay"><%= userLevel %></span>
          <button class="level-edit-btn" onclick="openLevelModal()" title="Change your skill level">✏️</button>
        </div>
        <div class="stat-label">Your Level</div>
      </div>
    </div>
  </section>

  <!-- ========== NEW: LOCATION BAR & NEARBY PLAYERS ========== -->
  <div class="location-bar">
    <div>
      <span>📍 Location Status:</span>
      <strong id="locationStatus" style="margin-left: 8px;">Not shared</strong>
    </div>
    <button id="shareLocationBtn" class="btn-share-location">📍 Share My Location</button>
  </div>

  <div class="nearby-header">
    <div>
      <h2 class="section-title">📍 Nearby Players</h2>
      <p class="section-sub">Find and connect with athletes near you</p>
    </div>
    <select id="radiusSelect">
      <option value="5">Within 5 km</option>
      <option value="10" selected>Within 10 km</option>
      <option value="20">Within 20 km</option>
      <option value="50">Within 50 km</option>
    </select>
  </div>
  <div id="nearbyUsersList">
    <div class="loading">📍 Share your location to see nearby players...</div>
  </div>
  <!-- ========== END OF NEARBY SECTION ========== -->

  <!-- RECOMMENDED MATCHES SECTION (unchanged) -->
  <section class="matches-section">
    <div class="matches-header">
      <div><h2 class="section-title">Recommended Matches</h2><p class="section-sub">Athletes near you with similar interests and skill level</p></div>
      <button class="btn-filter-toggle" id="filterToggle"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="6" x2="20" y2="6"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="11" y1="18" x2="13" y2="18"/></svg>Filters<span class="filter-count" id="filterCount" style="display:none">0</span></button>
    </div>
    <div class="filter-panel" id="filterPanel">
      <div class="filter-group"><label class="filter-label"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>Location (distance)</label><div class="filter-chips"><button class="chip active" data-filter="location" data-value="all">All</button><button class="chip" data-filter="location" data-value="5">Within 5 km</button><button class="chip" data-filter="location" data-value="10">Within 10 km</button><button class="chip" data-filter="location" data-value="20">Within 20 km</button></div></div>
      <div class="filter-divider"></div>
      <div class="filter-group"><label class="filter-label"><svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89L17 22l-5-3-5 3 1.523-9.11"/></svg>Skill Level</label><div class="filter-chips"><button class="chip active" data-filter="level" data-value="all">All</button><button class="chip" data-filter="level" data-value="beginner">Beginner</button><button class="chip" data-filter="level" data-value="intermediate">Intermediate</button><button class="chip" data-filter="level" data-value="advanced">Advanced</button></div></div>
      <button class="btn-clear-filters" id="clearFilters">Clear all filters</button>
    </div>
    <div id="matchList"></div>
    <div class="empty-state" id="emptyState" style="display:none;"><svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#bbb" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg><p>No matches found for the selected filters.</p><button onclick="document.getElementById('clearFilters').click()">Clear filters</button></div>
  </section>
</main>

<!-- ADD EVENT MODAL (unchanged) -->
<div class="modal-overlay" id="modalOverlay">
  <div class="modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <div class="modal-header"><h3 id="modalTitle"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>Add New Event</h3><button class="modal-close" id="closeModal" aria-label="Close"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button></div>
    <form id="eventForm" method="post" action="addEvent">
      <div class="modal-body">
        <div class="form-group"><label for="eventName">Event Name</label><input type="text" id="eventName" name="eventName" placeholder="e.g. Weekend Cricket Match" /></div>
        <div class="form-row"><div class="form-group"><label for="eventDate">Date</label><input type="date" id="eventDate" name="eventDate" /></div><div class="form-group"><label for="eventTime">Time</label><input type="time" id="eventTime" name="eventTime" /></div></div>
        <div class="form-group"><label for="eventAddress">Address</label><input type="text" id="eventAddress" name="eventAddress" placeholder="e.g. Gokuldham Society, MG Road" /></div>
        <div class="form-group"><label for="eventCity">City</label><input type="text" id="eventCity" name="eventCity" placeholder="e.g. Mumbai" /></div>
        <div class="form-group"><label for="eventPincode">Pincode</label><input type="text" id="eventPincode" name="eventPincode" placeholder="e.g. 400011" maxlength="6" /></div>
        <div class="form-row"><div class="form-group"><label for="eventSport">Sport</label><select id="eventSport" name="eventSport"><option value="">Select sport</option><option>Cricket</option><option>Football</option><option>Basketball</option><option>Badminton</option><option>Tennis</option><option>Other</option></select></div><div class="form-group"><label for="eventLevel">Skill Level</label><select id="eventLevel" name="eventLevel"><option value="">Any level</option><option>Beginner</option><option>Intermediate</option><option>Advanced</option></select></div></div>
        <div class="form-group"><label for="eventDesc">Description <span class="optional">(optional)</span></label><textarea id="eventDesc" name="eventDesc" rows="3" placeholder="Add details about the event..."></textarea></div>
      </div>
      <div class="modal-footer"><button type="button" class="btn-cancel" id="cancelModal">Cancel</button><button type="submit" class="btn-save" id="saveEvent">Create Event</button></div>
    </form>
  </div>
</div>

<div class="toast" id="toast"></div>

<script src="script.js"></script>
<script>
  // Existing functions
  function openLevelModal() {
    document.getElementById('levelModal').style.display = 'flex';
  }
  function closeLevelModal() {
    document.getElementById('levelModal').style.display = 'none';
  }
  function showToast(message, type) {
    var toast = document.createElement('div');
    toast.className = 'custom-toast ' + type;
    toast.innerText = message;
    document.body.appendChild(toast);
    setTimeout(function() { toast.remove(); }, 3000);
  }
  function updateUserLevel(newLevel) {
    fetch('/getData', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'level=' + encodeURIComponent(newLevel)
    })
            .then(function(response) { return response.json(); })
            .then(function(data) {
              if (data.success) {
                document.getElementById('currentLevelDisplay').innerText = newLevel;
                closeLevelModal();
                showToast('✅ Level updated to ' + newLevel + '!', 'success');
                setTimeout(function() { location.reload(); }, 1000);
              } else {
                showToast('❌ Failed to update level: ' + data.message, 'error');
              }
            })
            .catch(function(error) {
              console.error('Error:', error);
              showToast('❌ Error updating level', 'error');
            });
  }

  // ========== NEW FUNCTIONS FOR NEARBY USERS ==========
  function loadNearbyUsers() {
    const radius = document.getElementById('radiusSelect') ? document.getElementById('radiusSelect').value : 10;
    fetch('/nearby?radius=' + radius)
            .then(response => response.json())
            .then(data => {
              const container = document.getElementById('nearbyUsersList');
              if (data.error) {
                container.innerHTML = '<div class="empty-nearby">⚠️ ' + data.error + '</div>';
                return;
              }
              if (!data.nearby || data.nearby.length === 0) {
                container.innerHTML = `
            <div class="empty-nearby">
              <span style="font-size: 48px;">🗺️</span>
              <p>No nearby players found within ${radius} km</p>
              <p style="font-size: 14px;">Share your location to discover athletes near you!</p>
            </div>`;
                return;
              }
              let html = '';
              for (let i = 0; i < data.nearby.length; i++) {
                const user = data.nearby[i];
                html += `
            <div class="nearby-card">
              <div style="display: flex; align-items: center; gap: 15px; flex-wrap: wrap;">
                <div class="nearby-avatar">${user.name.charAt(0)}</div>
                <div class="nearby-info">
                  <h4>${escapeHtml(user.name)}</h4>
                  <div class="nearby-details">
                    <span>🏷️ ${user.level || 'Beginner'}</span>
                    <span>📍 ${user.distance_km} km away</span>
                    <span>🏙️ ${user.city || 'Unknown'}</span>
                  </div>
                </div>
              </div>
              <button class="connect-btn" onclick="sendConnectionRequest('${escapeHtml(user.email)}')">🤝 Connect</button>
            </div>`;
              }
              container.innerHTML = html;
            })
            .catch(error => {
              console.error('Error loading nearby:', error);
              document.getElementById('nearbyUsersList').innerHTML = '<div class="empty-nearby">❌ Error loading nearby players</div>';
            });
  }

  function sendConnectionRequest(userEmail) {
    fetch('/connect', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'action=connect&user_email=' + encodeURIComponent(userEmail)
    })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                showToast(data.message, 'success');
              } else {
                showToast(data.message, 'error');
              }
            })
            .catch(error => {
              console.error('Error:', error);
              showToast('Failed to send connection request', 'error');
            });
  }

  // Simple escape to prevent XSS
  function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/[&<>]/g, function(m) {
      if (m === '&') return '&amp;';
      if (m === '<') return '&lt;';
      if (m === '>') return '&gt;';
      return m;
    });
  }

  // Share location button
  document.getElementById('shareLocationBtn')?.addEventListener('click', function() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
              function(position) {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;
                fetch('/nearby', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                  body: 'latitude=' + lat + '&longitude=' + lng
                })
                        .then(res => res.json())
                        .then(data => {
                          if (data.success) {
                            document.getElementById('locationStatus').innerHTML = '✅ Location shared!';
                            document.getElementById('locationStatus').style.color = '#2e7d32';
                            loadNearbyUsers();
                          } else {
                            document.getElementById('locationStatus').innerHTML = '❌ Failed to share';
                            showToast(data.message || 'Location update failed', 'error');
                          }
                        })
                        .catch(err => {
                          console.error(err);
                          document.getElementById('locationStatus').innerHTML = '❌ Error';
                        });
              },
              function(error) {
                console.error('Geolocation error:', error);
                document.getElementById('locationStatus').innerHTML = '❌ Unable to get location';
                showToast('Please allow location access to see nearby players', 'error');
              }
      );
    } else {
      alert('Geolocation not supported by this browser');
    }
  });

  // Reload nearby when radius changes
  document.getElementById('radiusSelect')?.addEventListener('change', function() {
    if (document.getElementById('locationStatus').innerText.includes('Shared') ||
            document.getElementById('locationStatus').innerText.includes('✅')) {
      loadNearbyUsers();
    } else {
      document.getElementById('nearbyUsersList').innerHTML = '<div class="empty-nearby">📍 Share your location to see nearby players</div>';
    }
  });

  // Try to load nearby on page load only if location already shared (optional)
  document.addEventListener('DOMContentLoaded', function() {
    // check if maybe previously shared? We'll attempt to load; backend will return error if no location.
    loadNearbyUsers();
  });
</script>
</body>
</html>