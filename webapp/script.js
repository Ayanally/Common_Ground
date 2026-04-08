// ===== DOM ELEMENTS =====
const matchList = document.getElementById('matchList');
const notifBell = document.getElementById('notifBell');
const filterToggle = document.getElementById('filterToggle');
const filterPanel = document.getElementById('filterPanel');
const clearBtn = document.getElementById('clearFilters');
const modalOverlay = document.getElementById('modalOverlay');
const openModalBtn = document.getElementById('openModal');
const closeModalBtn = document.getElementById('closeModal');
const cancelModalBtn = document.getElementById('cancelModal');
const form = document.getElementById('eventForm');

// ===== FILTER VARIABLES =====
let activeLocation = 'all';
let activeLevel = 'all';

// ===== HELPER: ESCAPE HTML =====
function escapeHtml(str) {
  if (!str) return '';
  return str.replace(/[&<>]/g, function(m) {
    if (m === '&') return '&amp;';
    if (m === '<') return '&lt;';
    if (m === '>') return '&gt;';
    return m;
  });
}

// ===== TOAST NOTIFICATION =====
function showToast(message, type = 'success') {
  const toast = document.getElementById('toast');
  toast.textContent = message;
  toast.className = 'toast show ' + type;
  setTimeout(() => {
    toast.classList.remove('show');
  }, 3000);
}

// ===== NAV LINK SWITCHING =====
const navLinks = document.querySelectorAll('.nav-link');
navLinks.forEach(link => {
  link.addEventListener('click', function(e) {
    e.preventDefault();
    navLinks.forEach(l => l.classList.remove('active'));
    this.classList.add('active');
  });
});

// ===== NOTIFICATION BELL =====
if (notifBell) {
  notifBell.addEventListener('click', function() {
    const badge = document.getElementById('notifBadge');
    if (badge) badge.style.display = 'none';
  });
}

// ===== FILTER PANEL TOGGLE =====
if (filterToggle) {
  filterToggle.addEventListener('click', function() {
    const isOpen = filterPanel.classList.toggle('open');
    filterToggle.classList.toggle('open', isOpen);
  });
}

// ===== FILTER CHIPS =====
const chips = document.querySelectorAll('.chip');
chips.forEach(chip => {
  chip.addEventListener('click', function() {
    const filterType = this.dataset.filter;
    const value = this.dataset.value;
    document.querySelectorAll(`.chip[data-filter="${filterType}"]`).forEach(c => c.classList.remove('active'));
    this.classList.add('active');
    if (filterType === 'location') activeLocation = value;
    if (filterType === 'level') activeLevel = value;
    applyFilters();
    updateFilterCount();
  });
});

// ===== APPLY FILTERS =====
function applyFilters() {
  const cards = document.querySelectorAll('#matchList .user-card');
  let visibleCount = 0;
  cards.forEach(card => {
    const km = parseFloat(card.dataset.km);
    const level = card.dataset.level;
    const locationOk = activeLocation === 'all' || km <= parseFloat(activeLocation);
    const levelOk = activeLevel === 'all' || level === activeLevel;
    if (locationOk && levelOk) {
      card.style.display = '';
      visibleCount++;
    } else {
      card.style.display = 'none';
    }
  });
  const emptyState = document.getElementById('emptyState');
  if (visibleCount === 0) emptyState.style.display = 'flex';
  else emptyState.style.display = 'none';
}

// ===== UPDATE FILTER COUNT =====
function updateFilterCount() {
  const countEl = document.getElementById('filterCount');
  let count = 0;
  if (activeLocation !== 'all') count++;
  if (activeLevel !== 'all') count++;
  if (count > 0) {
    countEl.textContent = count;
    countEl.style.display = 'inline-flex';
  } else {
    countEl.style.display = 'none';
  }
}

// ===== CLEAR FILTERS =====
if (clearBtn) {
  clearBtn.addEventListener('click', function() {
    activeLocation = 'all';
    activeLevel = 'all';
    document.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
    document.querySelector('.chip[data-filter="location"][data-value="all"]').classList.add('active');
    document.querySelector('.chip[data-filter="level"][data-value="all"]').classList.add('active');
    applyFilters();
    updateFilterCount();
  });
}

// ===== MODAL LOGIC =====
if (openModalBtn) {
  openModalBtn.addEventListener('click', function() {
    modalOverlay.classList.add('open');
    document.getElementById('eventName').focus();
  });
}
function closeModal() {
  modalOverlay.classList.remove('open');
}
if (closeModalBtn) closeModalBtn.addEventListener('click', closeModal);
if (cancelModalBtn) cancelModalBtn.addEventListener('click', closeModal);
if (modalOverlay) {
  modalOverlay.addEventListener('click', function(e) {
    if (e.target === modalOverlay) closeModal();
  });
}
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape' && modalOverlay.classList.contains('open')) closeModal();
});

