export function initializeCalendar(
  currId,
  datesId,
  prevId,
  nextId,
  events
) {
  let date = new Date();
  let year = date.getFullYear();
  let month = date.getMonth();
  const currEl = document.getElementById(currId);
  const datesEl = document.getElementById(datesId);
  const prevBtn = document.getElementById(prevId);
  const nextBtn = document.getElementById(nextId);
  const months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  // Tarih formatını düzelt (YYYY-MM-DD -> Yerel Date)
  function parseEventDate(dateStr) {
    const [y, m, d] = dateStr.split('-').map(Number);
    return new Date(y, m - 1, d); // Ay: 0-11 arası
  }

  function getEventStatus(fullDate) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    fullDate.setHours(0, 0, 0, 0);

    let status = "none";

    for (const event of events) {
      const eventDate = parseEventDate(event.date);
      eventDate.setHours(0, 0, 0, 0);

      if (eventDate.getTime() !== fullDate.getTime()) continue;

      // Bugünün eventi
      if (eventDate.getTime() === today.getTime()) {
        status = "today";
        break;
      }

      // Geçmiş event
      if (eventDate < today) {
        status = "past";
      } 
      // Yaklaşan event (15 gün içinde)
      else {
        const diffDays = Math.ceil((eventDate - today) / (1000 * 60 * 60 * 24));
        if (diffDays <= 15) status = "upcoming";
        else status = "future";
      }
    }
    return status;
  }

  function manipulate() {
    const dayOne = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();
    const dayEnd = new Date(year, month, lastDate).getDay();
    const prevLast = new Date(year, month, 0).getDate();
    let lit = '';

    // Önceki ayın günleri
    for (let i = dayOne; i > 0; i--) {
      lit += `<li class="inactive">${prevLast - i + 1}</li>`;
    }

    // Mevcut ayın günleri
    for (let i = 1; i <= lastDate; i++) {
      const fullDate = new Date(year, month, i); // DÜZELTİ: Doğru parametre sırası
      const isToday = (
        i === new Date().getDate() &&
        month === new Date().getMonth() &&
        year === new Date().getFullYear()
      ) ? 'active' : '';

      const notificationStatus = getEventStatus(fullDate);
      const notiCssClass = notificationStatus !== "none" 
        ? `${notificationStatus}` 
        : '';

      lit += `<li class="${isToday? isToday: notiCssClass}">${i}</li>`;
    }

    // Sonraki ayın günleri
    for (let i = dayEnd; i < 6; i++) {
      lit += `<li class="inactive">${i - dayEnd + 1}</li>`;
    }

    if (currEl) currEl.textContent = `${months[month]} ${year}`;
    if (datesEl) datesEl.innerHTML = lit;
  }

  [prevBtn, nextBtn].forEach((btn) =>
    btn?.addEventListener('click', () => {
      month = btn.id === prevId ? month - 1 : month + 1;
      if (month < 0 || month > 11) {
        date = new Date(year, month, new Date().getDate());
        year = date.getFullYear();
        month = date.getMonth();
      } else {
        date = new Date();
      }
      manipulate();
    })
  );

  manipulate();
}