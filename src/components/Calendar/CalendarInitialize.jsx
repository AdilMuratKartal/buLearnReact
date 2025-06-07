import React, { useState, useEffect } from 'react';
import Tooltip, { tooltipClasses } from '@mui/material/Tooltip';
import Button from '@mui/material/Button';
import { styled } from '@mui/material/styles';
import KeyboardArrowRightIcon from '@mui/icons-material/KeyboardArrowRight';
import KeyboardArrowLeftIcon from '@mui/icons-material/KeyboardArrowLeft';
import './Calendar.css';
import { Typography } from '@mui/material';

// Fully React-based Calendar component
export function CalendarInitialize({ importedEvents = [] }) {
  // Styled light tooltip
  const LightTooltip = styled(({ className, ...props }) => (
    <Tooltip {...props} classes={{ popper: className }} />
  ))(({ theme }) => ({
    [`& .${tooltipClasses.tooltip}`]: {
      backgroundColor: theme.palette.common.white,
      color: 'rgba(0, 0, 0, 0.87)',
      boxShadow: theme.shadows[1],
      fontSize: 11,
    },
  }));

  // Current date state
  const today = new Date();
  const [current, setCurrent] = useState({
    year: today.getFullYear(),
    month: today.getMonth(),
  });
  const [days, setDays] = useState([]);

  // Helper: parse YYYY-MM-DD
  function parseEventDate(dateStr) {
    const [y, m, d] = dateStr.split('-').map(Number);
    return new Date(y, m - 1, d);
  }

  // Group events by date string
  function groupEventsByDay() {
    return importedEvents.reduce((acc, ev) => {
      acc[ev.date] = acc[ev.date] || [];
      acc[ev.date].push(ev);
      return acc;
    }, {});
  }

  // Render event titles for a given date
  function getEventGroupInfo(eventDayGroup, dateObj) {
    const dateKey = dateObj.toISOString().split('T')[0];
    const group = eventDayGroup[dateKey] || [];
    if (!group.length) return null;
    return (
      <div>
        {group.map((item, idx) => (
          <Typography sx={{display:"block"}} key={idx} variant="caption">
            {item.title}
          </Typography>
        ))}
      </div>
    );
  }

  // Generate days whenever month or events change
  useEffect(() => {
    const { year, month } = current;
    const firstDayIndex = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();
    const prevLast = new Date(year, month, 0).getDate();
    const arr = [];
    const eventDayGroup = groupEventsByDay();

    // Previous month days
    for (let i = firstDayIndex; i > 0; i--) {
      arr.push({ day: prevLast - i + 1, css: 'inactive', key: `p${i}` });
    }
    // Current month days
    for (let i = 1; i <= lastDate; i++) {
      const dateObj = new Date(year, month, i);
      const status = getEventStatus(dateObj);
      const isToday =
        i === today.getDate() && year === today.getFullYear() && month === today.getMonth();
      const css = status || (isToday ? 'active' : '');
      arr.push({
        day: i,
        css,
        key: `c${i}`,
        eventInfo: getEventGroupInfo(eventDayGroup, dateObj),
      });
    }
    // Next month filler
    const lastDayIndex = new Date(year, month, lastDate).getDay();
    for (let i = lastDayIndex + 1; i <= 6; i++) {
      arr.push({ day: i - lastDayIndex, css: 'inactive', key: `n${i}` });
    }

    setDays(arr);
  }, [current, importedEvents]);

  // Determine event status
  function getEventStatus(fullDate) {
    const fd = new Date(fullDate);
    fd.setHours(0, 0, 0, 0);
    const td = new Date();
    td.setHours(0, 0, 0, 0);

    const dateKey = fd.toISOString().split('T')[0];
    const matched = importedEvents.find(ev => ev.date === dateKey);
    if (!matched) return '';
    const ed = parseEventDate(matched.date);
    ed.setHours(0, 0, 0, 0);
    if (ed.getTime() === td.getTime()) return 'today';
    if (ed < td) return 'past';
    const diff = Math.ceil((ed - td) / (1000 * 60 * 60 * 24));
    return diff <= 15 ? 'upcoming' : 'future';
  }

  // Month navigation handlers
  const prevMonth = () =>
    setCurrent(({ year, month }) =>
      month > 0 ? { year, month: month - 1 } : { year: year - 1, month: 11 }
    );
  const nextMonth = () =>
    setCurrent(({ year, month }) =>
      month < 11 ? { year, month: month + 1 } : { year: year + 1, month: 0 }
    );

  const months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  return (
    <div className="calendar-container">
      <header className="calendar-header">
        <p className="calendar-current-date">
          {months[current.month]} {current.year}
        </p>
        <div className="calendar-navigation">
          <Button onClick={prevMonth} sx={{ padding: 0, minWidth: 'fit-content' }}>
            <KeyboardArrowLeftIcon sx={{ fontSize: 30 }} />
          </Button>
          <Button onClick={nextMonth} sx={{ padding: 0, minWidth: 'fit-content' }}>
            <KeyboardArrowRightIcon sx={{ fontSize: 30 }} />
          </Button>
        </div>
      </header>
      <div className="calendar-body">
        <ul className="calendar-weekdays">
          {['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map(d => <li key={d}>{d}</li>)}
        </ul>
        <ul className="calendar-dates">
          {days.map(d => (
            <LightTooltip key={d.key} title={d.eventInfo || ''} placement="bottom">
              <li className={d.css}>{d.day}</li>
            </LightTooltip>
          ))}
        </ul>
      </div>
    </div>
  );
}