// ===== FORM VALIDATION =====
if (form) {
  form.addEventListener('submit', function(e) {
    const name = document.getElementById('eventName').value.trim();
    const address = document.getElementById('eventAddress').value.trim();
    const city = document.getElementById('eventCity').value.trim();
    const pincode = document.getElementById('eventPincode').value.trim();
    if (!name || !address || !city || !pincode || pincode.length !== 6) {
      e.preventDefault();
      showToast('Please fill all fields correctly', 'error');
    }
  });
  // Reset border on input
  ['eventName', 'eventAddress', 'eventCity', 'eventPincode'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', function() { this.style.borderColor = ''; });
  });
}

// ==================== RECOMMENDED MATCHES ====================
function loadMatches() {
  fetch('/getData')
      .then(res => res.json())
      .then(users => {
        matchList.innerHTML = '';
        if (users.length === 0) {
          matchList.innerHTML = '<div class="empty-state">No matches found yet.</div>';
          return;
        }
        users.forEach(u => {
          const interests = u.sports ? u.sports.split(",") : [];
          const randomKm = Math.floor(Math.random() * 15) + 1;
          const randomImg = "https://i.pravatar.cc/64?img=" + Math.floor(Math.random() * 70);
          const card = document.createElement('div');
          card.className = 'user-card';
          card.dataset.km = randomKm;
          card.dataset.level = u.level;
          card.innerHTML = `
                    <img src="${randomImg}" class="user-avatar" alt="${u.name}">
                    <div class="user-info">
                        <div class="user-header">
                            <span class="user-name">${escapeHtml(u.name)}</span>
                            <span class="tag">${escapeHtml(u.level)}</span>
                        </div>
                        <div class="user-location">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            ${escapeHtml(u.city)} • ${randomKm} km away
                        </div>
                        <div class="user-interests">
                            ${interests.map(sport => `<span class="interest-tag">${escapeHtml(sport.trim())}</span>`).join('')}
                        </div>
                        <p class="user-bio">${escapeHtml(u.description || 'No description provided.')}</p>
                    </div>
                    <div class="user-actions">
                        <button class="btn-connect" data-email="${escapeHtml(u.email)}" onclick="connectUser(this)">Connect</button>
                        <button class="btn-message">Message</button>
                    </div>
                `;
          matchList.appendChild(card);
        });
        applyFilters(); // Re-apply filters after loading
      })
      .catch(err => console.error("Error loading matches:", err));
}

// ===== CONNECT USER (from recommended matches) =====
function connectUser(btn) {
  const userEmail = btn.getAttribute('data-email');
  if (!userEmail) {
    showToast('Invalid user', 'error');
    return;
  }
  fetch('/connect', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'action=connect&user_email=' + encodeURIComponent(userEmail)
  })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          showToast(data.message, 'success');
          btn.textContent = 'Pending';
          btn.disabled = true;
        } else {
          showToast(data.message, 'error');
        }
      })
      .catch(err => showToast('Connection failed', 'error'));
}

// ==================== NEARBY PLAYERS ====================
function loadNearbyUsers() {
  const radiusSelect = document.getElementById('radiusSelect');
  if (!radiusSelect) return;
  const radius = radiusSelect.value;
  fetch('/nearby?radius=' + radius)
      .then(res => res.json())
      .then(data => {
        const container = document.getElementById('nearbyUsersList');
        if (!container) return;
        if (data.error || !data.nearby || data.nearby.length === 0) {
          container.innerHTML = `<div class="empty-nearby">📍 No nearby players found within ${radius} km.<br>Share your location to discover athletes near you!</div>`;
          return;
        }
        let html = '';
        data.nearby.forEach(user => {
          html += `
                    <div class="nearby-card">
                        <div class="nearby-info">
                            <div class="nearby-avatar">${escapeHtml(user.name.charAt(0))}</div>
                            <div>
                                <h4>${escapeHtml(user.name)}</h4>
                                <div class="nearby-details">
                                    <span>🏷️ ${escapeHtml(user.level || 'Beginner')}</span>
                                    <span>📍 ${user.distance_km} km away</span>
                                    <span>🏙️ ${escapeHtml(user.city || 'Unknown')}</span>
                                </div>
                            </div>
                        </div>
                        <button class="connect-btn" data-email="${escapeHtml(user.email)}" onclick="sendConnectionRequest(this)">🤝 Connect</button>
                    </div>
                `;
        });
        container.innerHTML = html;
      })
      .catch(err => {
        console.error(err);
        const container = document.getElementById('nearbyUsersList');
        if (container) container.innerHTML = '<div class="empty-nearby">❌ Error loading nearby players</div>';
      });
}

