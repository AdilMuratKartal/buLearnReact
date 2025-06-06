import React,{useEffect} from 'react'
import KeyboardArrowRightIcon from "@mui/icons-material/KeyboardArrowRight";
import KeyboardArrowLeftIcon from '@mui/icons-material/KeyboardArrowLeft';
import './Calendar.css'
import {
  initializeCalendar,
} from './CalendarInitialize';
import { events } from './event'; 
import { Stack,Box } from '@mui/material';
import { alpha, styled } from '@mui/material/styles';

function Calendar() {

  const dotEvents = 
          [
            {type:"active",text:"Bugünün Tarihi"},
            {type:"past",text:"Geçmişteki etkinlikler"},
            {type:"upcoming",text:"Yaklaşan etkinlikler"},
            {type:"future",text:"Gelecekteki etkinlikler"},
          ]

  useEffect(() => {
    initializeCalendar(
        'calendar-current-date',
        'calendar-dates',
        'calendar-prev',
        'calendar-next',
        events
    );
  }, []);

  const DotBox = styled(Box)(({ theme }) => ({
    width:"100%",
    display:"flex",
    flexDirection:"row",
    justifyContent:"center",
    alignItems:"center",
    gap: "10px"
  }));; 

  return (
    <div>

      <Stack 
        direction="row" 
        spacing={2} 
        sx={{
          justifyContent: "center",
          alignItems: "center",
          flexWrap: "wrap",
          width: "100%",
        }}
      >
        {
          dotEvents.map((dotEvent) =>(
            <DotBox key={dotEvent.type}>
              <span>{dotEvent.text}</span>
              <div className={`event--info--dot ${dotEvent.type}`}></div>
            </DotBox>
          ))
        }
      </Stack>

      <div className="calendar-container">
          <header className="calendar-header">
          {/* these IDs must match what initializeCalendar is looking for */}
          <p id="calendar-current-date" className="calendar-current-date"></p>
          <div className="calendar-navigation">
              <KeyboardArrowLeftIcon
              id="calendar-prev"
              className="material-symbols-rounded" 
              sx={{ 
                  fontSize: "30px", 
                  fontWeight: "bold",
                  '&:hover':{
                      background: "#f2f2f2",
                      borderRadius: 10
                  }
              }} 
              />
              <KeyboardArrowRightIcon 
              id="calendar-next"
              className="material-symbols-rounded" 
              sx={{ 
                  fontSize: "30px", 
                  fontWeight: "bold",
                  '&:hover':{
                      background: "#f2f2f2",
                      borderRadius: 10
                  }
              }} 
              />
          </div>
          </header>
          <div className="calendar-body">
          <ul className="calendar-weekdays">
              {['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map(d => <li key={d}>{d}</li>)}
          </ul>
          {/* and this UL needs the matching ID too */}
          <ul id="calendar-dates" className="calendar-dates"></ul>
          </div>
      </div>
    </div>
  )
}

export default Calendar