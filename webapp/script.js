// ===== NAV LINK SWITCHING =====
document.querySelectorAll('.nav-link').forEach(link => {
  link.addEventListener('click', function (e) {
    e.preventDefault();
    document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
    this.classList.add('active');
  });
});

// ===== NOTIFICATION BELL =====
document.getElementById('notifBell').addEventListener('click', function () {
  const badge = document.getElementById('notifBadge');
  if (badge) badge.style.display = 'none';
});

// ===== CONNECT BUTTON TOGGLE =====
function handleConnect(btn) {
  if (btn.classList.contains('connected')) {
    btn.classList.remove('connected');
    btn.textContent = 'Connect';
  } else {
    btn.classList.add('connected');
    btn.textContent = 'Connected ✓';
    showToast('Connection request sent!');
  }
}

// ===== FILTER PANEL TOGGLE =====
const filterToggle = document.getElementById('filterToggle');
const filterPanel  = document.getElementById('filterPanel');

filterToggle.addEventListener('click', function () {
  const isOpen = filterPanel.classList.toggle('open');
  filterToggle.classList.toggle('open', isOpen);
});

// ===== FILTER LOGIC =====
let activeLocation = 'all';
let activeLevel    = 'all';

document.querySelectorAll('.chip').forEach(chip => {
  chip.addEventListener('click', function () {
    const filterType = this.dataset.filter;
    const value      = this.dataset.value;

    // Update active chip within the same group
    document.querySelectorAll(`.chip[data-filter="${filterType}"]`).forEach(c => c.classList.remove('active'));
    this.classList.add('active');

    if (filterType === 'location') activeLocation = value;
    if (filterType === 'level')    activeLevel    = value;

    applyFilters();
    updateFilterCount();
  });
});

function applyFilters() {
  const cards      = document.querySelectorAll('#matchList .user-card');
  let visibleCount = 0;

  cards.forEach(card => {
    const km    = parseFloat(card.dataset.km);
    const level = card.dataset.level;

    const locationOk = activeLocation === 'all' || km <= parseFloat(activeLocation);
    const levelOk    = activeLevel    === 'all' || level === activeLevel;

    const show = locationOk && levelOk;
    card.style.display = show ? '' : 'none';
    if (show) visibleCount++;
  });

  document.getElementById('emptyState').style.display = visibleCount === 0 ? 'flex' : 'none';
}

function updateFilterCount() {
  const countEl  = document.getElementById('filterCount');
  let activeCount = 0;
  if (activeLocation !== 'all') activeCount++;
  if (activeLevel    !== 'all') activeCount++;

  if (activeCount > 0) {
    countEl.textContent    = activeCount;
    countEl.style.display  = 'inline-flex';
  } else {
    countEl.style.display  = 'none';
  }
}

// ===== CLEAR FILTERS =====
document.getElementById('clearFilters').addEventListener('click', function () {
  activeLocation = 'all';
  activeLevel    = 'all';

  document.querySelectorAll('.chip[data-filter="location"]').forEach(c => c.classList.remove('active'));
  document.querySelectorAll('.chip[data-filter="level"]').forEach(c => c.classList.remove('active'));
  document.querySelector('.chip[data-filter="location"][data-value="all"]').classList.add('active');
  document.querySelector('.chip[data-filter="level"][data-value="all"]').classList.add('active');

  applyFilters();
  updateFilterCount();
});

// ===== MODAL =====
const modalOverlay = document.getElementById('modalOverlay');

document.getElementById('openModal').addEventListener('click', () => {
  modalOverlay.classList.add('open');
  document.getElementById('eventName').focus();
});

function closeModal() {
  modalOverlay.classList.remove('open');
}

document.getElementById('closeModal').addEventListener('click', closeModal);
document.getElementById('cancelModal').addEventListener('click', closeModal);

// Close on overlay click
modalOverlay.addEventListener('click', function (e) {
  if (e.target === modalOverlay) closeModal();
});

// Close on Escape key
document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape' && modalOverlay.classList.contains('open')) closeModal();
});

// ===== SAVE EVENT =====
document.getElementById('saveEvent').addEventListener('click', function () {
  const name = document.getElementById('eventName').value.trim();
  if (!name) {
    document.getElementById('eventName').focus();
    document.getElementById('eventName').style.borderColor = '#e63946';
    return;
  }

  // Update upcoming games count
  const countEl = document.getElementById('upcomingCount');
  countEl.textContent = parseInt(countEl.textContent) + 1;

  closeModal();
  showToast('🎉 Event "' + name + '" created!');

  // Reset form
  ['eventName','eventDate','eventTime','eventLocation','eventDesc'].forEach(id => {
    document.getElementById(id).value = '';
  });
  document.getElementById('eventSport').selectedIndex = 0;
  document.getElementById('eventLevel').selectedIndex = 0;
  document.getElementById('eventName').style.borderColor = '';
});

// Reset border on input
document.getElementById('eventName').addEventListener('input', function () {
  this.style.borderColor = '';
});

// ===== TOAST =====
function showToast(message) {
  const toast = document.getElementById('toast');
  toast.textContent = message;
  toast.classList.add('show');
  setTimeout(() => toast.classList.remove('show'), 3000);
}
