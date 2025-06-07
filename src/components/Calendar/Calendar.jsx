import React,{useEffect} from 'react'
import { events } from './event.js'; 
import { Stack,Box } from '@mui/material';
import { alpha, styled } from '@mui/material/styles';
import {
  CalendarInitialize,
} from './CalendarInitialize.jsx';

function Calendar() {

  const dotEvents = 
          [
            {type:"active",text:"Bugünün Tarihi"},
            {type:"past",text:"Geçmişteki etkinlikler"},
            {type:"upcoming",text:"Yaklaşan etkinlikler"},
            {type:"future",text:"Gelecekteki etkinlikler"},
          ] //BU KISIM ELEMENTLERİN CSS VE TEXTLERİ İÇİN VAR

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

      <CalendarInitialize 
        importedEvents={events} 
      >
      </CalendarInitialize>
    </div>
  )
}

export default Calendar