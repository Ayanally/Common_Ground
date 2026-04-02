alert("JS IS RUNNING");

// ===== NAV LINK SWITCHING =====
const navLinks = document.querySelectorAll('.nav-link');

navLinks.forEach(link => {
  link.addEventListener('click', function (e) {
    e.preventDefault();

    navLinks.forEach(l => l.classList.remove('active'));
    this.classList.add('active');
  });
});


// ===== NOTIFICATION BELL =====
const notifBell = document.getElementById('notifBell');

notifBell.addEventListener('click', function () {
  const badge = document.getElementById('notifBadge');
  if (badge) {
    badge.style.display = 'none';
  }
});


// ===== CONNECT BUTTON =====
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
const filterPanel = document.getElementById('filterPanel');

filterToggle.addEventListener('click', function () {
  const isOpen = filterPanel.classList.toggle('open');
  filterToggle.classList.toggle('open', isOpen);
});


// ===== FILTER VARIABLES =====
let activeLocation = 'all';
let activeLevel = 'all';


// ===== FILTER CLICK =====
const chips = document.querySelectorAll('.chip');

chips.forEach(chip => {
  chip.addEventListener('click', function () {

    const filterType = this.dataset.filter;
    const value = this.dataset.value;

    document.querySelectorAll(`.chip[data-filter="${filterType}"]`)
      .forEach(c => c.classList.remove('active'));

    this.classList.add('active');

    if (filterType === 'location') {
      activeLocation = value;
    }

    if (filterType === 'level') {
      activeLevel = value;
    }

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

  if (visibleCount === 0) {
    emptyState.style.display = 'flex';
  } else {
    emptyState.style.display = 'none';
  }
}


// ===== FILTER COUNT =====
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
const clearBtn = document.getElementById('clearFilters');

clearBtn.addEventListener('click', function () {

  activeLocation = 'all';
  activeLevel = 'all';

  document.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));

  document.querySelector('.chip[data-filter="location"][data-value="all"]').classList.add('active');
  document.querySelector('.chip[data-filter="level"][data-value="all"]').classList.add('active');

  applyFilters();
  updateFilterCount();
});


// ===== MODAL =====
const modalOverlay = document.getElementById('modalOverlay');
const openModalBtn = document.getElementById('openModal');
const closeModalBtn = document.getElementById('closeModal');
const cancelModalBtn = document.getElementById('cancelModal');

openModalBtn.addEventListener('click', function () {
  modalOverlay.classList.add('open');
  document.getElementById('eventName').focus();
});

function closeModal() {
  modalOverlay.classList.remove('open');
}

closeModalBtn.addEventListener('click', closeModal);
cancelModalBtn.addEventListener('click', closeModal);


// ===== CLOSE ON OUTSIDE CLICK =====
modalOverlay.addEventListener('click', function (e) {
  if (e.target === modalOverlay) {
    closeModal();
  }
});


// ===== CLOSE ON ESC =====
document.addEventListener('keydown', function (e) {
  if (e.key === 'Escape' && modalOverlay.classList.contains('open')) {
    closeModal();
  }
});


// ===== BASIC VALIDATION ONLY (NO FETCH) =====
const form = document.getElementById('eventForm');

form.addEventListener('submit', function (e) {

  const name = document.getElementById('eventName').value.trim();

  if (!name) {
    e.preventDefault(); // stop form submission
    const input = document.getElementById('eventName');
    input.focus();
    input.style.borderColor = '#e63946';
  }

});


// ===== RESET BORDER ON INPUT =====
document.getElementById('eventName').addEventListener('input', function () {
  this.style.borderColor = '';
});


// ===== TOAST =====
function showToast(message) {

  const toast = document.getElementById('toast');

  toast.textContent = message;
  toast.classList.add('show');

  setTimeout(function () {
    toast.classList.remove('show');
  }, 3000);
}

//===Card Logic===

// ===== USER DATA =====
const users = [
  {
    name: "Rahul Sharma",
    km: 5.5,
    level: "intermediate",
    location: "Mumbai",
    interests: ["cricket", "basketball"],
    bio: "Love playing cricket on weekends!",
    img: "https://i.pravatar.cc/64?img=12"
  },
  {
    name: "Priya Nair",
    km: 3.1,
    level: "beginner",
    location: "Bandra",
    interests: ["badminton", "yoga"],
    bio: "Looking for a practice partner!",
    img: "https://i.pravatar.cc/64?img=5"
  }
];

// ===== RENDER CARDS =====
function renderCards() {

  const matchList = document.getElementById("matchList");
  matchList.innerHTML = ""; // clear existing

  console.log("users:", users);        // ← add this
  console.log("users length:", users.length);  // ← and this

  users.forEach(user => {

    const card = document.createElement("div");
    card.className = "user-card";

    // IMPORTANT for filters
    card.dataset.km = user.km;
    card.dataset.level = user.level;

    card.innerHTML = `
      <img src="${user.img}" class="user-avatar"/>

      <div class="user-info">
        <div class="user-header">
          <span class="user-name">${user.name}</span>
          <span class="tag">${user.level}</span>
        </div>

        <div class="user-location">
          ${user.location} • ${user.km} km away
        </div>

        <div class="user-interests">
          ${user.interests.map(i => `<span class="interest-tag">${i}</span>`).join("")}
        </div>

        <p class="user-bio">${user.bio}</p>
      </div>

      <div class="user-actions">
        <button class="btn-connect" onclick="handleConnect(this)">Connect</button>
        <button class="btn-message">Message</button>
      </div>
    `;

    matchList.appendChild(card);
  });

  applyFilters(); // apply filters after render
}
renderCards();