function sendConnectionRequest(btn) {
  const userEmail = btn.getAttribute('data-email');
  fetch('/connect', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'action=connect&user_email=' + encodeURIComponent(userEmail)
  })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          showToast(data.message, 'success');
          btn.textContent = 'Pending';
          btn.disabled = true;
        } else {
          showToast(data.message, 'error');
        }
      })
      .catch(err => showToast('Request failed', 'error'));
}

// ==================== PENDING REQUESTS ====================
function loadPendingRequests() {
  fetch('/connect')
      .then(res => res.json())
      .then(data => {
        const container = document.getElementById('pendingRequestsList');
        if (!container) return;
        if (!data.requests || data.requests.length === 0) {
          container.innerHTML = '<p>✨ No pending requests</p>';
          return;
        }
        let html = '';
        data.requests.forEach(req => {
          html += `
                    <div class="pending-card">
                        <div><strong>${escapeHtml(req.name)}</strong> (${escapeHtml(req.level)}) – ${escapeHtml(req.city)}</div>
                        <div>
                            <button class="accept-btn" onclick="respondToRequest('${escapeHtml(req.email)}', 'accept')">✓ Accept</button>
                            <button class="reject-btn" onclick="respondToRequest('${escapeHtml(req.email)}', 'reject')">✗ Reject</button>
                        </div>
                    </div>
                `;
        });
        container.innerHTML = html;
      })
      .catch(err => {
        console.error(err);
        const container = document.getElementById('pendingRequestsList');
        if (container) container.innerHTML = '<p>Error loading requests</p>';
      });
}

function respondToRequest(fromUserEmail, action) {
  fetch('/connect', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'action=' + action + '&user_email=' + encodeURIComponent(fromUserEmail)
  })
      .then(res => res.json())
      .then(data => {
        showToast(data.message, data.success ? 'success' : 'error');
        if (data.success) {
          loadPendingRequests();
          loadNearbyUsers(); // refresh nearby list (status may change)
        }
      })
      .catch(err => showToast('Error', 'error'));
}

// ==================== STATS (Nearby Matches & Upcoming Games) ====================
function loadStats() {
  fetch('/getStats')
      .then(res => res.json())
      .then(data => {
        if (!data.error) {
          const nearbyStat = document.querySelector('.stat-card:first-child .stat-value');
          const upcomingStat = document.querySelector('.stat-card:nth-child(2) .stat-value');
          if (nearbyStat) nearbyStat.innerText = data.nearbyMatches || 0;
          if (upcomingStat) upcomingStat.innerText = data.upcomingGames || 0;
        }
      })
      .catch(err => console.error('Stats error:', err));
}

// ==================== SHARE LOCATION ====================
function shareLocation() {
  if (!navigator.geolocation) {
    showToast('Geolocation not supported', 'error');
    return;
  }
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
              const locationStatus = document.getElementById('locationStatus');
              if (data.success) {
                if (locationStatus) locationStatus.innerHTML = '✅ Location shared!';
                showToast('Location updated!', 'success');
                loadNearbyUsers();
                loadStats(); // nearby matches count may change
              } else {
                if (locationStatus) locationStatus.innerHTML = '❌ Failed to share';
                showToast(data.message || 'Location update failed', 'error');
              }
            })
            .catch(err => {
              console.error(err);
              const locationStatus = document.getElementById('locationStatus');
              if (locationStatus) locationStatus.innerHTML = '❌ Error';
              showToast('Error sharing location', 'error');
            });
      },
      function(error) {
        console.error(error);
        const locationStatus = document.getElementById('locationStatus');
        if (locationStatus) locationStatus.innerHTML = '❌ Location denied';
        showToast('Please allow location access', 'error');
      }
  );
}

// ==================== INITIAL LOAD & EVENT LISTENERS ====================
document.addEventListener('DOMContentLoaded', function() {
  loadMatches();
  loadNearbyUsers();
  loadPendingRequests();
  loadStats();

  // Share location button
  const shareBtn = document.getElementById('shareLocationBtn');
  if (shareBtn) shareBtn.addEventListener('click', shareLocation);

  // Radius change reloads nearby users
  const radiusSelect = document.getElementById('radiusSelect');
  if (radiusSelect) radiusSelect.addEventListener('change', loadNearbyUsers);

  // Refresh nearby and stats periodically
  setInterval(() => {
    loadNearbyUsers();
    loadPendingRequests();
    loadStats();
  }, 30000);
});