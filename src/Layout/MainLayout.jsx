import React, { useState,useEffect,useMemo } from 'react'
import SideBar from '../components/SideBar/SideBar'
import Header from '../components/Header/Header'
import { Box, Button, Paper,useMediaQuery} from '@mui/material'
import { styled } from '@mui/material/styles'
import { useSelector, useDispatch } from 'react-redux';
import { setIsMobile,toggleSidebar } from '../redux/slices/uiSlice';
import { Height } from '@mui/icons-material'
import HomePage from '../pages/HomePage/HomePage'
import Courses from '../pages/CoursesPage/Courses'
import Grades from '../pages/GradesPage/Grades'
import Calendar from '../pages/CalendarPage/Calendar'
import CertificatesBadges from '../pages/CertificatesBadgesPage/CertificatesBadges'
import Competencies from '../pages/CompetenciesPage/Competencies'
import LearningPath from '../pages/LearningPathPage/LearningPath'



const expandedDrawerWidth = 200;
const stdDrawerWidth = 82;

// isExpanded prop'unu Paper'dan geçiriyoruz ve stil hesaplıyoruz 
const Item = styled(Paper, {
  shouldForwardProp: (prop) => prop !== 'isExpanded' && prop !== 'isMobile',
})(({ theme, isExpanded,isMobile }) => ({
  width: isMobile? 0 : isExpanded ? expandedDrawerWidth : stdDrawerWidth,
  transition: theme.transitions.create('width', {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.enteringScreen,
  }),
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
}))



export default function MainLayout() {

    // Cache'lenmiş bileşenler
  const cachedComponents = useMemo(() => [
    <HomePage key="home" />,
    <Courses key="course" />,
    <Grades key="grades" />,
    <Calendar key="calendar" />,
    <CertificatesBadges key="certificatesBadges" />,
    <Competencies key="competencies" />,
    <LearningPath key="learningPath" />
  ], []);

  const isOpen = useSelector(state => state.ui.isOpen);
  const isMobile = useSelector(state => state.ui.isMobile);
  const selectedIndex = useSelector(state => state.ui.selectedIndex);
  const dispatch = useDispatch();
  const mobile = useMediaQuery('(max-width:900px)')

  useEffect(()=> {
    dispatch(setIsMobile(mobile))
  },[])

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column'}}>

      {/* Başlık */}
      <Box>
        <Header />
      </Box>

      {/* Yan yana Sidebar ve içerik */}
      <Box sx={{ display: 'flex', alignItems: 'flex-start'}}>
        {/* SideBar */}
        <Item isExpanded={isOpen} isMobile={isMobile} sx={{backgroundColor: "black"}}>
          <SideBar />
        </Item>

        {/* İçerik kısmı, kalan boş alanı kaplasın , Sadece aktif bileşeni render edilsin */}
        <Box sx={{ flexGrow: 1,height: '100%', }}>
            {cachedComponents[selectedIndex]}
        </Box>
      

      </Box>

    </Box>
  )
}
