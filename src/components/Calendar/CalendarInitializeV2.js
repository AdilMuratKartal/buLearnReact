// CALENDAR-JS
import { events } from './event'; 

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
  let haveNotification = false;
  const currEl = document.getElementById(currId);
  const datesEl = document.getElementById(datesId);
  const prevBtn = document.getElementById(prevId);
  const nextBtn = document.getElementById(nextId);
  const months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  function getEventStatus(fullDate){
    const today = new Date();
    today.setHours(0,0,0,0);//AYNI GÜN İÇERİSİNDE GEÇ KALINANLAR İÇİNDE BİRŞEYLER DÜŞÜN
    const date = new Date(eventDate);

    if(date < today){
      return `<li class="${isToday}">${i}<span class="calendar-badge badge-notification bg-danger">1</span></li>`;
    } 

    if(date.getTime() === today.getTime()){
      return true;
    } 
    
    // 15 gün içerisinde yaklaşan olanlar 
    const diffTime = date - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    if(diffDays <= 15) return "upcoming";

    return "future";
  }

  function manipulate() {
    const dayOne = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();
    const dayEnd = new Date(year, month, lastDate).getDay();
    const prevLast = new Date(year, month, 0).getDate();
    let lit = '';
    for (let i = dayOne; i > 0; i--) lit += `<li class="inactive">${prevLast - i + 1}</li>`;
    for (let i = 1; i <= lastDate; i++) {
      const isToday =
        i === date.getDate() &&
        month === new Date().getMonth() &&
        year === new Date().getFullYear()
          ? 'active'
          : '';
      const fullDate = new Date(
                                i,
                                new Date().getMonth(),
                                new Date().getFullYear()
                              )
      haveNotification = getEventStatus(fullDate);
      console.log(i);
      lit += haveNotification ? 
                    (

                      `<li class="${isToday}">${i}<span class="calendar-badge badge-notification bg-danger">1</span></li>`


                    )

                    : `<li class="${isToday}">${i}</li>`;
    }
    for (let i = dayEnd; i < 6; i++) lit += `<li class="inactive">${i - dayEnd + 1}</li>`;
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
      } else date = new Date();
      manipulate();
    })
  );

  manipulate();
}
